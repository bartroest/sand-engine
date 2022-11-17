function nemo_plot_northseamap(lonmin,lonmax,latmin,latmax)
%NEMO_PLOT_NORTHSEAMAP Generates a map of the North Sea area with coasts and borders.
%
%   Syntax:
%       nemo_plot_northseamap(lonmin,lonmax,latmin,latmax)
%
%   Input: 
%       lonmin: minimum longitude [deg E]
%       lonmax: maximum longitude [deg E]
%       latmin: minimum longitude [deg N]
%       latmax: maximum longitude [deg N]
%
%   Output:
%   	figure
%
%   See also: nemo, m_map

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
% zm_vars
if nargin==0;
    lonlim = [-1 11]; % define os limites da area de estudo
    latlim = [49.3 56];
else
    lonlim = [lonmin,lonmax];
    latlim = [latmin,latmax];
end

north_sea_shore=load('north_sea_shore.dat');
north_sea_pol=load('north_sea_pol.dat');

% countries coordinates
cname = {'Netherlands','Belgium','Germany','UK','France','Denmark','North Sea'};
latc = [52.3; 50.8; 51.4; 52; 49.9; 55.7; 55];
lonc = [5.3; 4.6; 8.33; 0; 2.6; 7.3; 3.7];

% % % %% New attempt
% % % [xs,ys]=convertCoordinates(north_sea_shore(:,1),north_sea_shore(:,2),'CS1.code',4326,'CS2.code',28992);
% % % idx=find(isnan(north_sea_shore(:,1)));
% % % for n=1:length(idx)-1;
% % %     hold on;
% % %     mask=idx(n)+1:idx(n+1)-1;
% % %     patch(xs(mask),ys(mask),[0.8 0.8 0.8],'LineWidth',0.5);
% % % end
% % % 
% % % [xb,yb]=convertCoordinates(north_sea_pol(:,1),north_sea_pol(:,2),'CS1.code',4326,'CS2.code',28992);
% % % patch(xb,yb,[0.8 0.8 0.8],'LineWidth',0.5);
% % % 
% % % [xc,yc]=convertCoordinates(lonc,latc,'CS1.code',4326,'CS2.code',28992);
% % % text(xc,yc,cname,'HorizontalAlignment','center',...
% % %     'FontSize',8,'FontName','Helvetica');
% % % 
% % % [xt,~]=convertCoordinates(-2:2:11,52.*ones(1,7),'CS1.code',4326,'CS2.code',28992);
% % % [~,yt]=convertCoordinates(4.*ones(1,8),49:1:56,'CS1.code',4326,'CS2.code',28992);
% % % 
% % % axis equal;
% % % xticks(xt);
% % % xticklabels(cellstr(num2str([-2:2:11]','%i')));
% % % xlim(xt([1 end]))
% % % yticks(yt);
% % % yticklabels(cellstr(num2str([50:2:56]','%i')));
% % % ylim(yt([1 end]));

%%

%figure;
% iniciando o m_map
m_proj('mercator','lon',lonlim,'lat',latlim,'on');
m_patch(north_sea_shore(:,1),north_sea_shore(:,2),...
    [0.9 0.9 0.9],'LineWidth',0.2);
hold on
m_plot(north_sea_pol(:,1),north_sea_pol(:,2),'k','LineWidth',0.2);

%m_plot([4.0 4.30 4.30 4.0 4.0],[51.9 51.9 52.2 52.2 51.9],...
m_plot([3.9614 4.3189 4.3189 3.9614 3.9614],[51.9386 51.9386 52.1953 52.1953 51.9386],...
    'r','LineWidth',1);
m_plot([3.2763889;4.0666667],[51.9986111;52.55],'xr');
    
m_text(lonc,latc,cname,'HorizontalAlignment','center',...
    'FontSize',8,'FontName','Helvetica');
m_grid('linestyle','none','tickdir','in','tickstyle','da');%,'xticklabels',[],'yticklabels',[])%,'linewidth',3);
m_ruler([0.75 0.89],0.14,1,'FontSize',8,'FontName','Helvetica','LineWidth',0.7);
m_northarrow(1,55,0.75,'type',2);

% g = findall(gcf);
% for ii = 1:length(g);
%     try
%     set(g(ii),'FontSize',8,'FontName','Times');
%     end
% end

% % %set(gca,'xticklabel',[]);
% % %set(gcf,'paperunits','centimeter','paperposition',[0 0 12 9]);
% % %print('-dpng','-r300',['location_study_area'])