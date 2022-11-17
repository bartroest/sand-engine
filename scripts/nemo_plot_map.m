function CL=nemo_plot_map(D);
%NEMO_PLOT_MAP - Plots a map of the survey area and the North Sea (inset).
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

%% Chart axes
CL=nc_plot_coastline('coastline','holland','coordsys','RD','fill',[0.6 0.6 0.6]);
hold on
axis square
chartax=gca;
xlim([ 56961  81961]);
ylim([439870 468000]);
xlabel('RD-x position [m]');
ylabel('RD-y position [m]');
title('Survey area');


%% Plot axes
XL=get(chartax,'XLim');
YL=get(chartax,'YLim');
% POS=get(chartax,'Position');
% 
% plotax=axes('Position',POS,'XLim',XL,'YLim',YL,'Color','none');
% linkaxes([chartax,plotax],'x','y');
% axis square
% xlabel('RD-x position [m]');
% ylabel('RD-y position [m]');
% hold on;


%pcolor(plotax,D.x,D.y,squeeze(D.altitude(17,:,:)));
%shading flat
%nanscatter(D.x,D.y,2,squeeze(D.altitude(17,:,:)));

text(D.x(620,200),D.y(620,200),'Scheveningen');
text(D.x(60,100),D.y(60,100),'Hoek van Holland');


%% Inset
%insax=axes('Position',[0.15 0.5 0.15 0.4]);
insax=axes('Position',[0.2400 0.5262 0.2125 0.4000]);
nc_plot_coastline('coastline','holland','coordsys','RD','fill','none');
%xlim([-36687   39422]);
%ylim([262500 1054800]);
hold on
plot([XL(1) XL(2)],[YL(1) YL(1)],'r');
plot([XL(1) XL(1)],[YL(1) YL(2)],'r');
plot([XL(2) XL(2)],[YL(1) YL(2)],'r');
plot([XL(1) XL(2)],[YL(2) YL(2)],'r');
axis equal
%axis tight
xlim([-366870  394220]);
ylim([ 262500 1054800]);
insax.XTick=[];
insax.YTick=[];
insax.Box='on';
insax.BoxStyle='full';
insax.Color=[0.9 0.9 0.9];

%% Print
% if OPT.print
% set(gcf,'PaperSize',[15 15],'PaperPosition',[0 0 15 15]);
% print('./figures/surveyarea','-r200','-dpng')
% end