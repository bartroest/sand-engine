%nemo_plot_extra_figures - Creates extra figures needed for thesis report.
%
%   Plots several figures not created by other routines, used in the master
%   thesis report.
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

%% Erosed 18 months
figure;
AX=subplot_meshgrid(1,3,0.1,0.05,nan,nan);
%ax1=subplot(3,1,1);
axes(AX(1,1));
pcolor(D.alongshore,D.dist,squeeze(D.altitude(1,:,:))');
hold on;
shading flat;
axis equal;
xlim(D.alongshore(Index.zm([1 end])));
ylim([-100 1800]);
ylabel('Cross-shore distance from RSP [m]');
title(['Bathymetry ',datestr(D.time(1),'dd mmm yyyy')]);
colormap(zmcmap);
cb=colorbar(gca);
ylabel(cb,'Altitude [m+NAP]');
clim([-12 7]);

axes(AX(1,2));
%ax2=subplot(3,1,2);
pcolor(D.alongshore,D.dist,squeeze(D.altitude(16,:,:))');
hold on;
shading flat;
axis equal;
xlim(D.alongshore(Index.zm([1 end])));
ylim([-100 1800]);
ylabel('Cross-shore distance from RSP [m]');
title(['Bathymetry ',datestr(D.time(16),'dd mmm yyyy')]);
colormap(zmcmap);
cb=colorbar(gca);
ylabel(cb,'Altitude [m+NAP]');
clim([-12 7]);


axes(AX(1,3));
%ax3=subplot(3,1,3);
pcolor(D.alongshore,D.dist,squeeze(D.altitude(16,:,:))'-squeeze(D.altitude(1,:,:))');
hold on;
shading flat;
axis equal;
xlim(D.alongshore(Index.zm([1 end])));
ylim([-100 1800]);
colormap(gca,jwb(100,0.05)); 
clim([-4 4]);
xlabel('Alongshore distance from HvH [m]');
ylabel('Cross-shore distance from RSP [m]');
title(['Bedlevel change']);
cb=colorbar(gca);
ylabel(cb,'Bedlevel change [m]');

print2a4('./figures/sedero18months.png','p','n','-r200');

%% Net volume change over height

figure; ax1=subplot(3,3,[1,2,4,5]); 
pcolor(D.alongshore,VH.heights(1:end-1),squeeze(nansum(VH.dv))'./(nanmean(diff(VH.heights)))); shading flat;
colormap(jwb(100,0.01)); csym; 
cb=colorbar('horizontal');
cb.Location='South';
cb.Position=[0.135 0.425 0.20 0.03];
cb.AxisLocation='in';
xlim([0 17250]);
ylim([-12 6])
title('Net volume change [m^3/m_{alongshore}/m_{height}]');
xlabel('Distance from HvH [m]');
ylabel('Altitude [m+NAP]')

subplot(3,3,[3,6]); plot(squeeze(nansum(squeeze(nansum(VH.dv,1)).*repmat(D.binwidth,1,72),1))./0.25,VH.heights(1:end-1),'.-k');
ylim([-12 6])
xlabel('Net volume change [m^3/m_{height}]');
ylabel('Altitude [m+NAP]')
title('Net volume change [m^3/m_{height}]');

subplot(3,3,[7,8]); plot(D.alongshore,squeeze(nansum(nansum(VH.dv,1),3)),'.-k');
xlim([0 17250]);
xlabel('Distance from HvH [m]');
ylabel('Net volume change [m^3/m_{alongshore}]')
title('Net volume change [m^3/m_{alongshore}]')

%print2a4('./figures/heightvolch.png','l','n','-r200');

%% Cumvolch
figure; 
subplot(2,1,1);
hold on;
plot(D.alongshore,nansum(V.comp.dv),'.-k');
ax1=gca;
ax2=axes('Position',ax1.Position);
hold on;
plot(D.alongshore,nansum(V.comp.dv)./1863.*365,'.-k');
ax2.YAxisLocation='right';
ax2.Color='none';

ax1.YLim=[-3500 2500];
ax2.YLim=[-3500 2500]./1863*365;
grid off

ax1.YLabel.String='Net volume change [m^3/m^1_{alongshore}]';
ax2.YLabel.String='Net volume change [m^3/m^1_{alongshore}/year]';
linkaxes([ax1,ax2],'x')
xlim([0 17250]);
hline(0,'--k')
title('Net volume change August 2011 - September 2016');
xlabel('Alongshore distance from Hoek van Holland [m]');

set(gcf,'PaperSize',[21 10])
set(gcf,'PaperPosition',[1 2 19 7])
print('./figures/cumvolch','-r200','-dpng')

print2a4('./figures/cumvolch.png','l','n','-r200');

%PT2: voltrans

subplot(2,1,2);
hold on;
plot(D.alongshore,nancumsum(nansum(V.comp.dv).*D.binwidth',2),'.-k');
ax3=gca;
ax4=axes('Position',ax3.Position);
hold on;
plot(D.alongshore,nancumsum(nansum(V.comp.dv).*D.binwidth',2)./1863.*365,'.-k');
ax4.YAxisLocation='right';
ax4.Color='none';
grid off
ax3.YLim=[-3e6 1.5e6];
ax4.YLim=ax3.YLim./1863.*365;

ax3.YLabel.String='Alongshore cummulative volume change [m^3]';
ax4.YLabel.String='Net transport [m^3/year]';
linkaxes([ax3,ax4],'x')
xlim([0 17250]);
hline(0,'--k');
title('Sediment transport August 2011 - September 2016');
xlabel('Alongshore distance from Hoek van Holland [m]');

%print2a4('./figures/cumtransp.png','l','n','-r200');

%% DeltaV off-shore (MULTIBEAM)

%load('MB_trans');
%D=load('DL_trans_vb'); 
%load('Volumes_Dnew');
%V_mb=nemo_volumes(M,'alt_mb',Index.all,1:2,'rr');
binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;

figure; 
ax1=subplot(2,1,1);
hold on;
plot(D.alongshore,V_mb.dv(1,:),'xr');
plot(D.alongshore,nansum(V.comp.dv(7:29,:,:)),'+b');
plot(D.alongshore,V_mb.dv(1,:)+nansum(V.comp.dv(7:29,:,:)),'.-k');
legend('Off-shore','ZM/Nemo-area','Total','Location','NW');
title('Net volume changes from February 2012 to June 2015')
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Net volume change [m^3/m]');
xlim([0 17250]);

ax4=axes('Position',ax1.Position);
hold on
plot(D.alongshore,(V_mb.dv(1,:)+nansum(V.comp.dv(7:29,:,:)))./(D.time(30)-D.time(7)).*365,'.-k');
ax4.YAxisLocation='right';
ax4.Color='none';
grid off
ax1.YLim=[-2000 1500];
ax4.YLim=ax1.YLim./(D.time(30)-D.time(7)).*365;
ylabel('Net volume change [m^3/m/year]');
linkaxes([ax1,ax4],'x')

ax2=subplot(2,1,2);
hold on;
plot(D.alongshore,nancumsum(V_mb.dv(1,:).*D.binwidth'),'xr')
plot(D.alongshore,nancumsum(nansum(V.comp.dv(7:29,:,:)).*D.binwidth'),'+b');
plot(D.alongshore,nancumsum((V_mb.dv(1,:)+nansum(V.comp.dv(7:29,:,:))).*D.binwidth'),'.-k');
legend('Off-shore','ZM/Nemo-area','Total','Location','NW');
title('Sediment transport from February 2012 to June 2015');
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Alongshore cumulative net volume change [m^3]');

ax3=axes('Position',ax2.Position);
hold on
plot(D.alongshore,nancumsum((V_mb.dv(1,:)+nansum(V.comp.dv(7:29,:,:))).*D.binwidth')./(D.time(30)-D.time(7)).*365,'.-k');
ax3.YAxisLocation='right';
ax3.Color='none';
grid off
ax2.YLim=[-1.5e6 2.5e6];
ax3.YLim=ax2.YLim./(D.time(30)-D.time(7)).*365;
ylabel('Net sediment transport [m^{3}/year]');
linkaxes([ax2,ax3],'x')

xlim([0 17250]);

print2a4('./figures/offshorevolch.png','l','n','-r200')

%% DeltaV Dunes (JARKUS)

%D=load('DL_trans_vb');
%load('Volumes_Dnew');
VJ=nemo_volumes(D,'z_jarkus',Index.jarkus,Time.jarkus,'all');
mask=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C<1000;
mask=mask & ((D.C<400 & D.L>2500) | D.L<2500);
D.z_dunes=nan(size(D.z_jarkus));
for t=Time.jarkus; D.z_dunes(t,mask)=D.z_jarkus(t,mask); end
VD=nemo_volumes(D,'z_dunes',Index.jarkus,Time.jarkus,'all');

mask=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C>450;
mask=mask & ((D.C>1000 & D.L<2500) | D.L>2500);
D.z_offsh=nan(size(D.z_jarkus));
for t=Time.jarkus; D.z_offsh(t,mask)=D.z_jarkus(t,mask); end
VO=nemo_volumes(D,'z_offsh',Index.jarkus,Time.jarkus,'all');
binwidthJ=[2*diff(D.alongshore(Index.jarkus(1:2))) ; diff(D.alongshore(Index.jarkus(1:end-1)))+diff(D.alongshore(Index.jarkus(2:end))) ; 2*diff(D.alongshore(Index.jarkus(end-1:end)))]./2;
alongsh=(D.alongshore(Index.jarkus));%+[diff(D.alongshore(Index.jarkus));250]);

figure; 
ax1=subplot(2,1,1);
hold on;
plot(alongsh,nansum(VD.dv(:,Index.jarkus)),'xr');
plot(alongsh,nansum(VJ.dv(:,Index.jarkus))-nansum(VD.dv(:,Index.jarkus)),'+b');
plot(alongsh,nansum(VJ.dv(:,Index.jarkus)),'.-k');
legend('Dunes','Seaward','Total','Location','NW');
title('Net volume changes from March 2012 to August 2016')
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Net volume change [m^3/m]');
xlim([0 17250]);

ax4=axes('Position',ax1.Position);
hold on
plot(alongsh,nansum(VJ.dv(:,Index.jarkus))./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365,'.-k');
ax4.YAxisLocation='right';
ax4.Color='none';
grid off
ax1.YLim=[-2500 1500];
ax4.YLim=ax1.YLim./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365;
ylabel('Net volume change [m^3/m/year]');
linkaxes([ax1,ax4],'x')

ax2=subplot(2,1,2);
hold on;
plot(alongsh,nancumsum(nansum(VD.dv(:,Index.jarkus)).*binwidthJ'),'xr')
plot(alongsh,nancumsum((nansum(VJ.dv(:,Index.jarkus))-nansum(VD.dv(:,Index.jarkus))).*binwidthJ'),'+b');
plot(alongsh,nancumsum(nansum(VJ.dv(:,Index.jarkus)).*binwidthJ'),'.-k');
legend('Dunes','Seaward','Total','Location','NW');
title('Sediment transport from March 2012 to August 2016');
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Alongshore cumulative net volume change [m^3]');

ax3=axes('Position',ax2.Position);
hold on
plot(alongsh,nancumsum(nansum(VJ.dv(:,Index.jarkus)).*binwidthJ')./D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1)).*365,'.-k');
ax3.YAxisLocation='right';
ax3.Color='none';
grid off
ax2.YLim=[-1.0e6 2.7e6];
ax3.YLim=ax2.YLim./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365;
ylabel('Net sediment transport [m^{3}/year]');
linkaxes([ax2,ax3],'x')

xlim([0 17250]);

%print2a4('./figures/dunevolch.png','l','n','-r200')


%% DeltaV Off-shore (JARKUS)

%D=load('DL_trans_vb');
%load('Volumes_Dnew');
VJ=nemo_volumes(D,'z_jarkus',Index.jarkus,Time.jarkus,'all');
mask=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C<1000;
mask=mask & ((D.C<400 & D.L>2500) | D.L<2500);
D.z_dunes=nan(size(D.z_jarkus));
for t=Time.jarkus; D.z_dunes(t,mask)=D.z_jarkus(t,mask); end
VD=nemo_volumes(D,'z_dunes',Index.jarkus,Time.jarkus,'all');

mask=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C>400;
mask=mask & ((D.C>1000 & D.L<2750) | D.L>2750);
D.z_offsh=nan(size(D.z_jarkus));
for t=Time.jarkus; D.z_offsh(t,mask)=D.z_jarkus(t,mask); end
VO=nemo_volumes(D,'z_offsh',Index.jarkus,Time.jarkus,'all');
binwidthJ=[2*diff(D.alongshore(Index.jarkus(1:2))) ; diff(D.alongshore(Index.jarkus(1:end-1)))+diff(D.alongshore(Index.jarkus(2:end))) ; 2*diff(D.alongshore(Index.jarkus(end-1:end)))]./2;
alongsh=(D.alongshore(Index.jarkus));%+[diff(D.alongshore(Index.jarkus));250]);

ind=Index.jarkus;%(Index.jarkus>200); 
alongsh=D.alongshore(ind);
binwidthJ=[2*diff(D.alongshore(ind(1:2))) ; diff(D.alongshore(ind(1:end-1)))+diff(D.alongshore(ind(2:end))) ; 2*diff(D.alongshore(ind(end-1:end)))]./2;

figure; 
ax1=subplot(2,1,1);
hold on;
plot(alongsh,nansum(VO.dv(:,ind      )),'xr');
plot(alongsh,nansum(VD.dv(:,ind      )),'oc');
plot(alongsh,nansum(VJ.dv(:,ind      ))-nansum(VO.dv(:,ind      ))-nansum(VD.dv(:,ind      )),'+b');
plot(alongsh,nansum(VJ.dv(:,ind      )),'.-k');
legend('Off-shore','Dunes','ZM/Nemo-area','Total','Location','NW');
title('Net volume changes from March 2012 to August 2016')
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Net volume change [m^3/m]');
xlim([0 17250]);

ax4=axes('Position',ax1.Position);
hold on
plot(alongsh,nansum(VJ.dv(:,ind      ))./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365,'.-k');
ax4.YAxisLocation='right';
ax4.Color='none';
grid off
ax1.YLim=[-2500 1500];
ax4.YLim=ax1.YLim./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365;
ylabel('Net volume change [m^3/m/year]');
linkaxes([ax1,ax4],'x')

ax2=subplot(2,1,2);
hold on;
plot(alongsh,nancumsum(nansum(VO.dv(:,ind      )).*binwidthJ'),'xr');
plot(alongsh,nancumsum(nansum(VD.dv(:,ind      )).*binwidthJ'),'oc');
plot(alongsh,nancumsum((nansum(VJ.dv(:,ind      ))-nansum(VO.dv(:,ind      ))-nansum(VD.dv(:,ind      ))).*binwidthJ'),'+b');
plot(alongsh,nancumsum(nansum(VJ.dv(:,ind      )).*binwidthJ'),'.-k');
legend('Off-shore','Dunes','ZM/Nemo-area','Total','Location','NW');
title('Sediment transport from March 2012 to August 2016');
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Alongshore cumulative net volume change [m^3]');

ax3=axes('Position',ax2.Position);
hold on
plot(alongsh,nancumsum(nansum(VJ.dv(:,ind      )).*binwidthJ')./D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1)).*365,'.-k');
ax3.YAxisLocation='right';
ax3.Color='none';
grid off
ax2.YLim=[-1.71e6 2.7e6];
ax3.YLim=ax2.YLim./(D.time_jarkus(Time.jarkus(end))-D.time_jarkus(Time.jarkus(1))).*365;
ylabel('Net sediment transport [m^{3}/year]');
linkaxes([ax2,ax3],'x')

xlim([0 17250]);

%print2a4('./figures/Jarkusvolch.png','l','n','-r200')


%% CROSS_SHORE BALANCE AREAS
% mask_d=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C<1000;
% mask_d=mask_d & ((D.C<400 & D.L>2500) | D.L<2500);
% mask_o=~isnan(squeeze(nansum(D.z_jarkus))) & ~squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10) & D.C>400;
% mask_o=mask_o & ((D.C>1000 & D.L<2750) | D.L>2750);
% mask_zm=~isnan(squeeze(nansum(D.z_jarkus))) & squeeze(sum(~isnan(D.altitude(7:37,:,:)))>10);
% 
% %areaplot=100*ones(644,1925);
% areaplot=nan(644,1925);
% areaplot(mask_d)=1;
% areaplot(mask_zm)=0;
% areaplot(mask_o)=-1;

% figure; pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),areaplot(Index.jarkus,:)); shading flat;
% colormap([1 0.2 0; 0 0 1; 0 1 1]);
figure; 
pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),squeeze(D.z_jarkus(37,Index.jarkus,:)-D.z_jarkus(7,Index.jarkus,:))); shading flat;
hold on;
pcolor(D.L,D.C,squeeze(D.altitude(38,:,:)-D.altitude(7,:,:))); shading flat;
colormap(jwb(100,0.01)); csym;
clim([-5 5])
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Cross-shore distance from RSP-line [m]');
title('Balance areas for cross-shore fluxes');
axis equal
xlim([0 17250])
ylim([-500 2500])

cb=colorbar;
cb.Label.String='Sedimentation/Erosion [m]';
cb.Ticks=-5:5;

hold on; plot(D.alongshore,D.dist(ceil(nanmean(D.max_cross_shore_measurement(Time.nemo,:)))),'-k','LineWidth',2);
hold on; plot(D.alongshore,D.dist(floor(nanmean(D.min_cross_shore_measurement(Time.nemo,:)))),'-k','LineWidth',2);

text(1000,2000,'Off-shore');
text(1000,1000,'SE/Nemo');
text(1000,200,'Dunes');

print2a4(['./figures/balanceareas_CS'],'l','n','-r200','o')

%% TIMESERIES ALONGSHORE BALANCE AREAS
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:285).*repmat(D.binwidth(  1:285)',37,1),1),2)];
dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',37,1),1),2)];
dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)];
dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',37,1),1),2)];
dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',37,1),1),2)];

dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,286:441).*repmat(D.binwidth(286:441)',37,1),1),2)];
dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,:).*repmat(D.binwidth',37,1),1),2)];

figure;
subplot(3,1,[2:3]);
hold on;
h(1)=plot(D.time(Time.nemo),dvnmZ(Time.nemo),'^-c');
h(2)=plot(D.time(Time.nemo),dvnmN(Time.nemo),'d-m');
h(3)=plot(D.time(Time.all),dvzmZ(Time.all),'v-b');
h(4)=plot(D.time(Time.all),dvzmC(Time.all),'o-g');
h(5)=plot(D.time(Time.all),dvzmN(Time.all),'s-r');

%h(6)=plot(D.time(Time.all),dvzm(Time.all) ,'.-k');
h(6)=plot(D.time(Time.all),dvall(Time.all) ,'*-k');

datetick('x','mm-''yy');
title('Net volume change per balance area');    
ylabel('Net volume change [m^3]');
xlabel('Time');

legend(h(1:6),{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','NW');
% % %%
% % 
% % binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
% % bwj=nan(644,1); bwj(Index.jarkus)=binwidthJ;
% % dvnmZ=[0;nansum(nancumsum(VJ.dv(1:end-1,  1:285).*repmat(bwj(  1:285)',37,1),1),2)];
% % dvzmZ=[0;nansum(nancumsum(VJ.dv(1:end-1,286:333).*repmat(bwj(286:333)',37,1),1),2)];
% % dvzmC=[0;nansum(nancumsum(VJ.dv(1:end-1,334:387).*repmat(bwj(334:387)',37,1),1),2)];
% % dvzmN=[0;nansum(nancumsum(VJ.dv(1:end-1,388:441).*repmat(bwj(388:441)',37,1),1),2)];
% % dvnmN=[0;nansum(nancumsum(VJ.dv(1:end-1,442:612).*repmat(bwj(442:612)',37,1),1),2)];
% % 
% % dvzm= [0;nansum(nancumsum(VJ.dv(1:end-1,286:441).*repmat(bwj(286:441)',37,1),1),2)];
% % dvall=[0;nansum(nancumsum(VJ.dv(1:end-1,:).*repmat(bwj',37,1),1),2)];
% % 
% % %figure;
% % hold on;
% % h(1)=plot(D.time(Time.jarkus),dvnmZ(Time.jarkus),'^-c');
% % h(2)=plot(D.time(Time.jarkus),dvnmN(Time.jarkus),'d-m');
% % h(3)=plot(D.time(Time.jarkus),dvzmZ(Time.jarkus),'v-b');
% % h(4)=plot(D.time(Time.jarkus),dvzmC(Time.jarkus),'o-g');
% % h(5)=plot(D.time(Time.jarkus),dvzmN(Time.jarkus),'s-r');
% % 
% % h(6)=plot(D.time(Time.jarkus),dvzm(Time.jarkus) ,'.-k');
% % h(7)=plot(D.time(Time.jarkus),dvall(Time.jarkus) ,'*-k');
% % 
% % datetick('x','mm-''yy');
% % title('Net volume change per balance area');    
% % ylabel('Net volume change [m^3]');
% % xlabel('Time');
% % 
% % legend(h,{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE all'},'Location','NW');
%%%
% MdvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:304).*repmat(D.binwidth(  1:304)',37,1),1),2)];
% MdvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,305:333).*repmat(D.binwidth(305:333)',37,1),1),2)];
% MdvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)];
% MdvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:428).*repmat(D.binwidth(388:428)',37,1),1),2)];
% MdvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,429:612).*repmat(D.binwidth(429:612)',37,1),1),2)];
% 
% Mdvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,305:428).*repmat(D.binwidth(305:428)',37,1),1),2)];
% 
% % figure;
% hold on;
% plot(D.time(Time.nemo),MdvnmZ(Time.nemo),'o-c');
% plot(D.time(Time.nemo),MdvnmN(Time.nemo),'o-m');
% plot(D.time(Time.all),MdvzmZ(Time.all),'o-b');
% plot(D.time(Time.all),MdvzmC(Time.all),'o-y');
% plot(D.time(Time.all),MdvzmN(Time.all),'o-r');
% 
% plot(D.time(Time.all),Mdvzm(Time.all) ,'o-k');
% 
% datetick('x','mm-''yy');
% ylabel('Net volume change per balance area [m^3]');
% xlabel('Time');
%% LS balance areas
figure;
subplot(3,1,1);
pcolor(D.L(Index.jarkus,:),D.C(Index.jarkus,:),squeeze(D.z_jarkus(37,Index.jarkus,:)-D.z_jarkus(7,Index.jarkus,:))); shading flat;
hold on;
%pcolor(D.L,D.C,squeeze(D.altitude(38,:,:)-D.altitude(7,:,:))); shading flat;
%pcolor(D.L(Index.zm,:),D.C(Index.zm,:),squeeze(D.altitude(38,Index.zm,:)-D.altitude(1,Index.zm,:))); shading flat;
for t=1:37; pcolor(D.L,D.C,squeeze(D.altitude(38,:,:)-D.altitude(38-t,:,:))); shading flat; end;
colormap(jwb(100,0.01)); csym;
clim([-5 5])
contour(D.L,D.C,squeeze(D.altitude(38,:,:)),[0 0],'--k');
contour(D.L,D.C,squeeze(D.altitude( 1,:,:)),[0 0],'-k');

xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Cross-shore distance from RSP-line [m]');
%title('Balance areas')
axis equal
box on;
xlim([0 17250])
ylim([-200 2500])

cb=colorbar;
cb.Label.String='Sedimentation/Erosion [m]';
cb.Ticks=-5:5;
vline(D.alongshore([286,334,388,442]),'--k')
text( 3000,2200,'Nemo South');  text( 3000,1800,'+1.9\cdot10^{5}m^{3}');
text( 7300,2200,'SE South');    text( 7300,1800,'+1.2\cdot10^{6}m^{3}'); 
text( 9300,2200,'SE Centre');   text( 9300,1800,'-4.2\cdot10^{6}m^{3}');
text(11200,2200,'SE North');    text(11200,1800,'+1.8\cdot10^{6}m^{3}');
text(14000,2200,'Nemo North');  text(14000,1800,'+1.9\cdot10^{5}m^{3}');
text(2000,1000,'(Nourishment: +1.5\cdot10^{6}m^{3})');

ax0=gca;
ax2=axes('Position',ax0.Position);
ax2.Color='none';
ax2.XAxisLocation='Top';
ax2.XDir='Reverse';
ax2.XLim=[D.RSP([623 1])];
grid off;
xtl=ax2.XTickLabel;
axis equal
ax2.XLim=[D.RSP([623 1])*1000];
ylim(ax0.YLim)
ax2.XTickLabel=xtl;
xlabel('Alongshore distance RSP [km]')
title('Volume changes from Aug 2011 to Sep 2016');

cb2=colorbar;
cb2.Label.String='Sedimentation/Erosion [m]';
clim([-5 5]);
cb2.Ticks=-5:5;

 ff=gcf;
ff.Units='centimeters';
ff.Position=[1,1,30,21];
ax2.Position=ax0.Position;


%% Volume whole DL-cell
binwidthJ=[2*diff(D.alongshore(Index.jarkus(1:2))) ; diff(D.alongshore(Index.jarkus(1:end-1)))+diff(D.alongshore(Index.jarkus(2:end))) ; 2*diff(D.alongshore(Index.jarkus(end-1:end)))]./2;
figure; 
hold on;
plot(D.time,[0;nansum(nancumsum(V.comp.dv(1:end-1,:),1).*repmat(D.binwidth',37,1),2)],'.-k');
plot(D.time_jarkus(Time.jarkus),[0;nansum(nancumsum(VJ.dv(Time.jarkus(1:end-1),Index.jarkus(1:end-2)),1).*repmat(binwidthJ(1:end-2)',4,1),2)],'.-b');
plot(D.time_jarkus(Time.jarkus),[0;nansum(nancumsum(VJ.dv(Time.jarkus(1:end-1),Index.jarkus(1:end-2))-VO.dv(Time.jarkus(1:end-1),Index.jarkus(1:end-2))-VD.dv(Time.jarkus(1:end-1),Index.jarkus(1:end-2)),1).*repmat(binwidthJ(1:end-2)',4,1),2)],'.-c');


plot(D.time,[0;nansum(nancumsum(V.comp.dv(1:end-1,200:end),1).*repmat(D.binwidth(200:end)',37,1),2)],'.-r');

%% SHORT/LONG troubles
%DO=load('./old/DL_trans_stable.mat');

figure; ax1=subplot(2,1,1); pcolor(D.L,D.C,squeeze(sum(~isnan(DO.altitude(:,:,:)),1))); shading flat; colormap(ax1,parula(37)); colorbar;
axis equal; xlim([7700 12500]); ylim([-200 2000]);
title('Number of surveys per point')
ylabel('Cross-shore distance from RSP-line [m]');
xlabel('Alongshore distance from Hoek van Holland [m]');

ax2=subplot(2,1,2); pcolor(D.L,D.C,squeeze(nansum(diff(D.altitude([1:9,11:37],:,:),1,1)))); shading flat; colormap(jwb(100,0.02)); clim([-6 6]); colorbar;
axis equal; xlim([7700 12500]); ylim([-200 2000]);
title('Sedimentation Erosion from August 2011 to July 2016');
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Cross-shore distance from RSP-line [m]');

print2a4('./figures/longshortproblems','p','n','-r200');

%% GAUSS FIT
h=-4; t=12;
[l,c]=nemo_depth_contour_lc(D,'altitude',h,t);
q=nemo_gaus_fit(D,l',c',250:500,1,1);
close;
set(gcf,'Position',[1 31 1920 973]);

axis equal
ylim([0 q.e+q.a+100])
title(['Fit of Gaussian curve on the ',num2str(h,'%2.0f'),'m+NAP depth contour of ',datestr(D.time(t),'mmm yyyy')]);
hold on;
hline(q.e,'--k')
arrow([q.b,0],[q.b,q.e]);
arrow([q.b,q.e],[q.b,q.e+q.a]);

arrow([q.b,q.e+0.36*q.a],[q.b-q.c,q.e+0.36*q.a]);
arrow([q.b,q.e+0.36*q.a],[q.b+q.c,q.e+0.36*q.a]);
arrow([q.b,q.e-100],[q.b+2*q.c,q.e-100]);
arrow([q.b,q.e-100],[q.b-2*q.c,q.e-100]);
vline(q.b-2*q.c,'--k')
vline(q.b+2*q.c,'--k')

text(q.b+50,0.5*q.e,'Cross-shore off-set');
text(q.b+50,q.e+0.65*q.a,'Amplitude');
text(q.b-800,q.e+0.45*q.a,'2 Standard deviation');
text(q.b-1500,q.e-150,'Alongshore extent');
