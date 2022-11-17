function nemo_plot_slope(D,z,h_on,h_off,d_on,d_off,slope,t_index,map2plot)
%NEMO_PLOT_SLOPE Plots slopes for several surveys and indication on bathymetry.
%
%   Plots slope and cross-shore extent of slope calculation calculated from
%   nemo_slopes.
%
%   Syntax:
%       nemo_plot_slope(D,z,h_on,h_off,d_on,d_off,slope,t_index,map2plot)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       h_on: upper limit for slope calculation
%       h_off: lower limit for slope calculation
%       d_on: onshore limit
%       d_off: offshore limit
%       slope: slope as calculated by nemo_slopes
%       t_index: time indices for slopes to plot
%       map2plot: reference bathymetry time_index
%
%   Output:
%   	figures
%
%   Example:
%       [slope,d_on,d_off,~]=nemo_build_slope(D,'altitude',0,-4);
%       nemo_plot_slope(D,'altitude',0,-4,d_on,d_off,slope,Time.july,7);
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
figure;

%surv2plot=[1, 7, 37];

subplot(2,1,1);
hold on
%g=plot(D.alongshore,1./slope(surv2plot,:));
g=semilogy(D.alongshore,atand(slope(t_index,:)));
%ylim([-200 0]);
xlim([0 17500]);
xlabel('Alongshore distance from HvH [m]');
ylabel('Slope [degree]');
title(['Average cross-shore slopes from ',num2str(h_on,'%d'),'m+NAP to ',...
    num2str(h_off,'%d'),'m+NAP, for surveys ',num2str(t_index)]);
for t=1:length(t_index);
    legtekst{t}=['Survey ',num2str(t_index(t))];
end
legend(g,legtekst, 'Location','SE');% '{'survey 1','survey 7','survey 37'},'Location','SE');

subplot(2,1,2);
hold on

pcolor(D.L, D.C, squeeze(D.(z)(map2plot,:,:)));
shading flat;
h(1)=plot(D.alongshore,d_on(map2plot,:),'-r');
h(2)=plot(D.alongshore,d_off(map2plot,:),'-m');
axis equal;
ylim([-200 2000]);
xlim([0 17500]);
title(['Bathymetry for survey ',num2str(map2plot,'%d')]);
xlabel('Alongshore distance from HvH [m]');
ylabel('Cross-shore distance from RSP [m]');

legend(h,{'h_{on}','h_{off}'});