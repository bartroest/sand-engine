function nemo_plot_survey_projection(D,t_index,projection)
%NEMO_PLOT_SURVEY_PROJECTION Projects a matrix on a 3D surf of surveyed altitude.
%
% Plots a 3D surface of a survey, including projections on the xz and xy planes.
% Colorcoding is based on a matrix called projection with dimensions [alongshore
% cross-shore].
%
% Syntax:
%   nemo_project_on_survey(D,t_index,projection);
%
% Input:
%   D: datastruct
%   t_index: single time index of survey [1:38]
%   projection: 644x1925 matrix for color coded projection onto the
%               altitude surface.
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
figure;
su=surf(D.ls,D.cs,squeeze(D.altitude(t_index,:,:)),projection);
hold on;
%clim([0 0.5]); 
colormap(parula);
su.EdgeAlpha=0.3;

xlabel('Distance from HvH [m]');
ylabel('Distance from transect origin #1 [m]');
zlabel('Altitude [m+NAP]');
% colorbarwithylabel('Standard deviation of altitude [m]');
% title('Standard deviation of altitudes projected on altitude of survey 38 (sep 2017)')


su2=surf(D.ls,D.cs,-15*ones(size(D.ls)),projection);
su2.EdgeColor='none';

su3=surf(D.ls,zeros(size(D.ls)),squeeze(D.altitude(t_index,:,:)),projection);
su3.EdgeColor='none';

xlim([0 17500]);
ylim([-1000 3000]);