function [VH]=nemo_volumes_h_all(D,altitude,index,heights,Time)
%NEMO_VOLUMES_H_ALL Calculates volume changes of transects in horizontal slices.
%
% Profiles are divides in horizontal layers. Volume changes are calculated per
% layer. When scaled by layer height averaged cross-shore position changes are
% obtained: [m^3/m_alongshore/m_height].
%
% jarkus_getVolume interpolates linearly when gaps in the transectdata
% occur, except when this happens at the boundaries, then the transects are
% truncated to a position with data.
%
% Syntax [Volume_struct,index,t_index]=nemo_volumes(D,altitude field,...
%                                   alongshore indices,time indices,reach)
%
% Input: D (datastruct) [D]
%        altitude (fieldname of altitude matrix) ['altitude','z_jnz', etc ]
%        index (alongshore transect indices) [range, e.g. 1:644]
%        t_index (time indices) [range, e.g. 1:38]
%        heights (boundaries of altitude slices) [e.g -12:0.25:6];
%
% Output: VH (volume struct)
%         
% Example:
% [VH]=nemo_volumes(D,'altitude',[1:10:length(D.alongshore)],[-12:1:5]);
%
% Meta: 'volume:    volume per transect'
%       'dv:        volume change per transect'
%       'accretion: volume where bed is higher'
%       'erosion:   volume where bed is lower'
%       'ratio:     parameter; dv./(acc+ero)'
%
% See also: jarkus_getVolume, nemo_depth_contour, nemo.
%

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
VH=struct('volume',   nan(size(z,1),size(z,2),length(heights)-1),...
          'dv',       nan(size(z,1),size(z,2),length(heights)-1),...
          'accretion',nan(size(z,1),size(z,2),length(heights)-1),...
          'erosion',  nan(size(z,1),size(z,2),length(heights)-1),...
          'dt',       nan(size(z,1),size(z,2),length(heights)-1),...
          'heights',  heights');
        
%% Calculate Volumes
for i = index;
    if i>=305 && i<=428;
        t_index=Time.all;
    elseif i>=94 && i<=160;
        t_index=Time.vbnemo;
    else
        t_index=Time.nemo;
    end
    %t_index=sum(~isnan(squeeze(z(:,i,:))'))>10;
    for t = t_index;
        if sum(~isnan(squeeze(z(t,i,:))))>2;
            for h = 1:length(heights)-1;
                VH.volume(t,i,h) = jarkus_getVolume(D.dist,squeeze(z(t,i,:)), heights(h+1), heights(h), -500, 3000);
            end
        end
    end
    fprintf(1,'%f \n',i);
end
    
for i = index;
    if i>=305 && i<=428;
        t_index=Time.all;
    elseif i>=94 && i<=160;
        t_index=Time.vbnemo;
    else
        t_index=Time.nemo;
    end
    %t_mask=sum(~isnan(squeeze(z(:,i,:))'))>10;
    %tt=1:length(t_mask);
    %t_index=tt(t_mask);
    for t=t_index(1:end-1);
        [~, ~, t_idx]=intersect(t,t_index); %Finds the current position in t_index
        VH.dt(t,i)=D.time(t_index(t_idx+1))-D.time(t);
        if sum(~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))))>2 ;
            for h = 1:length(heights)-1;
                [VH.dv(t,i,h), temp]=jarkus_getVolume(D.dist, squeeze(z(t,i,:)), heights(h+1), heights(h), -500, 3000, D.dist, squeeze(z(t_index(t_idx+1),i,:))); 
                VH.accretion(t,i) = temp.Volumes.Accretion;
                VH.erosion(t,i)   = temp.Volumes.Erosion;
            end
        end
    end
    fprintf(1,'%f \n',i);
end
%% Calculate Volumes
% % for h = 1:length(heights)-1;
% %     for t = t_index;
% %         for i = index;
% %             if sum(~isnan(squeeze(z(t,i,:))))>2;
% %                 mask=~isnan(squeeze(z(t,i,:))) & D.dist>=V.dist_on(i);
% %                 minx=min(D.dist(mask)); 
% %                 maxx=max(D.dist(mask));
% %                 V.volume(t,i,h) = jarkus_getVolumeFast(D.dist(mask),squeeze(z(t,i,mask)), heights(h+1), heights(h), minx, maxx);
% %             end
% %         end
% %     end
% % end
% %     
% % for h = 1:length(heights)-1;
% %     for t= t_index(1:end-1);
% %         [~, ~, t_idx]=intersect(t,t_index); %Finds the current position in t_index
% %         V.dt(t)=D.time(t_index(t_idx+1))-D.time(t);
% %         for i = index;
% %             if sum(~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))))>2
% %                 mask=~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))) & D.dist>=V.dist_on(i);
% %                 minx=min(D.dist(mask)); 
% %                 maxx=max(D.dist(mask)); 
% % 
% %                 v1=jarkus_getVolumeFast(D.dist(mask), squeeze(z(t,i,mask)),                heights(h+1), heights(h), minx, maxx); 
% %                 v2=jarkus_getVolumeFast(D.dist(mask), squeeze(z(t_index(t_idx+1),i,mask)), heights(h+1), heights(h), minx, maxx); 
% %                 V.dv(t,i,h)=v2-v1;
% %             end
% %         end
% %     end
% % end
end
%EOF