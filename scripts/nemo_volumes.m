function [V,index,t_index]=nemo_volumes(D,altitude,index,t_index,reach)
%NEMO_VOLUMES Calculates volume changes of transects.
%
% jarkus_getVolume interpolates linearly when gaps in the transectdata
% occur, except when this happens at the boundaries, then the transects are
% truncated to a position with data.
%
% Syntax 
%   [Volume_struct,index,t_index]=nemo_volumes(D,altitude field,...
%                                   alongshore indices,time indices,reach)
%
% Input: 
%   D: (datastruct) [D]
%   altitude: (fieldname of altitude matrix) ['altitude','z_jnz', etc ]
%   index: (alongshore transect indices) [range 1:644]
%   t_index: (time indices) [range 1:38+]
%   reach: (cross-shore (landward) boundary) ['all','contour','other']
%
% Output: 
%   V: (volume struct)
%   index: (see input)
%   t_index: (see input)
%         
% Example:
%   [V, idx, t_idx]=nemo_volumes(D,'altitude',[1:10:length(D.alongshore)],[1,7,37],'all');
%
% Meta: 
%   'volume:    volume per transect'
%   'dv:        volume change per transect'
%   'accretion: volume where bed is higher'
%   'erosion:   volume where bed is lower'
%   'ratio:     parameter; dv./(acc+ero)'
%   'dvdt:      volume change per day per transect'
%   'daccdt:    volume change per day where bed is higher'
%   'derdt:     volume change per day where bed is lower'
%   'dt:        timestep in days'
%
% See also: jarkus_getVolume, nemo_depth_contour, nemo.
%
%Sierd de Vries, 2014
%Bart Roest, 2016

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

%% Preallocate arrays
z=      D.(altitude);
V=struct('volume',  nan(size(z,1),size(z,2)),...
        'dv',       nan(size(z,1),size(z,2)),...
        'accretion',nan(size(z,1),size(z,2)),...
        'erosion',  nan(size(z,1),size(z,2)),...
        'ratio',    nan(size(z,1),size(z,2)),...   
        'dvdt',     nan(size(z,1),size(z,2)),...
        'daccdt',   nan(size(z,1),size(z,2)),...
        'derdt',    nan(size(z,1),size(z,2)),...
        'dt',       nan(size(z,1),1        ),...
        'dist_on',  nan(1        ,size(z,2)),...
        'dist_off', nan(1        ,size(z,2)));%,...
        %'cdv',      nan(size(z,1),size(z,2)),...
        %'cacc',     nan(size(z,1),size(z,2)),...
        %'cero',     nan(size(z,1),size(z,2)),...
        %'dalong',   nan(1        ,size(z,2)));
%        'meta',     cell(1,8)              );

        
% % V.meta=            [{'volume: volume per transect'},...
% %                     {'dv: volume change per transect'},...
% %                     {'accretion: volume where bed is higher'},...
% %                     {'erosion: volume where bed is lower'},...
% %                     {'ratio: dv./(acc+ero)'},...
% %                     {'dvdt: volume change per day per transect'},...
% %                     {'daccdt: volume change per day where bed is higher'},...
% %                     {'derdt: volume change per day where bed is lower'},...
% %                     {'dt: timestep in days'}];
%dT= nan(size(z,1)  ,1);  %diff(D.time(t_index));

switch reach %Determines the cross-shore locations for volume calculations.
    case 'all'
        %c=300.*ones(size(D.alongshore));
        c=1.*ones(size(D.alongshore));
        %Vlugtenburg: Omit dune areas with large errornous altitude changes.
        c(90:162)=nan;
        c(90) =522;
        c(111)=508;
        c(115)=507;
        c(162)=458;
        c(90:162)=floor(interp1([90,111,115,162],[c(90),c(111),c(115),c(162)],[90:162],'linear'));
        d=1924.*ones(size(D.alongshore));
    case 'contour'
        [c, ~, ~, ~]=nemo_depth_contour(D,altitude,-5,t_index(end));
        [d, ~, ~, ~]=nemo_depth_contour(D,altitude,+4,t_index(end));
    case 'jarkus'
        c=1.*ones(size(D.alongshore));
        d=length(D.dist).*ones(size(D.alongshore));
    otherwise
        c=375.*ones(size(D.alongshore));
        %Vlugtenburg
        c(90:162)=nan;
        c(90) =522;
        c(111)=508;
        c(115)=507;
        c(162)=458;
        c(90:162)=floor(interp1([90,111,115,162],[c(90),c(111),c(115),c(162)],[90:162],'linear'));
        
        %Zandmotor
        %c(334:415)=nan;
        c(334:384)=nan;
        c(334)=425;
        c(347)=522;
        c(371)=562;
        c(383)=526;
        c(384)=375;
        %c(400)=477;
        %c(415)=430;
        %c(334:415)=floor(interp1([334,347,371,400,415],[c(334),c(347),c(371),c(400),c(415)],[334:415],'linear'));
        c(334:384)=floor(interp1([334,347,371,383,384],[c(334),c(347),c(371),c(383),c(384)],[334:384],'linear'));
        d=1623.*ones(size(D.alongshore));
end
V.dist_on=D.dist(c);
V.dist_off=D.dist(d);
%% Calculate Volumes
for t = t_index %1:size(topo_time,2)
    for i = index %1:length(trans2run)
        if sum(~isnan(squeeze(z(t,i,:))))>2
            V.volume(t,i) =  jarkus_getVolume(D.dist, squeeze(z(t,i,:)), 10, -15, V.dist_on(i)+5, V.dist_off(i));%, x2, z2)
            %V.volume(t,i) =  jarkus_getVolume(D.dist, squeeze(z(t,i,:)), 25, -20, -1000, 6000);%, x2, z2)
        %else
            %V.volume(t,i) = nan;
        end
    end
end

for t= t_index(1:end-1)
    [~, ~, t_idx]=intersect(t,t_index); %Finds the current position in t_index
    V.dt(t)=D.time(t_index(t_idx+1))-D.time(t);
%    V.dt(t)=D.time_combi(t_index(t_idx+1))-D.time_combi(t);
    for i = index %1:length(trans2run)
        mask=D.dist>=V.dist_on(i) & D.dist<=V.dist_off(i);
        if sum(~isnan(squeeze(z(t,i,mask))) & ~isnan(squeeze(z(t_index(t_idx+1),i,mask))))>10 %30
        %if sum(~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))))>10 %30
            [V.dv(t,i), temp] = jarkus_getVolume(D.dist, squeeze(z(t,i,:)),10, -15, V.dist_on(i), V.dist_off(i), D.dist,squeeze(z(t_index(t_idx+1),i,:)));
            %[V.dv(t,i), temp] = jarkus_getVolume(D.dist, squeeze(z(t,i,:)),25, -20, -1000, 6000,D.dist,squeeze(z(t_index(t_idx+1),i,:)));
           %[net_volume,struct]=jarkus_getVolume(cross-points_1,altitude_1,max_alti,min_alti,onsh-bound,offsh_bound,cross-points_2,altitude_2);
            V.accretion(t,i) = temp.Volumes.Accretion;
            V.erosion(t,i)   = temp.Volumes.Erosion;
        %else
            %dV(t,i)=nan;
        end
    end
end
V.ratio=V.dv./(V.accretion+V.erosion);

%% Calculate Volumes per day
fn=fieldnames(V);
for f=6:8 %dv, accretion, erosion
    for t=1:length(V.dt)
        V.(fn{f})(t,:)=V.(fn{f-4})(t,:)./V.dt(t);
    end
end

% %% TRANSPORT
% binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
% for t = t_index(1:end-1); %1:size(dV,2);
%         V.cacc(t,:)=nancumsum(V.accretion(t,:).*binwidth');
%         V.cero(t,:)=nancumsum(V.erosion  (t,:).*binwidth');
%         V.cdv (t,:)=nancumsum(V.dv       (t,:).*binwidth');
% end
% V.dalong=binwidth;


end
%EOF