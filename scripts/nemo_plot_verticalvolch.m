function [dvdh,dvdl,dvdldh,axx,dvls]=nemo_plot_verticalvolch(D,VH,index,t_index,areaswitch)
%NEMO_PLOT_VERTICALVOLCH - Plots the normalised volume change on a vertical plane.
%
% Shows the normalised volume change (m^3/m_ls/m_altitude) on a vertical
% projection plane: alongshore position versus vertical position. Values
% are with respect to the first survey at a certain position.
%
% Input: 
%       D: data struct
%       VH: struct with altitudes and 3D-matrix of volume changes.
%       index: alongshore indices 
%       t_index: time indices
%       areaswitch: plot for different alongshore balance areas [true|false]
%
% Output: 
%       dvdh: Alongshore integrated volume change per metre altitude, vector [heights 1]
%       dvdl: Alongshore integrated volume change, vector [heights 1]
%       dvdldh: Normalised volume change (dV/m_alongshore/m_height), matrix [alongshore heights]
%
% Syntax:
%       nemo_plot_hvolch(D,VH,Index.all,Time.all);
%       [dvdh,dvdl,dvdldh]=nemo_plot_hvolch(D,VH,1:644,1:38);
%
% See also: nemo_volumes_fast_h, nemo_volumes, nemo

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
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
dh=diff(VH.heights); % Height difference
bw=repmat(D.binwidth(index),1,length(dh));

dvdldh=squeeze(       nansum(VH.dv(t_index,index,:),1))./repmat(dh',length(index),1); dvdldh(dvdldh==0)=nan; %volch/m_ls/m_altitude [m^3/m/m]
dvdl=  squeeze(nansum(nansum(VH.dv(t_index,index,:),1),3)); dvdl(dvdl==0)=nan; %volch/m_ls [m^3/m]
dv=squeeze(nansum(VH.dv(t_index,index,:),1)); %volume change [m^3]
dvdh=nansum(dv.*bw,1)./dh'; %volch/m_altitude   
%dvls=nansum(dvb,1);
%mask=dv~=0;%mask=~isnan(dv);
%lsl=nansum(bw.*mask);
%dvdh=dvls./dh'; %volch/m_altitude
dvls=dvdldh.*repmat(D.binwidth(index),1,72);

%% Net volume change over altitude

figure; 
%%
ax1=subplot(3,3,[1,2,4,5]); %PCOLOR vooraanzicht [m^3/m_ls/m_alti] == [m]
pcolor(D.alongshore(index),VH.heights(1:end-1),dvdldh'); shading flat;
colormap(jwb(100,0.01)); csym; 
cb=colorbar('horizontal');
cb.Location='South';
cb.Position=[0.150 0.425 0.18 0.03];
cb.AxisLocation='in';

clim([-400 400]);
xlim([-50 17250]);
ylim(VH.heights([1 end]));
title('Net volume change [m^3/m_{alongshore}/m_{altitude}]');
xlabel('Distance from HvH [m]');
ylabel('Altitude [m+NAP]')
if areaswitch
    vv=vline(D.alongshore([286,334,388,442]),'--');
    for n=1:4; vv(n).Color=[0.7 0.7 0.7]; end
end
box on;

%%
ax2=subplot(3,3,[3,6]); % Alongshore integrated [m^3/m_altitude]
if areaswitch
    hold on
    h(1)=plot(ax2,nansum(dvls(  1:285,:),1),VH.heights(1:end-1),'^-c'); %NemoZ
    h(2)=plot(ax2,nansum(dvls(442:end,:),1),VH.heights(1:end-1),'d-m'); %NemoN
    h(3)=plot(ax2,nansum(dvls(286:343,:),1),VH.heights(1:end-1),'v-b'); %ZMZ
    h(4)=plot(ax2,nansum(dvls(344:387,:),1),VH.heights(1:end-1),'o-g'); %ZMC
    h(5)=plot(ax2,nansum(dvls(388:441,:),1),VH.heights(1:end-1),'s-r'); %ZMN
    
end
h(6)=plot(dvdh,VH.heights(1:end-1),'.-k');
ylim(VH.heights([1 end]));
xlim([-7e5 4e5]);
xlabel('Net volume change [m^3/m_{altitude}]');
ylabel('Altitude [m+NAP]')
title('Net volume change [m^3/m_{altitude}]');
vline(0,'--k');
box on;

%%
ax3=subplot(3,3,[7,8]); % Altitude integrated (==cross-shore integrated or 'ordinary volume change') [m^3/m_alongshore]
plot(D.alongshore(index),dvdl,'.-k');
xlim([-50 17250]);
ylim([-3000 2500]);
xlabel('Distance from HvH [m]');
ylabel({'Net volume change';'[m^3/m_{alongshore}]'})
title('Net volume change [m^3/m_{alongshore}]')
hline(0,'--k');
box on;
if areaswitch
    vv=vline(D.alongshore([286,334,388,442]),'--');
    for n=1:4; vv(n).Color=[0.7 0.7 0.7]; end
end

%%
if areaswitch
    leg=legend(h(1:6),{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','SW','FontSize',8);
    leg.Position=[ax2.Position(1), ax3.Position(2)-0.09, leg.Position(3:4)];
end
% % cb=colorbar(ax1,'horizontal');
% % cb.Location='South';
% % cb.Position=[ax2.Position(1), ax3.Position(2), ax2.Position(3) 0.03];
% % cb.AxisLocation='in';
axx=[ax1,ax2,ax3];
end
% print2a4('./figures/altitudevolch.png','l','n','-r200');
%EOF