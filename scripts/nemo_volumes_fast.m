function [V,index,t_index]=nemo_volumes_fast(D,altitude,index,t_index,reach)
%NEMO_VOLUMES Calculates only net volume changes of transects.
%
% nemo_volumes_fast only calculates net volume changes in transects, not gross
% changes or other properties. Use nemo_volumes instead.
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
%        index (alongshore transect indices) [range 1:644]
%        t_index (time indices) [range 1:38]
%        reach (cross-shore (landward) boundary) ['all','contour','other']
%
% Output: V (volume struct)
%         index (see input)
%         t_index (see input)
%         
% Example:
% [V, idx, t_idx]=nemo_volumes(D,'altitude',[1:10:length(D.alongshore)],[1,7,37],'all');
%
% Meta: 'volume:    volume per transect'
%       'dv:        volume change per transect'
%
% See also: jarkus_getVolume, nemo_volumes, nemo_depth_contour, nemo.
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
        'dt',       nan(size(z,1),1        ));
        
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

switch reach
    case 'all'
        c=375.*ones(size(D.alongshore));
    case 'contour'
        [c, ~, ~, ~]=nemo_depth_contour(D,altitude,3,t_index(end));
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
end
V.dist_on=D.dist(c);
%% Calculate Volumes
for t = t_index;
    for i = index;
        if sum(~isnan(squeeze(z(t,i,:))))>2;
            mask=~isnan(squeeze(z(t,i,:))) & D.dist>=V.dist_on(i);
            minx=min(D.dist(mask)); 
            maxx=max(D.dist(mask));
            V.volume(t,i) = jarkus_getVolumeFast(D.dist(mask),squeeze(z(t,i,mask)), 10, -20, minx, maxx);
        end
    end
end

for t= t_index(1:end-1);
    [~, ~, t_idx]=intersect(t,t_index); %Finds the current position in t_index
    V.dt(t)=D.time(t_index(t_idx+1))-D.time(t);
    for i = index;
        if sum(~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))))>2
            mask=~isnan(squeeze(z(t,i,:))) & ~isnan(squeeze(z(t_index(t_idx+1),i,:))) & D.dist>=V.dist_on(i);
            minx=min(D.dist(mask)); 
            maxx=max(D.dist(mask)); 
            
            v1=jarkus_getVolumeFast(D.dist(mask), squeeze(z(t,i,mask)),      10, -20, minx, maxx); 
            v2=jarkus_getVolumeFast(D.dist(mask), squeeze(z(t_index(t_idx+1),i,mask)),10, -20, minx, maxx); 
            V.dv(t,i)=v2-v1;
        end
    end
end

end
%EOF