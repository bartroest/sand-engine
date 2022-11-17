function alti_interp=nemo_jarkus_interp_cs(DL)
%NEMO_JARKUS_INTERP_CS Interpolates Jarkus data in cross-shore direction to 5m.
% uniform spacing (matching the grid).
%
% Syntax: altitude_interpolated=nemo_jarkus_interp_cs(Jarkus_struct);
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

alti_interp=nan(size(DL.altitude)); %Preallocate matrix
for t=1:size(DL.altitude,1); %For all time
    for n=1:size(DL.altitude,2); %For all transects
        mask_data=~isnan(squeeze(DL.altitude(t,n,:))); %all non-nans in transect.
        if sum(mask_data)>2;
            mask_query=DL.cross_shore>=min(DL.cross_shore(mask_data)) & DL.cross_shore<=max(DL.cross_shore(mask_data)); %Query only between data, no extrapolation.
            alti_interp(t,n,mask_query)=interp1(DL.cross_shore(mask_data),squeeze(DL.altitude(t,n,mask_data)),DL.cross_shore(mask_query),'linear');
        end
    end 
end
%EOF