function nemo_plot_depthcontour(D,t_idx,depth)
%nemo_plot_depthcontour Plots the outer position of a certain depth on a shore-normal, transect based grid.
%
% Accurate to 5m grid-spacing
%
% Syntax: nemo_plot_depthcontour(Datastruct,[time indices],depth);
%
% See also: nemo_depth_contour

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
figure;
hold on;
%time=1:5:37;
%time=1:37;
%time=[1,13,25,31,37]; %july's
%time=[1,6,16,22,28]; %dec's/jan's
%time=[32:37];
for t=t_idx
%     [~,~,cs,ls]=nemo_depth_contour(D,'altitude',depth,t);
%     h(t)=plot(ls,cs);
    [~,~,Cval]=nemo_depth_contour_accurate(D,'altitude',depth,t);
    h(t)=plot(D.alongshore,Cval);
end
xlabel('Alongshore HvH [m]');
ylabel('Cross-shore HvH [m]');
title([num2str(depth),' m outer contour']);
axis equal;
legend(h(t_idx),datestr(D.time(t_idx)));
%EOF