function [gx, gy, g, th]=nemo_gradients(D,z,coord,index,t_index)
%NEMO_GRADIENTS calculates the gradient along axes of the specified coordinate system.
%
% Calculates the terrain gradients per point. Gradient and direction are
% calculated, as well as gradients along coordinate axes.
%
% Coordinate systems: RD-xy: 'xy' (actual RD-coordinates)
%                     RSP:   'LC' (Longshore,Cross-shore rectified RSP)
%                     RD-rotated: 'lscs' (Rotated-shifted RD to be approx shorenormal)
%
% Input:
%       D: datastruct;
%       z: altitude fieldname
%       coord: coordinate system see ^^
%       index: alongshore indices
%       t_index: time indices
%
% Output:
%       gx: gradient in coordinate system x-direction [-];
%       gy: gradient in coordinate system y-direction [-];
%       g : absolute gradient [-];
%       th: direction of absolute gradient w.r.t. coordinate system [rad];
%
% Example:
%       [gx, gy, g, th]=nemo_gradients(D,'altitude','lscs',Index.all,7)
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

gx=nan(size(D.(z)));
gy=nan(size(D.(z)));
%g= nan(size(D.x));

for t=t_index
    switch coord
        case {'xy','yx','RD','rd'}
            [gx(t,1:end-1,1:end-1), gy(t,1:end-1,1:end-1)]=gradient2(D.x, D.y, squeeze(D.(z)(t,index,:)));
        case {'CL','LC'}
            [gx(t,1:end-1,1:end-1), gy(t,1:end-1,1:end-1)]=gradient2(D.L, D.C, squeeze(D.(z)(t,index,:)));
        case {'csls','lscs'}
            [gx(t,1:end-1,1:end-1), gy(t,1:end-1,1:end-1)]=gradient2(D.ls,D.cs,squeeze(D.(z)(t,index,:)));
    end
end
[th,g]=cart2pol(gx,gy);
end