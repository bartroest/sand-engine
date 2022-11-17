function [xval,yval]=nemo_depth_contour_xy(D,z,depth,t)
%NEMO_DEPTH_CONTOUR_XY Finds the most seaward position of the desired depth on the RD-XY grid.
% Uses jarkus_distancetoZ
%
% Input:
%   D: datstruct
%   z: altitude fieldname [string]
%   depth: altitude level [scalar]
%   t: time index [scalar]
% 
% Output:
%   xval: Easting [m RD]
%   yval: Northing [m RD]
%
% Syntax: [xval,yval]=nemo_depth_contour_xy(D,'altitude',0,t_idx)
%
% See also: nemo, jarkus_distancetoZ, nemo_depth_contour.

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

xval=nan(size(D.(z),2),1);
yval=nan(size(D.(z),2),1);

for n=1:size(D.(z),2);
    
    xtemp=jarkus_distancetoZ(depth,squeeze(D.(z)(t,n,:)),D.x(n,:));
    xval(n)=xtemp(end);
    
    ytemp=jarkus_distancetoZ(depth,squeeze(D.(z)(t,n,:)),D.y(n,:));
    yval(n)=ytemp(end);
    
end
