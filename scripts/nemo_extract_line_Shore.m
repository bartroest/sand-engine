function line = nemo_extract_line_Shore(XYZ,line,spacing,varargin)
%nemo_extract_line_Shore Extracts data from the surveypath in the vicinity of the Surveyline.
% function to extract transect data from the survey path
% input:    survey path: XYZ.X;XYZ.Y;XYZ.Z;XYZ.T
%           line to interpolate : Surveylines-struct
%           distance around line to interpolate: spacing
% varargin: 'figs': 0 or 1; plot figures for additional checks (very slow!)
% output:   characterisitcs of a subset of data near the surveyline

% updated March 2013
% now needs the line to interpolate data on to be inserted as a full
% vector, rather than only a begin and endpoint
%
% updated October 2016 - October 2017
% Bart Roest

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

%% Input options
 OPT.figs=false;
 OPT=setproperty(OPT,varargin);

%% slope line -> Commented because this data is already in Surveylines.mat
%line.angle=atand((line.xi(end)-line.xi(1))/(line.yi(end)-line.yi(1)));

%%% distance along line:
%line.dist=sqrt((line.xi-line.xi(1)).^2+(line.yi-line.yi(1)).^2);
% Check: line.dist(2)-line.dist(1) must be equal to the inputed spacing

%% Zone around surveyline used for profile ()
% Rectangular bounding box around the theoretical transect.
line.datazone(:,1)=[  line.xi(1)+spacing*cosd(line.angle) line.xi(end)+spacing*cosd(line.angle)   line.xi(end)-spacing*cosd(line.angle) line.xi(1)-spacing*cosd(line.angle) ];
line.datazone(:,2)=[  line.yi(1)-spacing*sind(line.angle) line.yi(end)-spacing*sind(line.angle)   line.yi(end)+spacing*sind(line.angle) line.yi(1)+spacing*sind(line.angle) ];

%% Cut full survey to only data in zone around profile
[in] = inpolygon(XYZ.X,XYZ.Y,line.datazone(:,1),line.datazone(:,2));
good=+in;
%sum(good); % number of data points in polygon
datafields = fieldnames(XYZ);

if sum(good) <= 2 % number of data points in polygon
    disp('no data on line')
    % check if XYZ is in right format it should be 1 row and a lot of columns
    
    for i=1:length(datafields)
        eval(['line.data.' char(datafields(i)) '= NaN;']);
    end
    line.data.datazone(1:4,1:2)=NaN;
    line.data.dist=NaN;
    line.data.dist_haaks=NaN;
else
    for i=1:length(datafields)
        eval(['line.data.' char(datafields(i)) '= XYZ.' char(datafields(i)) '((good == 1));']);
    end
    % Check: show datazone around line
    if OPT.figs
        figure
        plot(line.datazone(:,1),line.datazone(:,2),'x-b')
        hold on
        plot(line.xi,line.yi,':k')
        axis equal
        scatter(line.data.X,line.data.Y,5,line.data.Z)
        legend('borders datazone','exact surveyline', 'surveydata')
    end
    
    % get position survey points along the surveyline with respect to origin
    line.data.dist=      (line.data.X-line.x_origin)*sind(line.angle)+(line.data.Y-line.y_origin)*cosd(line.angle);
    line.data.dist_haaks=(line.data.X-line.x_origin)*cosd(line.angle)-(line.data.Y-line.y_origin)*sind(line.angle);
    
    %Sort data points along transect.
    [line.data.dist ,ii]=sort(line.data.dist);
    line.data.dist_haaks=line.data.dist_haaks(ii);
    line.data.X=line.data.X(ii);
    line.data.Y=line.data.Y(ii);
    line.data.Z=line.data.Z(ii);
    
    %If more datapoints with the same coordinates exist; delete the second one.
    dd=diff(line.data.dist);
    if min(abs(dd))==0
        a=find(dd==0);
        line.data.dist(a)=[];
        line.data.dist_haaks(a)=[];
        line.data.X(a)=[];
        line.data.Y(a)=[];
        line.data.Z(a)=[];
    end
end

%% Check: show interpolation around line
if OPT.figs
    warning off
    [xgrid, ygrid] = meshgrid(line.xi,line.yi);
    zgrid = griddata(XYZ.X,XYZ.Y,XYZ.Z,xgrid,ygrid);
    warning on
    figure
    plot(line.datazone(:,1),line.datazone(:,2),'x-b')
    hold on
    plot(line.xi,line.yi,':k')
    axis equal
    pcolor(xgrid,ygrid,zgrid)
    scatter(line.data.X,line.data.Y,5,line.data.Z,'MarkerEdgeColor','w')
    legend('borders datazone','exact surveyline','interpolation' ,'surveydata')
    shading interp

    line.zi = interp2(xgrid,ygrid,zgrid,line.xi,line.yi);
    figure
    plot(line.dist,line.zi,'.-');
    hold all
    plot(line.data.dist,line.data.Z,'.r')
    legend('interpolated bathy','depths surveypoints in zone around surveyline')
end
%EOF