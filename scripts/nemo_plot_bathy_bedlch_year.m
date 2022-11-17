%NEMO_PLOT_BATHY_BEDLCH_YEAR Plots maps of bathymetry and bedlevel change in two columns.
%
%   Plots sedimentation/erosion maps on time interval of 1 year. All maps are
%   plotted on 1 figure.
%
%   Syntax:
%       nemo_plot_bathy_bedlch_year.m
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

figure('Renderer','painters');
AX=subplot_meshgrid(2,6,[0.08 0.11 0.02],[0.02 0.02 0.02 0.02 0.02 0.02 0.05]);

for n=1:6;
    axes(AX(1,n));
    pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:)));
    shading flat;
    axis equal;
    xlim([6000 14000]);
    ylim([-150 1550]);
    title(['Bathymetry ',datestr(D.time(Time.july(n)),'mmm yyyy')]);
    nemo_northarrow(500,500,13500,1250,-48,'k',10);
    text(5300,2300,alphabet(n),'FontSize',12);
    colormap(gca,zmcmap(19));
    clim([-12 7]);
    if n==3;
        ylabel('Cross-shore position [m]');
    end
    if n==6;
        xlabel('Alongshore position [m]');
    end
    AX(1,n).XAxis.Exponent=3;
    set(gca,'layer','top','Box','on');
end

for n=2:6;
    axes(AX(2,n));
    if D.time(Time.july(n))>D.time(7);
    pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:))-squeeze(D.altitude(7,:,:)));
    hold on;
    end
    pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:))-squeeze(D.altitude(1,:,:)));
    shading flat;
    axis equal;
    xlim([6000 14000]);
    ylim([-150 1550]);
    nemo_northarrow(500,500,13500,1250,-48,'k',10);
    title(['Bedlevel change ',datestr(D.time(1),'mmm yyyy'),' - ',datestr(D.time(Time.july(n)),'mmm yyyy')]);
    text(5300,2300,alphabet(n+5),'FontSize',12);
    colormap(gca,usem(6,0.2,6));
    clim([-6 6]);
    if n==3;
        ylabel('Cross-shore position [m]');
    end
    if n==6;
        xlabel('Alongshore position [m]');
    end
    AX(2,n).XAxis.Exponent=3;
    set(gca,'layer','top','Box','on');
end
%%
% %ax(2)=axes('Position',[0.50 1-(1/6) 0.40 0.95*1/6]);
cb1=colorbar('peer',AX(1,1),'Location','North');
cb1.Label.String='Altitude [m+NAP]';
%cb1.Position=[0.55 0.95 0.35 0.15*1/6];
hold on;
%cb1.TickLength=0.1;
cb2=colorbar('peer',AX(2,2),'Location','South');
cb2.Label.String='Bedlevel change [m]';
pos=cb2.Position;
cb2.Position=[pos(1) pos(2)+0.15 pos(3) pos(4)];
cb1.Position=[pos(1) pos(2)+0.17 pos(3) pos(4)];
delete(AX(2,1));
% % figure;
% % 
% % for n=1:6;
% %     %subplot(6,2,2*n-1);
% %     ax(2*n-1)=axes('Position',[0.07 1-0.95*(1/6*n) 0.40 0.70*1/6]);
% %     pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:)));
% %     shading flat;
% %     axis equal;
% %     xlim([6000 14000]);
% %     ylim([-200 2000]);
% %     title(['Bathymetry ',datestr(D.time(Time.july(n)),'dd mmm yyyy')]);
% %     %xlabel('Alongshore distance from Hoek van Holland [m]');
% %     %ylabel('Cross-shore distance from RSP [m]');
% %     colormap(gca,zmcmap(19));
% %     clim([-12 7]);
% %     if n==3;
% %         ylabel('Cross-shore distance from RSP-line [m]');
% %     end
% %     if n==6;
% %         xlabel('Alongshore distance from Hoek van Holland [m]');
% %     end
% %         
% %     if D.time(Time.july(n))>D.time(1);
% %     %subplot(6,2,2*n);
% %     ax(2*n)=axes('Position',[0.55 1-0.95*(1/6*n) 0.40 0.70*1/6]);
% %     if D.time(Time.july(n))>D.time(7);
% %     pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:))-squeeze(D.altitude(7,:,:)));
% %     hold on;
% %     end
% %     pcolor(D.ls,D.cs-950,squeeze(D.altitude(Time.july(n),:,:))-squeeze(D.altitude(1,:,:)));
% %     shading flat;
% %     axis equal;
% %     xlim([6000 14000]);
% %     ylim([-200 2000]);
% %     title(['Bedlevel change from ',datestr(D.time(1),'dd mmm yyyy'),' to ',datestr(D.time(Time.july(n)),'dd mmm yyyy')]);
% %     %xlabel('Alongshore distance from Hoek van Holland [m]');
% %     %ylabel('Cross-shore distance from RSP [m]');
% %     %colormap(gca,jwb(100,0.01)); csym;
% %     colormap(gca,flipud(cbrewer('div','RdBu',11))); csym;
% %     clim([-6 6]);
% %     end
% %     
% %     if n==3;
% %         ylabel('Cross-shore distance from RSP-line [m]');
% %     end
% %     if n==6;
% %         xlabel('Alongshore distance from Hoek van Holland [m]');
% %     end
% % end
% % %ax(2)=axes('Position',[0.50 1-(1/6) 0.40 0.95*1/6]);
% % cb1=colorbar('peer',ax(1),'Location','North');
% % cb1.Label.String='Altitude [m+NAP]';
% % %cb1.Position=[0.55 0.95 0.35 0.15*1/6];
% % hold on;
% % %cb1.TickLength=0.1;
% % cb2=colorbar('peer',ax(4),'Location','South');
% % cb2.Label.String='Bedlevel change [m]';
% % pos=cb2.Position;
% % cb2.Position=[pos(1) pos(2)+0.145 pos(3) pos(4)];
% % cb1.Position=[pos(1) pos(2)+0.245 pos(3) pos(4)];