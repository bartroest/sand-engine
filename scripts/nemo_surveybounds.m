%NEMO_SURVEYBOUNDS Plots the upper and lower limits of the surveyed area.
%
%   Determines the time-averaged upper and lower boundaries of the survey
%   domain.
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
z_max=squeeze(nanmean(nanmax(D.altitude(Time.nemo,:,:),3),1));
z_min=squeeze(nanmean(nanmin(D.altitude(Time.nemo,:,:),3),1));

zj_min=squeeze(nanmean(nanmin(DL.altitude(49:52,:,:),3),1));
zj_max=squeeze(nanmean(nanmax(DL.altitude(49:52,:,:),3),1));

figure; 
subplot(2,1,1); 
pcolor(D.ls,D.cs-800,squeeze(D.altitude(37,:,:)));
shading flat;
axis equal;
xlim([0 17250]);
ylim([-100 2000])
clim([-12 5]);
ylabel('Cross-shore distance [m]');
xlabel('Alongshore distance [m]');
title('Bathymetry July 2016');

ax=gca;
cb=colorbar('Position',[ax.Position(1)+1.005*ax.Position(3), ax.Position(2)+0.02*ax.Position(3), 0.02*ax.Position(3), 0.90*ax.Position(4)]);

subplot(2,1,2);
h=plot(D.alongshore,z_min,'.-r'); %zm nemo
hold on;
mask=~isnan(zj_min);
h2=plot(DL.alongshore1(mask),zj_min(mask),'.-k'); %jarkus
xlim([0 17250]);
ylim([-15 0]);
%legend([h;h2(2)],'Avg. max, SE/Nemo','Avg. min, SE/Nemo','Avg. min, Jarkus','Location','Best');
legend('Avg. min, SE/Nemo','Avg. min, Jarkus','Location','Best');
title('Average upper and lower boundary of the surveyed transects');
ylabel('Altitude [m NAP]');
xlabel('Alongshore distance [m]');

nemo_print2paper('survbounds',[15 10]);