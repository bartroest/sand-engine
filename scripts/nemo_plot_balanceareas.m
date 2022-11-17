function nemo_plot_balanceareas(D);
%NEMO_PLOT_BALANCEAREAS plots difference map with volume changes per area.
%
%   Plots a sedimentation/erosion map with indications of volume balance areas.
%   Includes textual volume changes. (hardcoded, sorry!)
%
%   Syntax:
%       nemo_plot_balanceareas(D)
%
%   Input: 
%       D: Data struct
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_balanceareas(D);
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

ax1=gca;
ax1.XAxis.Exponent=3;
%pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),squeeze(D.z_jarkus(37,Index.jarkus,:)-D.z_jarkus(7,Index.jarkus,:))); shading flat;
hold on;
[z1, z2]=nemo_bathyfila(D,'altitude',38);
pcolor(D.ls,(D.cs-930),(z2-z1)); shading flat;
colormap(jwb(30,1/30)); csym;
clim([-5 5])
contour(D.ls,(D.cs-930),squeeze(D.altitude(38,:,:)),[0 0],':k');
contour(D.ls(304:429,:),(D.cs(304:429,:)-930),squeeze(D.altitude( 1,304:429,:)),[0 0],'-k');
contour(D.ls(  1:304,:),(D.cs(  1:304,:)-930),squeeze(D.altitude( 7,  1:304,:)),[0 0],'-k');
contour(D.ls(429:644,:),(D.cs(429:644,:)-930),squeeze(D.altitude( 7,429:644,:)),[0 0],'-k');

xlabel('Alongshore distance [m]');
ylabel('Cross-shore distance [m]  ');
%title('Balance areas')
axis equal
box on;
xlim([-100 17250]);
ylim([-300 3000]);

% ax1.Position=[ax1.Position(1), ax1.Position(2)+0.014, ax1.Position(3) , 0.13];
% pos=ax1.Position;
cb=colorbar;%('Position',[pos(1)+pos(3)+0.005, pos(2)+pos(4)*0.05, 0.01 ,pos(4)*0.9]);
cb.Label.String='Bedlevel change [m]';
cb.Ticks=-5:5;
vline(D.alongshore([286,334,388,442]),'--k')
warning('Volumes in this figure are hardcoded, recalculate for t~=38 !!!');
text( 3000,2700,'Nemo South','FontSize',8);  text( 3000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
text( 7300,2700,'SE South','FontSize',8);    text( 7100,2300,'+1.2\cdot10^{6}m^{3}','FontSize',8); 
text( 9100,2700,'SE Centre','FontSize',8);   text( 9100,2300,'-4.2\cdot10^{6}m^{3}','FontSize',8);
text(11000,2700,'SE North','FontSize',8);    text(11000,2300,'+1.8\cdot10^{6}m^{3}','FontSize',8);
text(14000,2700,'Nemo North','FontSize',8);  text(14000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
%text(2000,1000,'(Nourishment: +1.5\cdot10^{6}m^{3})');
nemo_northarrow('auto');
%nemo_northarrow(0.8,0.8,16.5,2.5,-48,'k',15)

% ax0=gca;
% % ax2=axes('Position',ax0.Position);
% % ax2.Color='none';
% % ax2.XAxisLocation='Top';
% % ax2.XDir='Reverse';
% % ax2.XLim=[D.RSP([623 1])];
% % grid off;
% % xtl=ax2.XTickLabel;
% % axis equal
% % ax2.XLim=[D.RSP([623 1])*1000];
% % ylim(ax0.YLim)
% % ax2.XTickLabel=xtl;
% % xlabel('Alongshore distance RSP [km]')
title('Volume changes from Aug 2011 to Sep 2016');

nemo_print2paper('balarea',[18.35,5]);

% % cb2=colorbar;
% % cb2.Label.String='Sedimentation/Erosion [m]';
% % clim([-5 5]);
% % cb2.Ticks=-5:5;

% ff=gcf;
%ff.Units='centimeters';
%ff.Position=[1,1,30,21];
%ax2.Position=ax0.Position;
% text(-2.200,3.500,'a','FontSize',12);