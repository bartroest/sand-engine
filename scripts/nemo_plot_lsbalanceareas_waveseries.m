function nemo_plot_lsbalanceareas_waveseries(D,V,W,Time)
%NEMO_PLOT_LSBALANCEAREAS_WAVESERIES Plots a figure with volume and wave timeseries.
%
%   Plots a figure with panels consisting of volume timeseries in specific
%   balance areas, timeseries of wave power and its alongshore componenents.
%
%   Syntax:
%       nemo_plot_lsbalanceareas_waveseries(D,V,W,Time)
%
%   Input: 
%       D: Data struct
%       V: Volume struct
%       W: Offshore wave timeseries
%       Time: Time indices struct
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_lsbalanceareas_waveseries(D,V,W,Time);
%
%   See also: nemo, nemo_volumes, nemo_waveclimate

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

%% LS balance areas
% IN NEW FUNCTION NO LONGER IN THIS FIGURE!
% % % ax1=subplot(7,1,1);
% % % %pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),squeeze(D.z_jarkus(37,Index.jarkus,:)-D.z_jarkus(7,Index.jarkus,:))); shading flat;
% % % hold on;
% % % [z1, z2]=nemo_bathyfila(D,'altitude',38);
% % % pcolor(D.ls,D.cs-930,(z2-z1)); shading flat;
% % % colormap(jwb(100,0.01)); csym;
% % % clim([-5 5])
% % % contour(D.ls,D.cs-930,squeeze(D.altitude(38,:,:)),[0 0],'--k');
% % % contour(D.ls,D.cs-930,squeeze(D.altitude( 1,:,:)),[0 0],'-k');
% % % 
% % % xlabel('Alongshore distance [m]');
% % % ylabel('Cross-shore distance [m]  ');
% % % %title('Balance areas')
% % % axis equal
% % % box on;
% % % xlim([-100 17250]);
% % % ylim([-250 3000]);
% % % 
% % % ax1.Position=[ax1.Position(1), ax1.Position(2)+0.014, ax1.Position(3) , 0.13];
% % % pos=ax1.Position;
% % % cb=colorbar('Position',[pos(1)+pos(3)+0.005, pos(2)+pos(4)*0.05, 0.01 ,pos(4)*0.9]);
% % % cb.Label.String='Bedlevel change [m]';
% % % cb.Ticks=-5:5;
% % % vline(D.alongshore([286,334,388,442]),'--k')
% % % text( 3000,2700,'Nemo South','FontSize',8);  text( 3000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
% % % text( 7300,2700,'SE South','FontSize',8);    text( 7100,2300,'+1.2\cdot10^{6}m^{3}','FontSize',8); 
% % % text( 9100,2700,'SE Centre','FontSize',8);   text( 9100,2300,'-4.2\cdot10^{6}m^{3}','FontSize',8);
% % % text(11000,2700,'SE North','FontSize',8);    text(11000,2300,'+1.8\cdot10^{6}m^{3}','FontSize',8);
% % % text(14000,2700,'Nemo North','FontSize',8);  text(14000,2300,'+1.9\cdot10^{5}m^{3}','FontSize',8);
% % % %text(2000,1000,'(Nourishment: +1.5\cdot10^{6}m^{3})');
% % % nemo_northarrow('auto');
% % % 
% % % ax0=gca;
% % % % % ax2=axes('Position',ax0.Position);
% % % % % ax2.Color='none';
% % % % % ax2.XAxisLocation='Top';
% % % % % ax2.XDir='Reverse';
% % % % % ax2.XLim=[D.RSP([623 1])];
% % % % % grid off;
% % % % % xtl=ax2.XTickLabel;
% % % % % axis equal
% % % % % ax2.XLim=[D.RSP([623 1])*1000];
% % % % % ylim(ax0.YLim)
% % % % % ax2.XTickLabel=xtl;
% % % % % xlabel('Alongshore distance RSP [km]')
% % % title('Volume changes from Aug 2011 to Sep 2016');
% % % 
% % % % % cb2=colorbar;
% % % % % cb2.Label.String='Sedimentation/Erosion [m]';
% % % % % clim([-5 5]);
% % % % % cb2.Ticks=-5:5;
% % % 
% % % % ff=gcf;
% % % %ff.Units='centimeters';
% % % %ff.Position=[1,1,30,21];
% % % %ax2.Position=ax0.Position;
% % % text(-2200,3500,'a','FontSize',12);

%% TIMESERIES ALONGSHORE BALANCE AREAS
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
D.binwidth=nemo_binwidth(D);
dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:285).*repmat(D.binwidth(  1:285)',37,1),1),2)];
dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',37,1),1),2)];
dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)];
dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',37,1),1),2)];
dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',37,1),1),2)];

dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,286:441).*repmat(D.binwidth(286:441)',37,1),1),2)];
dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,:).*repmat(D.binwidth',37,1),1),2)];

axx=subplot(3,1,1);
hold on;
h(1)=plot(D.time(Time.nemo),dvnmZ(Time.nemo),'^-c');
h(2)=plot(D.time(Time.nemo),dvnmN(Time.nemo),'d-m');
h(3)=plot(D.time(Time.all),dvzmZ(Time.all),'v-b');
h(4)=plot(D.time(Time.all),dvzmC(Time.all),'o-g');
h(5)=plot(D.time(Time.all),dvzmN(Time.all),'s-r');

%h(7)=plot(D.time(Time.all),dvzm(Time.all) ,'.-','Color',[0.7 0.7 0.7]);
h(6)=plot(D.time(Time.all),dvall(Time.all) ,'*-k');

axx.XTick=datenum(2011,07,01):366/2:datenum(2017,01,01);
datetick('x','mm-''yy','keepticks');
title('Net volume change per balance area');    
ylabel('Net volume change [m^3]');
xlabel('Time');
ylim([-5e6 2e6]);
xlim([D.time(1)-31 D.time(end)+30]);
box on;
axx.XTickLabel=[];
axpos = axx.Position;
axx.Position = axpos + [0 -0.03 0 0.05];

% leg=legend(h(1:3),{'Nemo South','Nemo North','SE South';'SE Centre','SE North','SE+Nemo'},'Location','SW','FontSize',7.5);
% leg.Position=leg.Position-[0 0.01 0 0];
% leg.FontSize=7.5;
% ll=columnlegend(2,{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','SouthWest','boxoff');
ll=legend(gca,h,{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','SouthWest','NumColumns',2);
% ll.Position=ll.Position-[0 0.02 0 0];

text(datenum(2010,12,01),2.8e6,'a','FontSize',12);

%% Wave Timeseries MEAN
%% Constants
g=9.81; %gravitational acceleration [m/s^2]
rho=1024; %density of seawater [kg/m^3]
rho_s=2650; %Density of sand
d50=250e-6; %Median grainsize
gamma_b=0.78; %Breaker parameter H/h
depth=12.0; %Depth nearshore [m]
%% Expand wave parameters
% Relative wave angle of incidence, 0=perpendicular.
W.d_rel=W.hdir+48.7; %Local coastline angle +(360-311.3) Hoekverdraaiing.
W.d_rel(W.d_rel>180)=W.d_rel(W.d_rel>180)-360;
mask=W.d_rel<=-90 | W.d_rel>=90;
W.d_rel(mask)=nan; % Do not allow for 'off-shore directed' waves to contribute to the wave power.

W.k=disper(2*pi./W.tp,depth,g); %Wave number
W.cp=sqrt(9.81./W.k.*tanh(W.k.*depth)); %Wave phase velocity
W.cg=1/2.*W.cp.*(1+(2.*W.k.*depth)./sinh(2.*W.k.*depth)); %Wave group velocity

%% Wave parameters at wave breaking
[W.hb,W.db,W.dir_b]=Waves2Nearshore(W.depthavg,W.hm0,W.d_rel,W.tp,nan,gamma_b);
 
%% Energy and power
W.energy=1/2*1/8*rho*g*W.hm0.^2; %Wave energy [kg m^2 / s^2]=[J/m^2]
% E=1/2*rho*g*a^2 = 1/2*rho*g*(H_rms/2)^2 = 1/8*rho*g*H_rms^2 = 1/16*rho*g*H_s^2
W.power=W.energy.*W.cg; %Wave power [kg m /s^3]=[W/m]=[J/(sm)] Also wave energy flux.
% P=1/16 * rho * g * H^2 * (g*T/2*pi) [W/m]
%Power [W/m]=[J/s/m] 

% Calculation of alongshore component of wave power, per entry.
W.P_ls=W.power.*-sind(W.d_rel);
W.P_cs=W.power.*cosd(W.d_rel);


% wpower=1/2*(1/8*1024*9.81.*(W.hm0).^2)*9.81.*W.tp/(2*pi); %Wave power in [W/m]=[J/s/m];
% wpls=wpower.*-sind(d_rel);
%Power [W/m]=[J/s/m]  E=S(P*dt);

%dt=nanmean(diff(WE.time)); %=1/24=1hour=3600s;
dt=3600/6;
% w_energy=(wpower.*dt);
% w_enls=wpls.*dt;

ax=subplot(3,1,2);
hold on; 
t_index=Time.all;
for t=1:length(D.time(Time.all))-1; 
    %mask=WE.time>=D.time(t_index(t)) & WE.time<D.time(t_index(t+1));
    mask=W.time>=D.time(t_index(t)) & W.time<D.time(t_index(t+1));
    avgpow=nanmean(W.power(mask));% nansum(w_energy(mask))/(((D.time(t_index(t+1))-D.time(t_index(t))))*24*60*60); %
    avgpls=nanmean(W.P_ls(mask)); %nansum(w_enls(mask))  /(((D.time(t_index(t+1))-D.time(t_index(t))))*24*60*60); %
    col=avgpls/avgpow;
% % %     if nansum(w_enls(mask))>0
% % %         col=[1 0 0]; %'r' 
% % %     else
% % %         col=[0 0.5 0.9]; %'b'
% % %     end
%     plot([D.time(t_index(t))   D.time(t_index(t+1))] ,[avgpow avgpow],'-k'); 
%     plot([D.time(t_index(t))   D.time(t_index(t))]   ,[0      avgpow],'-k'); 
%     plot([D.time(t_index(t+1)) D.time(t_index(t+1))] ,[0      avgpow],'-k'); 
% %     plot([D.time(t_index(t))   D.time(t_index(t+1))] ,[WE.climate.cp(t_index(t),365) WE.climate.cp(t_index(t),365)]./(D.time(t_index(t+1))-D.time(t_index(t))),'-k'); 
% %     plot([D.time(t_index(t))   D.time(t_index(t))]   ,[0                             WE.climate.cp(t_index(t),365)]./(D.time(t_index(t+1))-D.time(t_index(t))),'-k'); 
% %     plot([D.time(t_index(t+1)) D.time(t_index(t+1))] ,[0                             WE.climate.cp(t_index(t),365)]./(D.time(t_index(t+1))-D.time(t_index(t))),'-k');
    patch([D.time(t_index(t));   D.time(t_index(t+1)); D.time(t_index(t+1)); D.time(t_index(t))],...
          [0;                    0;                    avgpow;               avgpow            ],...
          col);
end

% t_index=Time.july;
% for t=1:length(D.time(Time.july))-1; 
%     mask=W.time>=D.time(t_index(t)) & W.time<D.time(t_index(t+1));
%     avgpow=nansum(w_energy(mask))/(((D.time(t_index(t+1))-D.time(t_index(t))))*24*60*60); %
% %    avgpls=nansum(w_enls(mask))  /(((D.time(t_index(t+1))-D.time(t_index(t))))*24*60*60); %
% %    col=avgpls/avgpow;
%     plot([D.time(t_index(t)) D.time(t_index(t+1))],[avgpow, avgpow],'--k');
% %     patch([D.time(t_index(t));   D.time(t_index(t+1)); D.time(t_index(t+1)); D.time(t_index(t))],...
% %           [0;                    0;                    avgpow;               avgpow            ],...
% %           col);
% end

ax.XTick=[];
ax.XTickLabel=[];
ax.XTick=datenum(2011,07,01):366/2:datenum(2017,01,01);

%datetick('x','mmm-''yy','keepticks');
xlim([D.time(1)-31 D.time(end)+30]);
ylim([0 2.1e4]);
xlabel('Time');
ylabel('Mean wave power [W/m]');
box on;


colormap(gca,jwb(12,0.1));
axw=gca; 
pos=axw.Position; 
cbw=colorbar('Position',[pos(1)+pos(3)+0.005, pos(2)+pos(4)*0.05, 0.01 ,pos(4)*0.9]);
cbw.Label.String='P_{alongshore, net}/P_{total} [-]';
clim([-0.6000 0.6000]);
cbw.Ticks=(-.6:0.2:0.6);
% % % b2=patch(nan,nan,nan,'b');
% % % b1=patch(nan,nan,nan,'r');
% % % legend([b2,b1],{'SW-waves','N-waves'})
% 
text(datenum(2010,12,01),2.3e4,'b','FontSize',12);

%% Wave Timeseries
ax2=subplot(3,1,3); %axes('Position',ax.Position);%subplot(5,1,1:2)%=
%ax2.YAxisLocation='right';
%ax2.XAxisLocation='top';
%ax2.Color='none';
%grid off;
hold on;
t_index=Time.all;
for t=1:length(D.time(Time.all))-1;
    %mask=WE.time>=D.time(t_index(t)) & WE.time<D.time(t_index(t+1));%  & WE.h>250;
    mask=W.time>=D.time(t_index(t)) & W.time<D.time(t_index(t+1));%  & WE.h>250;
    plot(W.time(mask),nancumsum(W.power(mask)).*dt,'--b');
    plot(D.time(t_index(t+1)),nansum(W.power(mask)).*dt,'*b');
    
    plot(W.time(mask),nancumsum(W.P_ls(mask)).*dt,'-k');
    plot(D.time(t_index(t+1)),nansum(W.P_ls(mask)).*dt,'ok');
end;
ax2.XTickLabelRotation=90;
ax2.XTick=datenum(2011,07,02):366/2:datenum(2017,01,01);
datetickzoom('x','mmm-''yy','keepticks');

xlim([D.time(1)-31 D.time(end)+30]);
ylim([-1e10 7e10]);
xlabel('Time');
ylabel('Wave energy per survey interval [J/m]');
box on;

text(datenum(2010,12,01),8.5e10,'c','FontSize',12);

%LEGEND...
h1=plot(nan,nan,'*--b');
h2=plot(nan,nan,'o-k');
%h2=patch(nan,nan,nan);
leg=legend([h1,h2],{'Wave energy','Alongshore wave energy'},'Location','NW');

