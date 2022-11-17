function [S,Surveylines]=nemo_build_surveylines(OPT)
%NEMO_BUILD_SURVEYLINES Builds the transects for the Delfland coast.
% 
% This function creates the transect definitions for the Combined
% morphology surveys at the Delfland coast. It combines "Zandmotor" and
% "Nemo" definitions, and makes them compliant. Original transect
% definitions are found in .mat files on the zandmotordata svn.
%
% The "Zandmotor" and "Nemo" datasets are spatially adjacent.
%
% Surveylines are ordered from South to North along the Delfland coast,
% thus starting in Hoek van Holland. Additional surveylines are added to
% cover the edge near HvH.
% The double transect in the Nemo and ZM area is only present once.
%
% Input:
%   OPT: options struct from nemo.m
%
% Output:
%   S: surveylines as struct.
%   Surveylines: surveylines as vector struct.
%
% Example
%   S = nemo_build_surveylines(OPT);
%
%   See also: nemo

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2016-2021 TU Delft
%       Bart Roest
%
%       l.w.m.roest@tudelft.nl
%
%       Stevinweg 1
%       2628CN Delft
%
%   This library is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this library.  If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>

% $Id: $
% $Date: $
% $Author: $
% $Revision: $
% $HeadURL: $
% $Keywords: $

%% Code
N=load([OPT.basepath,'..\scripts\matlab\NeMo_surveylines.mat']); %Load Nemo area
Z=load([OPT.basepath,'..\scripts\matlab\SurveylinesZM.mat']); % Load Zandmotor area
[ H, rsp_x, ~, jaid ]=nemo_build_extra_transects; %Define missing transects near HvH.

fn=fieldnames(N.Surveylines.CS); %Query fieldnames
nof=length(fn); %number of fieldnames
nopn=length(N.Surveylines.CS); %number of Nemo transects
nopz=length(Z.Surveylines.CS); %number of ZM transects
nope=length(H.x_origin); %number of Extra transects

for f=1:nof
    clear a b c d
    k=1;
    for i=nopn:-1:1 %1:1:nopn
       a(k,:)=N.Surveylines.CS(i).(fn{f});
       k=k+1;
    end
    
    %k=1;
    for j=2:1:nopz %nopz:-1:2
       b(j-1,:)=Z.Surveylines.CS(j).(fn{f});
       %k=k+1;
    end
    %a=a([1:427,429,428,430:end],:); %There are two transects switched in 'NeMo_surveylines.mat', which is corrected here. These transects are 78 and 79 in the .mat file.;
    % Switching fixed due to new commit of 'NeMo_surveylines.mat' to zandmotordata.nl
    a=a';
    b=b';
    c=H.(fn{f}); c=fliplr(c);
    d=[c(:,1:end),a(:,1:290),b(:,1:end),a(:,291:end)];
    %d[Extra_HvH ,Nemo_zuid ,Zandmotor ,Nemo_noord  ];
    %d[1:14      ,15:
    %d=[a(:,1:216),b(:,1:end),a(:,217:506),c(:,1:end)];
    
%     fprintf(1,'fieldname: %s \n',fn{f});
%     fprintf(1,'a: %d %d \n',size(a));
%     fprintf(1,'b: %d %d \n',size(b));
%     fprintf(1,'c: %d %d \n',size(c));
%     fprintf(1,'d: %d %d \n',size(d));
%     
    for n=1:nopn+nopz+nope-1
       Surveylines.CS(n).(fn{f})=d(:,n);
    end
    S.(fn{f})=d;
    
end
%%%S.kind=[2.*ones(1,216),ones(1,size(b,2)),2.*ones(1,(506-217)),3.*ones(1,size(c,2))];
%%%S.kind=[2.*ones(1,size(a(1,1:216),2)),ones(1,size(b,2)),2.*ones(1,size(a(:,217:506),2)),3.*ones(1,size(c,2))];
%%% kind=[nemo_North                  ,ZM               ,Nemo_South                     ,extra];
%% Patch incorrect linetypes 1=jarkus, 2=jarkus_verdicht 3=shore.
lt=S.linetype;


%DL=nemo_jarkus("jarkusncpath",9); %Input the location of the jarkus
%transect netCDF!!
[~,zn,~]=intersect(round(S.x_origin),round(rsp_x(jaid>=9e6 & jaid<10e6)));
lt(zn)=0;
lt(lt==1)=3;
lt(lt==0)=1;
S.linetype=lt;

S.kind=[3.*ones(1,size(c,2)),2.*ones(1,size(a(:,1:290),2)),ones(1,size(b,2)),2.*ones(1,size(a(1,291:end),2))];
% kind=[Extra_HvH           ,Nemo_zuid                    ,Zandmotor        ,Nemo_noord                     ];
for n=1:nopn+nopz+nope-1
    Surveylines.CS(n).kind=S.kind(n);
    Surveylines.CS(n).linetype=S.linetype(n);
end

%save([OPT.basepath,'\..\scripts\matlab\Surveylines_Delfland.mat'],'Surveylines','S');
save([OPT.outputfolder,'Surveylines_Delfland.mat'],'Surveylines','S');
end

function [ H, rsp_x, rsp_y, jaid ] = nemo_build_extra_transects
%NEMO_BUILD_EXTRA_TRANSECTS Defines missing transects near HvH.
%
% Matrix order is North to South, 1925(CS)*14(LS)
% The NEMO measurement area is not entirely covered with transects. This
% script adds the missing transects near Hoek van Holland. (The area
% between the 'last' Jarkus transect and the breakwater (Noorderdam).)
%
% Bart Roest, 2016
% TU Delft

%DL=load('Jarkus_DL'); % Jarkus transects for Delfland (9).
%jpath=input('File path of Jarkus transect.nc: ','s');
%DL=nemo_jarkus(jpath);
%x0=67273; %x0=DL.rsp_x(end);
%y0=444337; %y0=DL.rsp_y(end);
%angle0=306; %angle0=DL.angle(end);
%JAID0=11850; %JAID0=DL.id(end);
%JAID0=DL.id(end)-9000000; %Subtract kustvakID, because .mat files also don't have it.

%Check openDAP sever; fallback is local file.
try
    odurl='http://opendap.deltares.nl/thredds/dodsC/opendap/rijkswaterstaat/jarkus/profiles/transect.nc';
    nc_info(odurl);
catch
    try
        odurl='http://opendap.tudelft.nl/thredds/dodsC/data2/deltares/rijkswaterstaat/jarkus/profiles/transect.nc';
        nc_info(odurl);
    catch
        odurl=input('Jarkus NetCDF not found. Input file location: ','s');
    end
end
rsp_x=nc_varget(odurl,'rsp_x');
rsp_y=nc_varget(odurl,'rsp_y');
ang=nc_varget(odurl,'angle');
jaid=nc_varget(odurl,'id');

JAID0=9011850; %ID of South-Western most transect in Delfland.
x0=rsp_x(jaid==9011850); % origin x-coordinate [m RD]
y0=rsp_y(jaid==9011850); % origin y-coordinate [m RD]
angle0=ang(jaid==9011850); % transect orientation [deg N]

cross_shore=[-2110:5:7510]; %Cross-shore distance from origin [m]

spacing=25; % Alongshore spacing of transects [m]
noet=14; % Number of extra transects.

for n=1:noet+1
   H.x_origin(n)=x0-(n-1)*spacing*sind(angle0-270); %RD_x position RSP
   H.y_origin(n)=y0-(n-1)*spacing*cosd(angle0-270); %RD_y position RSP
   H.angle(n)=angle0;                               %Angle wrt North
   H.JarkusAlongID(n)=JAID0+round((n-1)*spacing/10);%Alongshore position in dam w.r.t Den Helder(+kustvak id.)
   H.linetype(n)=3;                                 %Type: Jarkus line=1; additional=3;
   H.dist(:,n)=cross_shore;                          %Cross-shore distance from RSP
   H.xi(:,n)=H.x_origin(n)+cross_shore*sind(angle0); %RD_x positions
   H.yi(:,n)=H.y_origin(n)+cross_shore*cosd(angle0); %RD_y positions
end
H.linetype(1)=1; %Jarkus line=1; additional=3;
end