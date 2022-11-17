function nemo_plot_slope_stack(D,slope,t_index,h_on,h_off)
%NEMO_PLOT_SLOPE_STACK Plots a timestack of the slope for individual surveys.
%
%   Plot timestack of cross-shore slope.
%
%   Syntax:
%       nemo_plot_slope_stack(D,slope,t_index,h_on,h_off)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       t_index: time indices to plot
%       h_on: onshore limit for slope calculation
%       h_off: offshore limit for slope calculation
%
%   Output:
%   	figure
%
%   Example:
%       [slope]=nemo_build_slope(D,'altitude',0,-4);
%       nemo_plot_slope_stack(D,slope,t_index,0,-4)
%
%   See also: nemo, nemo_build_slope

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

%fn=fieldnames(Slope);
%for f=1:length(fn)-1; 
    x=[D.alongshore;D.alongshore(end)+25];
    y=[D.time(t_index);D.time(t_index(end))+60];
    figure;
    pcolorcorcen(x,y,atan(slope(t_index,:)));%.(fn{f})(t_index,:)); 
    colormap gray;
    %shading flat;
    colorbar;
    xlabel('Dist from HvH [m]'); 
    ylabel('Time'); 
    title(['Average bed slope from ',num2str(h_on),' to ',num2str(h_off),' m NAP'],'interpreter','none'); 
    datetickzoom('y','mmm-yyyy');
    axis tight;
    %clim([-0.05 0]);
            
    colorbar('Ticks',[-0.0500   -0.0450   -0.0400   -0.0350   -0.0300   -0.0250   -0.0200   -0.0150   -0.0100   -0.0050 0],...
         'TickLabels', {'1/20'    '1/22'    '1/25'    '1/28'    '1/33'    '1/40'    '1/50'    '1/67'    '1/100'    '1/200'    '1/inf'});
end