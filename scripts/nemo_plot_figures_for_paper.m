%NEMO_PLOT_FIGURES_FOR_PAPER - Plots and prints all figures for in the paper.
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
%% LOAD STUFF
if ~exist('OPT','var')
    OPT = struct;
end
if ~isfield(OPT,'print');
    OPT.print=1; 
end
if ~isfield(OPT,'basepath')
    OPT.basepath=['D:\Users\Bart\zandmotor\morphology\JETSKI\raw\'];
end
DL=load('Jarkus_DL');
D=load('DL_trans_vb'); 
load('Alongshore_indices');
load('Time_indices');
load('Volume_Jarkus');
load('Volumes_def.mat');
[D.z_jarkus,D.z_jnz,D.time_jarkus]=nemo_combine_jarkus_shore(D,DL);
[D.L, D.C, D.alongshore,  D.dist, D.ls, D.cs, D.RSP] =nemo_build_shorenormalgrid(D);
[DL.L,DL.C,DL.alongshore1,DL.dist,DL.ls,DL.cs,DL.RSP]=nemo_build_shorenormalgridjarkus(DL);
DL.alt_int=nemo_jarkus_interp_cs(DL);
D.binwidth=nemo_binwidth(D);
fn=fieldnames(Time); for f=1:length(fn); Time.(fn{f})=Time.(fn{f})(Time.(fn{f})<=38); end
D.time_vbnemo(Time.nemo)=D.time_nemo(Time.nemo);
D.time_vbnemo(Time.vb)=D.time_vb(Time.vb);
D.time_vbnemo(7)=D.time_nemo(7);
D.time_vbnemo=D.time_vbnemo';
load('wave_trans_off_zm_filled.mat')

WE=nemo_read_waterbase_waves; %EURPFM waves
for t=1:38; [CL.ang(t,:),CL.ang_g(t),CL.ls(t,:),CL.cs(t,:),CL.curv(t,:),CL.dist(t,:)]=nemo_coastline_orientation(D,'altitude',-0.5,t,6,false); end
D.time_vbnemo(Time.nemo)=D.time_nemo(Time.nemo);
D.time_vbnemo(Time.vb)=D.time_vb(Time.vb);
D.time_vbnemo(7)=D.time_nemo(7);
D.time_vbnemo=D.time_vbnemo';
WE.climate=nemo_wave_climate(D,WE.d,WE.h,WE.p,WE.time,Index,Time,CL);

%% Figure1: ZM_photo's
% Made in Powerpoint > pdf.

%% Figure2: Maps
%figure; 
figure('Units','centimeters','Position',[5 5 18.35 10],'Renderer','painters');
    %%% Chart axes
    chartax=subplot(1,2,1);
%     colormap(chartax,zmcmap(19));
%     nc_plot_coastline('coastline','holland','coordsys','RD','fill',[0.6 0.6 0.6]);
%     hold on
%     axis square
%     xlim([ 56961  81961]); 
%     ylim([439870 468000]);
%     xlabel('RD-x position [m]');
%     ylabel('RD-y position [m]');
%     %title('Survey area');
%     box on;
%     XL=get(chartax,'XLim');
%     YL=get(chartax,'YLim');
%     chartaxpos=get(chartax,'Position');
%     text(D.x(510,150),D.y(510,150),'Scheveningen','FontSize',8,'Rotation',48);
%     text(D.x(60,100),D.y(60,100),'Hoek van Holland','FontSize',8);
%     nemo_northarrow(2500,2500,77500,465000,270,'k',10);
%     text(5.5e4,4.71e5,'a','FontSize',12);
%    
%     pcax=axes('Position',chartaxpos);
%     pcolor(pcax,D.x,D.y,squeeze(D.altitude(7,:,:))); shading flat; colormap(pcax,zmcmap(19)); clim([-12 7]);
%     set(pcax,'Color','none','XTick',[],'YTick',[]); box off; grid off;
%     axis square; xlim(XL); ylim(YL); axis square;
%     %cb=colorbar('Position',[chartaxpos(1)+chartaxpos(3)*0.7, chartaxpos(2)+chartaxpos(4)/5, chartaxpos(3)*0.05, chartaxpos(4)/4]);
%     clim([-12 7]);
%     cb=colorbar('Position',[0.195 0.32 0.0167 0.20]);
%     cb.Label.String='Altitude [m+NAP]    ';
    

    %%% Inset
    %insax=axes('Position',[chartaxpos(1)+0.1*chartaxpos(3), chartaxpos(2)+chartaxpos(4)*2/3, chartaxpos(3)/4, chartaxpos(4)/4]);
%     insax=axes('Position',[chartaxpos(1)+0.02*chartaxpos(3), chartaxpos(2)+chartaxpos(4)*0.44, chartaxpos(3)/2, chartaxpos(4)/2]);
    nemo_plot_northseamap;
    text(-0.13,1.22,'a','FontSize',12);
    xlabel(chartax,['Longitude [',char(176),'E]']);
    ylabel(chartax,['Latitude [',char(176),'N]']);
    %nc_plot_coastline('coastline','holland','coordsys','RD','fill',[1 1 1]);
% %     %xlim([-36687   39422]);
% %     %ylim([262500 1054800]);
% %     hold on
% %     plot([XL(1) XL(2)],[YL(1) YL(1)],'r','LineWidth',1);
% %     plot([XL(1) XL(1)],[YL(1) YL(2)],'r','LineWidth',1);
% %     plot([XL(2) XL(2)],[YL(1) YL(2)],'r','LineWidth',1);
% %     plot([XL(1) XL(2)],[YL(2) YL(2)],'r','LineWidth',1);
% %     axis equal
% %     %axis tight
% %     xlim([-366870  394220]);
% %     ylim([ 262500 1054800]);
% %     insax.XTick=[];
% %     insax.YTick=[];
% %     insax.Box='on';
% %     insax.BoxStyle='full';
% %     insax.Color=[0.9 0.9 0.9];
    
    
    %%% Survey domain
     %%% Chart axes
    chartax2=subplot(1,2,2);
    nc_CL=nc_plot_coastline('coastline','holland','coordsys','RD','fill',[0.6 0.6 0.6]);
    hold on
    axis square
    xlim([ 56961  81961]);
    ylim([439870 468000]);
    xlabel('Easting [m RD]');
    ylabel('Northing [m RD]');
    %title('Survey area');
    XL=get(chartax2,'XLim');
    YL=get(chartax2,'YLim');
    chartaxpos=get(chartax2,'Position');
    text(D.x(510,150),D.y(510,150),'Scheveningen','FontSize',8,'Rotation',48);
    text(D.x(60,100),D.y(60,100),'Hoek van Holland','FontSize',8);
    nemo_northarrow(2500,2500,77500,465000,270,'k',10);
    text(5.5e4,4.71e5,'b','FontSize',12);
    
    mask=squeeze(sum(~isnan(D.z_jarkus),1)>4  & sum(~isnan(D.altitude(Time.nemo,:,:)),1)<10 ) & D.L<=17250; %Jarkus raaien
    h(1)=plot(D.x(mask),D.y(mask),'.','Color',[1 0 0],'MarkerSize',4);
    mask=squeeze(sum(~isnan(D.altitude(Time.nemo,:,:)),1)>6) & (D.L<=D.alongshore(Index.zm(1)) | D.L>=D.alongshore(Index.zm(end)));%;% & sum(~isnan(D.altitude),1)<35); NEMO raaien
    h(2)=plot(D.x(mask),D.y(mask),'.','Color',[1 1 0],'MarkerSize',4);
    mask=squeeze(sum(~isnan(D.altitude),1)>10) & (D.L>=D.alongshore(Index.zm(1)) & D.L<=D.alongshore(Index.zm(end))); %ZM raaien
    h(3)=plot(D.x(mask),D.y(mask),'.','Color',[0 0.45 0.95],'MarkerSize',4);
    box on;
    h(1)=plot(nan,nan,'s','Color',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10);
    h(2)=plot(nan,nan,'s','Color',[1 1 0],'MarkerFaceColor',[1 1 0],'MarkerSize',10);
    h(3)=plot(nan,nan,'s','Color',[0 0.45 0.95],'MarkerFaceColor',[0 0.45 0.95],'MarkerSize',10);
    h(4)=plot(71552, 453583,'*k'); % Location of Nearshore waves in m RD.
    legend(h,{'Jarkus','Nemo','Sand Engine','Nearshore waves'},'Location','NW');
    
% % %     %%% Inset
% % %     insax2=axes('Position',[chartaxpos(1)+0.1*chartaxpos(3), chartaxpos(2)+chartaxpos(4)/2, chartaxpos(3)/4, chartaxpos(4)/4]);
% % %     nc_plot_coastline('coastline','holland','coordsys','RD','fill',[1 1 1]);
% % %     %xlim([-36687   39422]);
% % %     %ylim([262500 1054800]);
% % %     hold on
% % %     plot([XL(1) XL(2)],[YL(1) YL(1)],'r','LineWidth',1);
% % %     plot([XL(1) XL(1)],[YL(1) YL(2)],'r','LineWidth',1);
% % %     plot([XL(2) XL(2)],[YL(1) YL(2)],'r','LineWidth',1);
% % %     plot([XL(1) XL(2)],[YL(2) YL(2)],'r','LineWidth',1);
% % %     axis equal
% % %     %axis tight
% % %     xlim([-366870  394220]);
% % %     ylim([ 262500 1054800]);
% % %     insax2.XTick=[];
% % %     insax2.YTick=[];
% % %     insax2.Box='on';
% % %     insax2.BoxStyle='full';
% % %     insax2.Color=[0.9 0.9 0.9];
    
    %%% PRINT
    %f1=gcf; f1.Renderer='painters';
     nemo_print2paper('map',[18.35 10]);

%% Figure3: surveydates
nemo_plot_surveydates;
nemo_print2paper('surveydates1',[18.35 5]);
    
%% Figure4: Gaussian example
nemo_plot_gaussfit(D,'z_jnz',0,17);
ylim([-800 1200]);
%set(gca,'FontSize',9);
nemo_print2paper('gausfitexample5',[18.35 6]);

%% Figure5: Wave Climate
% nemo_plot_wave_rose(D,[1 38],eur,wzm,'TH','Hs');
nemo_plot_wave_rose(D,[1 38],WO(1),W,'th0','hm0');

% % % %% Figure4: Wave Timeseries
% % % drel=W.hdir+48.7; drel(drel>180)=drel(drel>180)-360;
% % % drelo=WO(1).th0+48.7; drelo(drelo>180)=drelo(drelo>180)-360;
% % % 
% % % figure;
% % % ax1=subplot(3,1,1);
% % %     plot(ax1,WO(1).time(1:18:end),WO(1).hm0(1:18:end),'-g');
% % %     hold on;
% % %     vline(D.time(Time.all),'-r');
% % %     plot(ax1,W.time(1:18:end),W.hm0(1:18:end),'-k');
% % %     ylabel('H_{s} [m]');
% % %     xlim(D.time([1 38]));
% % %     datetickzoom('x','yyyy','KeepLimits');
% % %     ylim([0 5]);
% % %     
% % % ax2=subplot(3,1,2);
% % %     plot(ax2,WO(1).time(1:18:end),WO(1).tp(1:18:end),'-g');
% % %     hold on;
% % %     vline(D.time(Time.all),'-r');
% % %     plot(ax2,W.time(1:18:end),W.tp(1:18:end),'-k');
% % %     ylabel('T_{p} [s]');
% % %     xlim(D.time([1 38]));
% % %     datetickzoom('x','yyyy','KeepLimits');
% % %     ylim([0 11]);
% % % ax3=subplot(3,1,3);
% % %     plot(ax3,WO(1).time(1:18:end),drelo(1:18:end),'-g');
% % %     hold on;
% % %     vline(D.time(Time.all),'-r');
% % %     plot(ax3,W.time(1:18:end),drel(1:18:end),'-k');
% % %     xlabel('Time [year]');
% % %     ylabel('\theta-\alpha [deg]');
% % %     xlim(D.time([1 38]));
% % %     datetickzoom('x','yyyy','KeepLimits');
% % %     ylim([-180 180]);
% % %     ax3.YTick=[-180:90:180];
% % % ax5=axes('Position',ax3.Position,'YAxisLocation','right','Color','none');
% % %     ax5.XAxis.Visible='off';
% % %     ax5.YLim=[-180 180];
% % %     ax5.YTick=[-131.3000  -41.3000  48.7000  138.7000 ];
% % %     ax5.YTickLabel={'S','W','N','E'};
% % %     grid off
% % %     ylabel('\theta [deg N]');
% % %     
% % % ax4=axes('Position',ax1.Position,'XAxisLocation','top','Color','none');
% % %     ax4.YAxis.Visible='off';
% % %     ax4.XLim=ax1.XLim;
% % %     grid off
% % %     ax4.XTick=D.time(Time.all);%([1:5,7,9,11,13:20,22:29,31:37]))';
% % %     ax4.XTickLabel=[];%num2str(([1:5,7,9,11,13:20,22:29,31:37])','%i');
% % %     %xlabel('Survey [-]');
% % %     hold on;
% % %     
% % %     h1=plot(nan,nan,'-g');
% % %     h2=plot(nan,nan,'-k');
% % %     h3=plot(nan,nan,'-r');
% % %     leg=legend([h1,h2,h3],{'Europlatform','Nearshore','Surveys'},'Location','NE','Color',[1 1 1]);
% % %     leg.Position=leg.Position+[0.1 0.08 0 0];
% % %     
% % % nemo_print2paper('wavetimeseries',[18.35 12]);

%% Figure6: Bathymetric development
nemo_plot_bathy_bedlch_year;
nemo_print2paper('bathydev2',[18.35 20]);

%% Figure7: Volume time-stack
figure;
set(gcf,'Units','centimeters','Position',[5 2 18.35 8]);
%nemo_plot_volume_stack(D,Vex.comp,'dv',Index.all,Time.all,'cum');
nemo_plot_volume_stack(D,V,'dv',Index,1:38,'paper',Time);
%set(h,'EdgeColor','k','EdgeAlpha',0.2);
%h=plot([D.alongshore(1:10:end) D.alongshore(1:10:end)],[D.time(1)-30 D.time(end)+30],'-k');
title([]);
ax=gca;
ax.XAxis.Exponent = 3;
xlabel('Alongshore distance [m]');
xlim([-200 17350]);
ylim([D.time(1)-30 datenum(year(D.time(end))+1,1,1)]);
datetickzoom('y','keeplimits');
ylabel('Time [year]')
clim([-2500 2500]);
%colormap(usem(2500,100,5));
colormap(nemo_cmap_volch);
%colormap(jwb(80,50/2500)); clim([-2500 2500]);
%set(gcf,'Units','centimeters','Position',[5 2 9 9]);
cb=colorbar;
cb.Label.String={'Net volume change [m^3/m]';''};
cb.Ticks=[-2500 -2000 -1500 -1000 -500 -200 0 200 500 1000 1500 2000 2500];
tl = cb.TickLabels;
tl(ceil(length(tl)/2)) = {[char(177),'50']};
cb.TickLabels = tl;
nemo_print2paper('volchangestack',[18.35 10]);
%nemo_print2paper('volch_stack',[18 11]);

%% Figure8: Volume line
% % % figure('Units','centimeters','Position',[8 5 15 10]);
% % % subplot(2,1,1);
figure('Units','centimeters','Position',[8 5 18.35 5]);
plot(D.alongshore,nansum(V.comp.dv,1),'.-k');
hold on;
hline(0,'--k');
xlabel('Alongshore distance [m]');
ylabel('Net volume change [m^3/m]     ');
xlim([0 17250]);
ylim([-3500 2500]);
set(gca,'YTick',(-3000:1000:2500));

nemo_print2paper('voltrsp',[15 5]);
% % % text(-3000,4000,'a');
% % % % % vaxt=gca;
% % % % % vaxa=axes('Position',vaxt.Position);
% % % % % vaxa.Color='none';
% % % % % vaxa.YAxisLocation='right';
% % % % % hold on;
% % % % % %plot(D.alongshore,nansum(Vex.comp.dv,1)./(D.time(end)-D.time(1)).*365.25,'.-r');
% % % % % xlim([0 17250]);
% % % % % vaxa.XTickLabel=' ';
% % % % % set(vaxa,'YLim',[-3000 2500]./(D.time(end)-D.time(1)).*365.25);
% % % % % ylabel('Mean annual net volume change [m^3/m/y]');
% % % % % linkaxes([vaxa,vaxt],'x');
% % % 
% % % subplot(2,1,2);
% % % plot(D.alongshore,-(nancumsum(nansum(V.comp.dv,1).*D.binwidth')./((D.time(end)-D.time(1))/365.25)),'.-k');
% % % hold on;
% % % hline(0,'--k');
% % % xlabel('Alongshore distance [m]');
% % % ylabel('Sediment transport [m^3/y]');
% % % xlim([0 17250]);
% % % ylim([-3.5e5 5.5e5]);
% % % 
% % % text(-3000,6e5,'b');
% % % 
% % % nemo_print2paper('voltrsp',[15 10]);


%% Figure9: Balance Areas 
figure('Units','centimeters','Position',[8 1 18.35 10],'Renderer','painters','RendererMode','manual');
nemo_plot_balanceareas(D);

%% Figure10: Waveseries
figure('Units','centimeters','Position',[8 0.5 18.35 20],'Renderer','painters','RendererMode','manual');
nemo_plot_lsbalanceareas_waveseries(D,V,W,Time);

nemo_print2paper('wavser2',[18.35 20]);

%% Verti volch
% % [~, ~, ~, axx,dvls]=nemo_plot_verticalvolch(D,VH,Index.all,Time.all,true);
% % axx(1).XLabel=[];
% % axx(1).XTickLabel=[];
% % axx(2).YLabel=[];
% % axx(2).XLabel.String='\DeltaV_{net} [m^{3}/m_{altitude}]';
% % axx(2).Title.String='Alongshore integrated \DeltaV_{net}';
% % axx(2).XAxis.ExponentMode='manual';
% % axx(2).XAxis.Exponent=0;
% % axx(2).XTickLabel=[-6:2:4];
% % text(4.1e5,-12,'\times10^{5}','Parent',axx(2));
% % axx(3).YLabel.String='\DeltaV_{net} [m^{3}/m_{alongshore}]';
% % axx(3).Title.String='Altitude integrated \DeltaV_{net}';
% % axx(3).XTick=[0:2000:17000];
% % axx(3).XAxis.Exponent=3;
% % 
% % nemo_print2paper('vvc',[18.35 10]);

%% Figure11: Fittingparameters
if ~exist('q','var');
    depths=(-10:2:0);
    cl.ls=nan(length(depths),38,644);
    cl.cs=nan(length(depths),38,644);
    for d=1:length(depths);
        for t=1:length(D.time); 
            %[~,~,cl.ls(d,t,:),cl.cs(d,t,:),~,~]=nemo_coastline_orientation(D,'altitude',depths(d),t,6,false); 
            [cl.ls(d,t,:),cl.cs(d,t,:)]=nemo_depth_contour_lc(D,'altitude',depths(d),t);
        end
        q(d)=nemo_gaus_fit(D,squeeze(cl.ls(d,:,:)),squeeze(cl.cs(d,:,:)),266:473,[1:9,11:38],0);
    end
    fn=fieldnames(q); for f=1:length(fn); for d=1:length(depths); fparams.(fn{f})(:,d)=q(d).(fn{f});end;end;
    legdep=[{'-10m NAP'} {' -8m NAP'} {' -6m NAP'} {' -4m NAP'}  {' -2m NAP'} {'  0m NAP'}];
end

%figure('Units','centimeters','Position',[8 3 9 21]);
figure('Units','centimeters','Position',[8 3 18.35 13]);
%corder=cbrewer('qual','Set1',length(depths));
%corder=jet(length(depths)); 
corder=[     0    0.4470    0.7410;
        0.3010    0.7450    0.9330;        
        0.4660    0.6740    0.1880;
        0.9290    0.6940    0.1250;
        0.8500    0.3250    0.0980;
        0.4940    0.1840    0.5560;
        0.6350    0.0780    0.1840];

markerstyles={'v','o','s','^','x','.'};
    
ax10=subplot(2,2,1);
    ax10.ColorOrder=corder;%jet(length(depths));
    hold on;
    h=plot(ax10,D.time(Time.all),fparams.a(Time.all,:)+fparams.e(Time.all,:)-773,'.-');
    hold on;
    box on;
    xlim([datenum(year(D.time(1)),6,1), datenum(year(D.time(end))+1,1,1)]);
    datetick('x','yyyy','keeplimits');
    ylim([700 1700]);
    ylabel('Cross-shore extent [m]');
    xlabel('Time [year]');
    text(D.time(1)-600,1780,'a','FontSize',12);
    vline(datenum(2012,03,1),'--k');
    
ax12=subplot(2,2,2);
    ax12.ColorOrder=corder;%jet(length(depths));
    hold on;
    hh=plot(ax12,D.time(Time.all),4.*sqrt(2).*fparams.c(Time.all,:),'.-');
    box on;
    xlim([datenum(year(D.time(1)),6,1), datenum(year(D.time(end))+1,1,1)]);
    datetick('x','yyyy','keeplimits');
    ylim([3000 6500]);
    ylabel('Alongshore extent [m]')
    xlabel('Time [year]')
    text(D.time(1)-600,6850,'b','FontSize',12);
    vline(datenum(2012,03,1),'--k');
    
ax11=subplot(2,2,3);     
    ax11.ColorOrder=corder;%jet(length(depths));
    hold on
    hhh=plot(ax11,D.time(Time.all),fparams.b(Time.all,:),'.-'); 
    grid on; box on;
    ylabel('Alongshore mean position [m]')
    ax11.YAxis.Exponent = 3;
    xlim([datenum(year(D.time(1)),6,1), datenum(year(D.time(end))+1,1,1)]);
    datetick('x','yyyy','keeplimits');

    ylim([9850 10200])
    xlabel('Time [year]')
    text(D.time(1)-600,10250,'c','FontSize',12);
    vline(datenum(2012,03,1),'--k');
    
    for n=1:length(h);
        h(n)  .Marker=markerstyles{n};
        h(n)  .MarkerSize=5;
        hh(n) .Marker=markerstyles{n};
        hh(n) .MarkerSize=5;
        hhh(n).Marker=markerstyles{n};
        hhh(n).MarkerSize=5;
    end
    h(6)  .MarkerSize=10;
    hh(6) .MarkerSize=10;
    hhh(6).MarkerSize=10;
    
ax22=subplot(2,2,4);
    ax22.ColorOrder=corder;
    hold on;
    ax22.Visible='off';
    leg=legend(flipud(hh),fliplr(legdep));%,'Location','NW','FontSize',8);
    %leg.Position=[0.1832, 0.5544, leg.Position(3:4)];
    leg.Position=[ax12.Position(1), ax11.Position(2), leg.Position(3:4)];

%nemo_print2paper('fparam',[9 21]);
nemo_print2paper('fparam5',[18.35 13]);


%% Figure12: Profile adjustment
nemo_plot_profile_adjustment;
nemo_print2paper('profileadjustment',[18.35 13]);
% if alt
%     nemo_print2paper('profile_adjustment2',[18.35 13]);
% else
%     leg.FontSize=8;
%     nemo_print2paper('profile_adjustment',[8 21]);
% end

%% Figure 13: Slope changes
% Time.all=Time.all(Time.all<=37);
[slope,~,~,~]=nemo_build_slope(D,'z_jnz',-3,-8);
sl38=(-[nanmean(slope(:,312:329),2),nanmean(slope(:,345:380),2),nanmean(slope(:,392:412),2)]);
[slope,~,~,~]=nemo_build_slope(D,'z_jnz',+1.5,-1.5);
sl11=(-[nanmean(slope(:,312:329),2),nanmean(slope(:,345:380),2),nanmean(slope(:,392:412),2)]);

figure;
ax=gca; 
ax.ColorOrder=[0 0 1; 0 1 0; 1 0 0];
% ax.LineStyleOrder={'-','--'};
hold on; box on;
h=plot(ax,D.time(Time.all),sl38(Time.all,:),'-x');
g=plot(ax,D.time(Time.all),sl11(Time.all,:),'--v');
leg=legend(ax,[h,g],'South -3 to -8m','Centre -3 to -8m','North -3 to -8m','South +1.5 to -1.5m','Centre +1.5 to -1.5m','North +1.5 to -1.5m','Location','NE','NumColumns',2);
leg.Position=leg.Position+[0 0.08 0 0];
xlim([datenum(2011,06,01),datenum(2017,01,01)]);
datetickzoom('x','yyyy','keeplimits');
xlabel('Time [year]');
ylabel('Slope [rad]');
ax2=axes('Position',ax.Position,'YAxisLocation','right','YLim',ax.YLim,...
    'YTick',ax.YTick,...
    'YTickLabel',cellstr(num2str(round(1./ax.YTick'))),...
    'GridColor','none','Color','none');
ax2.XAxis.Visible='off';
ylabel('Slope [1/m]');

nemo_print2paper('slope2',[18.35 10]);

%% Figure 14: Depth of Closure
%stdz=0.210;
[~,~,c,d]=nemo_closuredepth(D,'altitude',0.20,Index.zm([3:end]),Time.all,0,0);
[~,~,c_j,d_j]=nemo_closuredepth(D,'z_jarkus',0.22,Index.jarkus,Time.jarkus,0,0);%,W,Time);
% 
% i1=find(W.time==D.time(1));   %1st time index of wave series
% i2=find(W.time==D.time(end)); %last time index of wave series
% dt=W.time(i2)-W.time(i1);     %time span
% pct=1-0.5/dt;                   %12h percentile
% hs=W.Hs(i1:i2); hs=hs(W.mask(i1:i2)); %mask values outside range and nans
% He=percentile(hs,100*pct);
% Te=W.Tp(find((W.Hs-He)==min(abs(W.Hs-He)))); %Te=W.Tp(W.Hs==He);
% 
% doc_h= 2.28*He - 68.5*(He^2/(9.81*Te^2));

% % % % % % i1=find(WE.time==D.time(1));   %1st time index of wave series
% % % % % % i2=find(WE.time==D.time(end)); %last time index of wave series
% % % % % % dt=WE.time(i2)-WE.time(i1);     %time span
% % % % % % pct=1-0.5/dt;                   %12h percentile
% % % % % % hs=WE.h(i1:i2); hs=hs(WE.mask(i1:i2)); %mask values outside range and nans
% % % % % % He=percentile(hs,100*pct);
% % % % % % %Te=mean(WE.p(find((WE.h-He)==min(abs(WE.h-He))))); %Te=W.Tp(W.Hs==He); %Corresponding wave period to He.
% % % % % % Te= mean(WE.p(abs(WE.h-He)<0.1));
% % % % % % 
% % % % % % MLW=0;%-0.68; % m NAP
% % % % % % doc_h= -( 2.28*He - 68.5*(He^2/(9.81*Te^2)) )+ MLW;
doc_h=-8.4;
figure('Units','centimeters','Position',[5 5 18 6]);
    plot(D.alongshore(Index.zm),d(Index.zm),'.k'); 
    hold on; 
    plot(D.alongshore(Index.jarkus),d_j(Index.jarkus),'xk');
    hold on;
    plot(D.alongshore([1 end]),[doc_h doc_h],'--k');
    %plot(D.alongshore(Index.jarkus),smooth1_nan(d(Index.jarkus)),'-r')
    xlim([0 17250]);
    ylim([-12 -2]);
    %title('Depth of closure 2012-2016');
    legend('Sand Engine','Jarkus','Hallermeier','Location','SW');
    xlabel('Alongshore distance [m]');
    ylabel('Depth of closure [m NAP]');
    ax=gca;
    ax.XAxis.Exponent=3;
% %     text(-3000,0,'b');


nemo_print2paper('depthofclosure',[18.35 6]);
%% Figure15: Correlations Alongshore
figure;
ax1=subplot(2,1,1);
h1=plot(ax1,D.alongshore,Q.dvn500.rms.P_ls.alongshore.rp,'.r');
hold on;
h2=plot(ax1,D.alongshore,Q.dvg500.rms.P_ls.alongshore.rp,'xk');
hline(0,'--k');
legend(ax1,[h1;h2],{'Net volume change','Gross volume change'},'Location','Best');
xlabel('Alongshore distance [m]');
ylabel('Correlation coefficient');
title('Correlation of RMS Alongshore Wave Power and Volume Change');
xlim([0 17250]);
ax1.XAxis.Exponent=3;
text(ax1,-2200,1.3,'a');

ax2=subplot(2,1,2);
plot(ax2,D.alongshore,Q.dvn500.rms.P_ls.alongshore.pp,'.r');
hold on;
plot(ax2,D.alongshore,Q.dvg500.rms.P_ls.alongshore.pp,'xk');
hline(0.05,'--k');
xlabel('Alongshore distance [m]');
ylabel('Probability of non-correlation');
xlim([0 17250]);
ax2.XAxis.Exponent=3;
text(ax2,-2200,1.15,'b');

nemo_print2paper('corr_ls',[20 15]);

%% Figure 17: Efficiency parameters
figure('Units','Centimeters','Position',[5 5 15 3]);
%panel a
plot([-4 4]-9,[0 0],'-','Color',[0 0 0],'LineWidth',3);
hold on;
plot([-1 -1 1 1]-9,[0 2 2 0],':','Color',[0.2 0.2 0.2],'LineWidth',1);
h=patch([-0.95 -0.95 0.95 0.95]-9,[0 1.5 1.5 0],[0.5 0.5 0.5]);
h.EdgeColor='none';
axis equal;
text(-8,-0.5,'Shoreline');
text(-10,1.8,{' Volume';' area'});
text(-10,0.4,{' Nourishment'});
text(-13,2.2,'a');

%panel b
plot([-4 4],[0 0],'-','Color',[0 0 0],'LineWidth',3);
plot([-3 -3 -1.05 -1.05 nan 1.05 1.05 3 3],[0 2 2 0 nan 0 2 2 0],'--','Color',[0 0 0],'LineWidth',1);
plot([-1 -1 1 1],[0 2 2 0],':','Color',[0.2 0.2 0.2],'LineWidth',1);
h=patch([-0.95 -0.95 0.95 0.95],[0 1.5 1.5 0],[0.5 0.5 0.5]);
h.EdgeColor='none';
axis equal;
text(1,-0.5,'Shoreline');
text(-3,1,{' Volume';' adjacent'});
text(1.05,1,{' Volume';' adjacent'});
text(-1,1.8,{' Volume';' nourishment'});
text(-1,0.4,{' Nourishment'});
text(-4,2.2,'b');
box off
grid off
axis off
xlim([-13 4]);
ylim([-0.5 2]);
nemo_print2paper('eff',[18 5]);

%% Figure 12: Efficiency
figure('Units','centimeters','Position',[8 3 15 10]);
dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,160:285).*repmat(D.binwidth(160:285)',37,1),1),2)];
dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',37,1),1),2)];
dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)];
dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',37,1),1),2)];
dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',37,1),1),2)];
dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,325:395).*repmat(D.binwidth(325:395)',37,1),1),2)];
dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,160:end).*repmat(D.binwidth(160:end)',37,1),1),2)];

plot(D.time,1+(dvzm ./17.5e6),'.-k');
hold on; 
plot(D.time,1+(dvall./17.5e6),'o-k');
plot(D.time,1-(dvall./dvzmC),'*-k'); 
legend('volumetric efficiency footprint','volumetric efficiency coastal cell','feeding efficiency','Location','SE');
datetickzoom('x','mm-''yy','keeplimits');
ylim([0.5 1]);
xlim([D.time(1)-30 D.time(end)+30]);
xlabel('Time');
ylabel('Efficiency [-]');

nemo_print2paper('efficiency',[15 10]);

%% FigureN: Volume ontwikkeling Delflandse kust (Jarkus)
a=sum(~isnan(DL.altitude),3); mask=a>20;
for t=1:52; pos=-diff(DL.alongshore1(mask(t,:))); bwj(t,mask(t,:))=[2*pos(1),pos(1:end-1)+pos(2:end),2*pos(end)]./2; end;
Nourishment=nemo_load_nourishments(D,1965,2016);
vdl=nancumsum(nansum(VJ.dv.*bwj,2),1)-nancumsum([Nourishment.voldl(2:end);0]);
vj=nancumsum(nansum(VJ.dv.*bwj,2),1);

VJ.time.netvolch=nan(52,1);     VJ.time.netvolch=[0;vj(1:end-1)];
VJ.time.nourishments=nan(52,1); VJ.time.nourishments=nancumsum([Nourishment.voldl(2:end);0]);
VJ.time.corrvol=nan(52,1);      VJ.time.corrvol=[0;vdl(1:end-1)];
VJ.time.time=nanmean(DL.time_bathy(:,27:145),2)+datenum(1970,1,1);

figure; plot(VJ.time.time(9:end),VJ.time.netvolch(9:end)-VJ.time.netvolch(9),'x-k',...
             VJ.time.time(9:end),VJ.time.nourishments(9:end)-VJ.time.nourishments(9),'.-r',...
             VJ.time.time(9:end),VJ.time.corrvol(9:end)-VJ.time.corrvol(9),'o-b');
ylabel('Net volume change [m^3]');
xlabel('Time');
title({'Net change of volume in the Delfland';'coastal cell, w.r.t 1973'});
datetickzoom('x','yyyy');
legend('Net volume change','Nourished volume','\DeltaV - nourishments','Location','NW');
ax=gca;
%tp=ax.Title.Position;
%ax.Title.Position=[datenum(1998,1,1) tp(2) tp(3)];
ax.XTickLabelRotation=90;
%set(gcf,'PaperUnits','centimeters','PaperSize',[15 10],'PaperPosition',[0 0 15 10],'PaperOrientation','portrait');
%print('./figures/paper/vdl','-depsc','-loose');
%eps2pdf('./figures/paper/vdl.eps','./figures/paper/vdl.pdf');

nemo_print2paper('volch_delfland',[9 9]);



%% Figure18: Cross-section of the Sand Engine with different horizontal slices
nemo_plot_zmcslayers(D,DL,363,86,[5,1.7,-8]);
xlim([-200 2200]);
ylim([-13 13]);
%ll=legend('Aeolian & Slumping zone','Hydrodynamic zone','Static zone','Survey March 2011','Survey August 2011','Survey July 2016','Location','NE','FontSize',7);
ll=legend('Aeolian & Slumping','Hydrodynamic','Shoreface','Survey Mar-2011','Survey Aug-2011','Survey Jul-2016','Location','NE');%,'FontSize',7);
%ll.Position=ll.Position+[0 0.05 0 0];

nemo_print2paper('horslices2',[15 10]);