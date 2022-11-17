function nemo_plot_altitude(D,z);
%NEMO_PLOT_ALTITUDE plots topographical maps of all surveys.
%
%   Plots color maps of the survyed terrain.
%
%   Syntax:
%   	nemo_plot_altitude(D,z)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%
%   Output:
%   	figures
%
%   Example:
%       nemo_plot_altitude(D,'altitude');
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

x=center2corner(D.ls);
y=center2corner(D.cs);

figure;
for t=1:length(D.time);
    pcolorcorcen(x,y,squeeze(D.(z)(t,:,:)));
    colormap(gca,zmcmap);
    clim([-12 7]);
    hold on;
    axis equal;
    xlim([-250 17250]);
    ylim([0 3500]);
    title(datestr(D.time(t),'dd-mmmm-yyyy'));
    xlabel('Distance alongshore from HvH [m]');
    ylabel('Distance cross-shore from HvH [m]');
%     nemo_print2paper(['altitude/',z,'_',datestr(D.time(t),'yyyymmdd')],[20 15]);
    print2a4(['./figures/altitude/',z,'_',datestr(D.time(t),'yyyymmdd')],'l','n','-r300','o');
    cla;
end