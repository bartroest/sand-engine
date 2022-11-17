function nemo_plot_volume_series_waveenergy(D,V,W,Time);
%NEMO_PLOT_VOLUME_SERIES_WAVEENERGY Plots the volume series (net volume changes) in balance areas as funtion of wave energy.
%
%   Plots the volume series (net volume changes) in balance areas as funtion of
%   accumulated wave energy, rather than time.
%
%   Syntax:
%       nemo_plot_volume_series_waveenergy(D,V,W,Time);
%
%   Input: 
%       D: Data struct
%       V: Volumes struct
%       W: Wave parameter timeseries
%       Time: time indices struct
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_volume_series_waveenergy(D,V,W,Time);
%
%   See also: nemo, nemo_volumes, nemo_wave_climate.

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
figure('Units','centimeters','Position',[5 2 15 22]);
ls=false;
%% LS balance areas
ax1=subplot(5,1,1);
%pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),squeeze(D.z_jarkus(37,Index.jarkus,:)-D.z_jarkus(7,Index.jarkus,:))); shading flat;
hold on;
[z1, z2]=nemo_bathyfila(D,'altitude',38);
pcolor(D.ls,D.cs-930,(z2-z1)); shading flat;
colormap(jwb(100,0.01)); csym;
clim([-5 5])
contour(D.ls,D.cs-930,squeeze(D.altitude(38,:,:)),[0 0],'--k');
contour(D.ls,D.cs-930,squeeze(D.altitude( 1,:,:)),[0 0],'-k');

xlabel('Alongshore distance [m]');
ylabel('Cross-shore distance [m]');
%title('Balance areas')
axis equal
box on;
xlim([-100 17250]);
ylim([-250 3000]);

ax1.Position=[ax1.Position(1), ax1.Position(2)+0.014, ax1.Position(3) , 0.13];
pos=ax1.Position;
cb=colorbar('Position',[pos(1)+pos(3)+0.005, pos(2)+pos(4)*0.05, 0.01 ,pos(4)*0.9]);
cb.Label.String='Bedlevel change [m]';
cb.Ticks=-5:5;
vline(D.alongshore([286,334,388,442]),'--k')
% % % % text( 3000,2700,'Nemo South','FontSize',8);  text( 3000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
% % % % text( 7300,2700,'SE South','FontSize',8);    text( 7100,2300,'+1.2\cdot10^{6}m^{3}','FontSize',8); 
% % % % text( 9100,2700,'SE Centre','FontSize',8);   text( 9100,2300,'-4.2\cdot10^{6}m^{3}','FontSize',8);
% % % % text(11000,2700,'SE North','FontSize',8);    text(11000,2300,'+1.8\cdot10^{6}m^{3}','FontSize',8);
% % % % text(14000,2700,'Nemo North','FontSize',8);  text(14000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
% % % % %text(2000,1000,'(Nourishment: +1.5\cdot10^{6}m^{3})');
nemo_northarrow('auto');

ax0=gca;
title('Volume changes from Aug 2011 to Sep 2016');

% % cb2=colorbar;
% % cb2.Label.String='Sedimentation/Erosion [m]';
% % clim([-5 5]);
% % cb2.Ticks=-5:5;

% ff=gcf;
%ff.Units='centimeters';
%ff.Position=[1,1,30,21];
%ax2.Position=ax0.Position;
text(-2500,4000,'a','FontSize',12);

%% SERIES ALONGSHORE BALANCE AREAS
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
D.binwidth=nemo_binwidth(D);
dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:285).*repmat(D.binwidth(  1:285)',length(D.time)-1,1),1),2)];
dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',length(D.time)-1,1),1),2)];
dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',length(D.time)-1,1),1),2)];
dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',length(D.time)-1,1),1),2)];
dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',length(D.time)-1,1),1),2)];

dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,286:441).*repmat(D.binwidth(286:441)',length(D.time)-1,1),1),2)];
dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,:).*repmat(D.binwidth',length(D.time)-1,1),1),2)];

%% TIME
axx=subplot(5,1,2:3);
hold on;
h(1)=plot(D.time(Time.nemo),dvnmZ(Time.nemo),'^-c');
h(2)=plot(D.time(Time.nemo),dvnmN(Time.nemo),'d-m');
h(3)=plot(D.time(Time.all),dvzmZ(Time.all),'v-b');
h(4)=plot(D.time(Time.all),dvzmC(Time.all),'o-g');
h(5)=plot(D.time(Time.all),dvzmN(Time.all),'s-r');

%h(7)=plot(D.time(Time.all),dvzm(Time.all) ,'.-','Color',[0.7 0.7 0.7]);
h(6)=plot(D.time(Time.all),dvall(Time.all) ,'*-k');

axx.XTick=datenum(2011,07,01):366/2:datenum(year(D.time(end))+1,01,01);
datetick('x','mm-''yy','keepticks');
title('Net volume change per balance area');    
ylabel('Net volume change [m^3]');
xlabel('Time');
ylim([-4.5e6 2e6]);
xlim([D.time(1)-31 D.time(end)+30]);
box on;

leg=legend(h(1:6),{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','SW','FontSize',7.5);
leg.Position=leg.Position-[0 0.01 0 0];

text(datenum(2010,12,01),2.3e6,'b','FontSize',12);
text(datenum(2010,12,01),-6.4e6,'c','FontSize',12);

%% WAVE POWER
if ls
    we_zm=-nancumsum([0;W.climate.cpls(1:end-1,365)].*3600);
    we_nm=-nancumsum([nansum(W.climate.cpls(1:6,365));W.climate.cpls(1:end-1,1  )].*3600);
else
    we_zm=nancumsum([0;W.sum.E(1:end-1,365)].*600);
    we_nm=nancumsum([nansum(W.sum.E(1:6,365));W.sum.E(1:end-1,1  )].*600);
end

ax2=subplot(5,1,4:5);
ax2.Units='normalized';
ax2.Position=ax2.Position+[0 -0.06 0 0];
hold on;
h(1)=plot(we_nm(Time.nemo),dvnmZ(Time.nemo),'^-c');
h(2)=plot(we_nm(Time.nemo),dvnmN(Time.nemo),'d-m');
h(3)=plot(we_zm(Time.all),dvzmZ(Time.all),'v-b');
h(4)=plot(we_zm(Time.all),dvzmC(Time.all),'o-g');
h(5)=plot(we_zm(Time.all),dvzmN(Time.all),'s-r');

%h(7)=plot(D.time(Time.all),dvzm(Time.all) ,'.-','Color',[0.7 0.7 0.7]);
h(6)=plot(we_zm(Time.all),dvall(Time.all) ,'*-k');

ylabel('Net volume change [m^3]');
xlabel('Cumulative wave energy [J/m]');
ylim([-4.5e6 2e6]);
if ~ls
xlim([-0.1e11 6.5e11]);
end
box on;

ax3=axes('Position',ax2.Position);
ax3.XAxisLocation='top';
ax3.YAxisLocation='right';
grid off;
ax3.Color='none';
ax3.YTick=[];
ax3.XLim=ax2.XLim;
ax3.XTick=we_zm(Time.all);
xtl=datestr(D.time(Time.all),'  mm-''yy');
xtl([2,4,8,10,12,30],:)=' ';
ax3.XTickLabel=xtl;
ax3.XTickLabelRotation=90;
ax3.XAxis.FontSize=8;


