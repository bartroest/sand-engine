function z_int=nemo_interp_jarkus(DL)
%NEMO_INTERP_JARKUS Interpolates Jarkus transects to surveygrid (5m spacing instead of 10m).
%
%   Jarkus contains only 1 point per 10 m in cross-shore direction for
%   bathymetry surveys. This script interpolates this to grid resolution.
%
%   Syntax:
%       z_int=nemo_interp_jarkus(DL);
%
%   Input: 
%       DL: Jarkus data struct
%
%   Output:
%   	z_int: cross-shore interpolated altitudes.
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
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
z_int=nan(size(DL.altitude)); 
for t=1:size(DL.altitude,1); 
    for i=1:length(DL.alongshore);%index_shore; 
        mask_data=~isnan(DL.altitude(t,i,:));
        if sum(mask_data)>2;
            mask_query=DL.cross_shore>=min(DL.cross_shore(mask_data)) & DL.cross_shore<=max(DL.cross_shore(mask_data));
            z_int(t,i,mask_query)=interp1(DL.cross_shore(mask_data),squeeze(DL.altitude(t,i,mask_data)),DL.cross_shore(mask_query),'linear');
        end
    end
end
end