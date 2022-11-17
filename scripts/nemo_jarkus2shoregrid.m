function [z_jarkus, index_jarkus, index_shore]=nemo_jarkus2shoregrid(DL,D,t)
%NEMO_JARKUS2SHOREGRID Maps Jarkus transects to Shore surveygrid.
%
% Maps Jarkus data for the Delfland area to the transects defined by Shore for
% the Zandmotor/Nemo surveys.
%
% Input:
%   DL = struct with Jarkus-data
%   D = struct with Shore-Surveylines (ZM+Nemo)
%   t= time index of jarkus survey
%
% Output:
%   z_jarkus = altitude matrix for single Jarkus survey mapped on shore grid.
%   index_jarkus = indices of the jarkus grid.
%   index_shore  = corresponding indices of the shore grid.
%
% Example:
%   [z_jarkus, index_jarkus, index_shore]=nemo_jarkus2shoregrid(Jarkus_struct,Shore_struct,time);
%
% See also: nemo

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

z_jarkus=nan(size(D.x));
[~,index_jarkus,index_shore]=intersect(round(DL.rsp_x),round(D.rsp_x)); %Find corresponding origin coordinates
[~,csi]=intersect(DL.cross_shore,D.dist);
z_jarkus(index_shore,:)=squeeze(DL.altitude(t,index_jarkus,csi));

%% Interpolate the Jarkus measurements to shore resolution (5m CS instead of 10m for offshore measurements).
for i=1:length(D.rsp_x);%index_shore; 
    mask_data=~isnan(z_jarkus(i,:));
    if sum(mask_data)>2;
        mask_query=DL.cross_shore>=min(DL.cross_shore(mask_data)) & DL.cross_shore<=max(DL.cross_shore(mask_data));
        z_jarkus(i,mask_query)=interp1(DL.cross_shore(mask_data),z_jarkus(i,mask_data),DL.cross_shore(mask_query),'linear');
    end
end 
end
%EOF