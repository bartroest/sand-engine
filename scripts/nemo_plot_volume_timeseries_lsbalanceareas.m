function [VLS]=nemo_plot_volume_timeseries_lsbalanceareas(D,V,WE,cumunit)
%nemo_plot_volume_timeseries_lsbalanceareas Plots volumes per budget area.
%
%   Plots the volume timeseries for designated sediment budget areas. These
%   areas are: Sand Engine North, -Centre and -South, Nemo North and -South.
%   The unit against which is plotted is 'time' by default, but can be switched
%   to the alongshore component of wave energy, cumulative.
%
%   Optionally the volumes are output.
%
%   Syntax:
%       [VLS]=nemo_plot_volume_timeseries_lsbalanceareas(D,V,cumunit)
%
%   Input: 
%       D: Data struct
%       V: Volume struct per transect
%       WE: Wave parameters
%       cumunit: 'time' or 'energy'
%
%   Output:
%   	VLS: volumes accumulated per area
%
%   Example:
%       nemo_plot_volume_timeseries_lsbalanceareas(D,V,'time');
%
%   See also: nemo, nemo_volumes, nemo_binwidth, nemo_wave_climate

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

%% Fig

figure;
%% SED/ERO map
subplot(3,1,1); 
hold on; 
pcolor(D.ls,D.cs-850,squeeze(D.altitude(end,:,:)-D.altitude(7,:,:))); 
shading flat; 
pcolor(D.ls,D.cs-850,squeeze(D.altitude(end,:,:)-D.altitude(1,:,:))); shading flat;
axis equal;
xlim([0 17250])
ylim([-200 2500])
colormap(jwb(25,0.01)); csym;
clim([-6 6])
vline(D.alongshore([286,334,388,442]),'--k')
warning('Text is hardcoded!');
text( 3000,2200,'Nemo South');  text( 3000,1800,'+1.9\cdot10^{5}m^{3}');
text( 7300,2200,'SE South');    text( 7300,1800,'+1.2\cdot10^{6}m^{3}');
text( 9300,2200,'SE Centre');   text( 9300,1800,'-4.2\cdot10^{6}m^{3}');
text(11200,2200,'SE North');    text(11200,1800,'+1.8\cdot10^{6}m^{3}');
text(14000,2200,'Nemo North');  text(14000,1800,'+1.9\cdot10^{5}m^{3}');
title('Bed level and volume changes from Aug 2011 to Sep 2016');
ylabel('Cross-shore distance [m]');
xlabel('Alongshore distance from Hoek van Holland [m]');

%% TIMESERIES ALONGSHORE BALANCE AREAS
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
VLS.dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:285).*repmat(D.binwidth(  1:285)',37,1),1),2)];
VLS.dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',37,1),1),2)];
VLS.dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)];
VLS.dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',37,1),1),2)];
VLS.dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',37,1),1),2)];

VLS.dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,286:441).*repmat(D.binwidth(286:441)',37,1),1),2)];
VLS.dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,:).*repmat(D.binwidth',37,1),1),2)];

VLS.time=D.time;
VLS.time_nemo=D.time_nemo;

if strcmpi(cumunit,'energy')
    VLS.energy=[0;nancumsum(WE.climate.cp(1:end-1,365))];
    VLS.energy_nemo=[0;nancumsum(WE.climate.cp(1:end-1,120))];
end

subplot(3,1,[2:3]);
hold on;
if strcmpi(cumunit,'time')
        h(1)=plot(D.time_nemo(Time.nemo),VLS.dvnmZ(Time.nemo),'^-c');
        h(2)=plot(D.time_nemo(Time.nemo),VLS.dvnmN(Time.nemo),'d-m');
        h(3)=plot(D.time(Time.all),VLS.dvzmZ(Time.all),'v-b');
        h(4)=plot(D.time(Time.all),VLS.dvzmC(Time.all),'o-g');
        h(5)=plot(D.time(Time.all),VLS.dvzmN(Time.all),'s-r');

        %h(6)=plot(D.time(Time.all),VLS.dvzm(Time.all) ,'.-k');
        h(6)=plot(D.time(Time.all),VLS.dvall(Time.all) ,'*-k');
        datetick('x','mm-''yy');
        xlabel('Time');
        xlim([datenum(2011,07,01),datenum(2016,10,01)]);

elseif strcmpi(cumunit,'energy')
        h(1)=plot(VLS.energy_nemo(Time.nemo),VLS.dvnmZ(Time.nemo),'^-c');
        h(2)=plot(VLS.energy_nemo(Time.nemo),VLS.dvnmN(Time.nemo),'d-m');
        h(3)=plot(VLS.energy(Time.all),VLS.dvzmZ(Time.all),'v-b');
        h(4)=plot(VLS.energy(Time.all),VLS.dvzmC(Time.all),'o-g');
        h(5)=plot(VLS.energy(Time.all),VLS.dvzmN(Time.all),'s-r');

        h(6)=plot(VLS.energy(Time.all),VLS.dvall(Time.all) ,'*-k');
        xlabel('Cumulative wave energy [J]')
        
        ax1=gca;
        ax2=axes('Position',ax1.Position);
        ylim(ax1.YLim);
        ax2.Color='none';
        grid off;
        ax2.XAxisLocation='top';
        ax2.XTick=VLS.energy(Time.all);
        ax2.XTickLabel=datestr(D.time(Time.all),'dd-mm-yyyy');
        ax2.XTickLabelRotation=90;
end


title('Net volume change per balance area');    
ylabel('Net volume change [m^3]');


legend(h(1:6),{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','NW');
