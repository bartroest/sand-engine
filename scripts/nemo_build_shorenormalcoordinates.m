function [ls,cs,z]=nemo_build_shorenormalcoordinates(D,x,y,z)
%nemo_build_shorenormalcoordinates Transforms RD to local shorenormal coordinates.
%
% RD-coordinates are rotated about 311.3 degrees clockwise around the jarkus
% transect origin closest to the Rotterdam Waterway.
%
% Input: D: datastruct
%        x: RD_x coordinates
%        y: RD_y coordinates
%        z: altitude coordinates (optional)
%
% Output: ls: alongshore coordinates
%         cs: cross-shore coordinates
%         z: altitude coordinates (optional)
%
% Example:
%   [D.ls,D.cs]=nemo_build_shorenormalcoordinates(D,D.x,D.y);
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

x1=x(:)';
y1=y(:)';

temp=[cosd(311.3), -sind(311.3); sind(311.3), cosd(311.3)]*[x1-D.rsp_x(1);y1-D.rsp_y(1)];
ls=reshape(temp(1,:),size(x));
cs=reshape(temp(2,:),size(x));
end
%EOF