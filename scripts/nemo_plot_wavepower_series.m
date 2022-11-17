function [wpower]=nemo_plot_wavepower_series(D,WE,area,t_index)
%NEMO_PLOT_WAVEPOWER_SERIES Calculates and plots wavepower from wave timeseries.
%
% Input:
%   D: Datastruct
%   WE: Wave timeseries struct
%   area: 'nemo', 'vb', 'zm'
%   t_index: time indices for calculation
%
% See also: nemo, nemo_waves, nemo_wave_climate

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
switch area
    case 'nemo'
        t_field='time_nemo';
        idx=65;
    case 'vb'
        t_field='time_vbnemo';
        idx=125;
    case 'zm'
        t_field='time';
        idx=365;
end

%% make wave power timeseries from wave timeseries
wpower=1/2*(1/8*1024*9.81.*(WE.h./100).^2)*9.81.*WE.p/(2*pi); %Wave power in [W/m]=[J/s/m];
%dt=nanmean(diff(WE.time)); %=1/24=1hour=3600s;
dt=3600;
w_energy=(wpower.*dt);
%% figure
figure; 
subplot(3,1,1);
hold on; 

for t=1:length(t_index)-1; 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t+1))] ,[WE.climate.cp(t_index(t),idx) WE.climate.cp(t_index(t),idx)]./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t))]   ,[0                             WE.climate.cp(t_index(t),idx)]./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
    plot([D.(t_field)(t_index(t+1)) D.(t_field)(t_index(t+1))] ,[0                             WE.climate.cp(t_index(t),idx)]./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
end

for t=1:length(t_index)-1;
    mask=WE.time>=D.(t_field)(t_index(t)) & WE.time<D.(t_field)(t_index(t+1));
    %plot(WE.time(mask),nancumsum(wpower(mask))./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-b'); 
    plot(WE.time(mask),nancumsum(w_energy(mask))./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-b'); 
end;

datetickzoom('x','mmm-''yy');
xlabel('Time');
xlim([datenum(2011,07,01),datenum(2016,10,01)]);
ylabel('Wave energy per survey interval [J]');

%%
subplot(3,1,2);
hold on; 

for t=1:length(t_index)-1; 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t+1))] ,[WE.climate.cp(t_index(t),idx) WE.climate.cp(t_index(t),idx)],'-k'); 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t))]   ,[0                             WE.climate.cp(t_index(t),idx)],'-k'); 
    plot([D.(t_field)(t_index(t+1)) D.(t_field)(t_index(t+1))] ,[0                             WE.climate.cp(t_index(t),idx)],'-k'); 
end

for t=1:length(t_index)-1;
    mask=WE.time>=D.(t_field)(t_index(t)) & WE.time<D.(t_field)(t_index(t+1));
    %plot(WE.time(mask),nancumsum(wpower(mask)),'-b');
    plot(WE.time(mask),nancumsum(w_energy(mask)),'-b');
end;

datetickzoom('x','mmm-''yy');
xlabel('Time');
xlim([datenum(2011,07,01),datenum(2016,10,01)]);
ylabel('Wave energy per survey interval [J]');

%%
ax=subplot(3,1,3);
hold on; 

for t=1:length(t_index)-1; 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t+1))] ,[WE.climate.cp(t_index(t),idx) WE.climate.cp(t_index(t),idx)].*50./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
    plot([D.(t_field)(t_index(t))   D.(t_field)(t_index(t))]   ,[0                             WE.climate.cp(t_index(t),idx)].*50./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
    plot([D.(t_field)(t_index(t+1)) D.(t_field)(t_index(t+1))] ,[0                             WE.climate.cp(t_index(t),idx)].*50./(D.(t_field)(t_index(t+1))-D.(t_field)(t_index(t))),'-k'); 
end
datetickzoom('x','mmm-''yy');
xlim([datenum(2011,07,01),datenum(2016,10,01)]);

% % ax2=axes('Position',ax.Position);
% % ax2.YAxisLocation='right';
% % for t=1:length(t_index)-1;
% %     mask=WE.time>=D.(t_field)(t_index(t)) & WE.time<D.(t_field)(t_index(t+1));
% %     %plot(WE.time(mask),nancumsum(wpower(mask)),'-b');
% %     %plot(D.(t_field)(t_index(t+1)),nansum(wpower(mask)),'*b');
% %     plot(WE.time(mask),nancumsum(w_energy(mask)),'-b');
% %     plot(D.(t_field)(t_index(t+1)),nansum(w_energy(mask)),'*b');
% % end;
% % xlabel('Time');
% % datetickzoom('x','mmm-''yy');
% % xlim([datenum(2011,07,01),datenum(2016,10,01)]);
% % ylabel('Wave energy per survey interval [J]');


end
%EOF