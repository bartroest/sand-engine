function [dhdx,h]=nemo_slope_VH(D,VH)
%NEMO_SLOPE_VH Determines the CS-slope from the Horizontal Volume slices struct.
%
%   Calculates profile slope from normalised volume slices [m^3/m/m]. Volume per
%   horizontal slices is normalised to cross-shore position. Slope is obtained
%   from the difference between cs-postions for subsequent layers.
%
%   Syntax:
%       dhdx = nemo_slope_VH(D,VH)
%
%   Input: 
%       D: Data struct
%       VH: Volume struct for horizontal slices
%
%   Output:
%   	dhdx: beach slope between layers.
%
%   Example:
%       dzdt = nemo_slope_VH(D,VH);
%
%   See also: nemo, nemo_volumes_h

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
%% DH/DX
dh=nanmean(diff(VH.heights(:)));
dhdx=nan(length(D.time),length(D.alongshore),length(VH.heights)-2); 
for t=1:length(D.time);
    dhdx(t,:,:)=dh./(diff(squeeze(VH.volume(t,:,:)./dh),1,2)); 
end
dhdx(isinf(dhdx))=nan;
h=VH.heights(2:end-1);
end
%EOF