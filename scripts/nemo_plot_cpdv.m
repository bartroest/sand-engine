function nemo_plot_cpdv(D,V,W,Time)
%NEMO_PLOT_CPDV - Plots the volume changes of alongshore balance areas as function of wave energy.
%
% Volume changes appear to be more correlated to the incident wave energy,
% rather than time. Therefore the volume timeseries are here plotted in the
% domain of cumulative wave energy, instead of time.
%
%   Syntax:
%       nemo_plot_cpdv(D,V,W,Time,Index)
%
%   Input: 
%       D: Data struct
%       V: Volume change struct 
%       W: Nearshore wave climate struct
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_cpdv(D,V.comp,W,Time)
%
% See also: nemo, nemo_wave_climate, nemo_plot_lsbalanceareas_waveseries
%
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

%% Volume changes in balance areas
dvnmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,  1:285).*repmat(D.binwidth(  1:285)',37,1),1),2)]; %Nemo Zuid
dvzmZ=[0;nansum(nancumsum(V.comp.dv(1:end-1,286:333).*repmat(D.binwidth(286:333)',37,1),1),2)]; %ZM Zuid
dvzmC=[0;nansum(nancumsum(V.comp.dv(1:end-1,334:387).*repmat(D.binwidth(334:387)',37,1),1),2)]; %ZM centrum
dvzmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,388:441).*repmat(D.binwidth(388:441)',37,1),1),2)]; %ZM Noord
dvnmN=[0;nansum(nancumsum(V.comp.dv(1:end-1,442:612).*repmat(D.binwidth(442:612)',37,1),1),2)]; %Nemo Noord

dvzm= [0;nansum(nancumsum(V.comp.dv(1:end-1,286:441).*repmat(D.binwidth(286:441)',37,1),1),2)]; %ZM alles
dvall=[0;nansum(nancumsum(V.comp.dv(1:end-1,:      ).*repmat(D.binwidth'         ,37,1),1),2)]; %Alles (ZM+Nemo)

%% Wave power series
weNEMO=([0;nancumsum(W.climate.cp(Time.nemo(1:end-1),260))]+nansum(W.climate.cp(1:6,365))).*3600; %Wave energy nemo area + offset (starts later)
weZM=  ([0;nancumsum(W.climate.cp(Time.all(1:end-1),365))]).*3600; %wave energy Zandmotor areas;

%% Plotting
figure;
%subplot(3,1,[2:3]);
hold on;
h(1)=plot(weNEMO ,dvnmZ(Time.nemo) ,'^-c');
h(2)=plot(weNEMO ,dvnmN(Time.nemo) ,'d-m');
h(3)=plot(weZM   ,dvzmZ(Time.all)  ,'v-b');
h(4)=plot(weZM   ,dvzmC(Time.all)  ,'o-g');
h(5)=plot(weZM   ,dvzmN(Time.all)  ,'s-r');
h(6)=plot(weZM   ,dvall(Time.all)  ,'*-k');

text(weZM, repmat(-4e6,37,1), datestr(D.time(Time.all),'dd-mmm-yyyy'),'Rotation',90);

%datetick('x','mm-''yy');
title('Net volume change per balance area as function of wave energy');    
ylabel('Net volume change [m^3]');
xlabel('Wave energy [J]');

legend(h(1:6),{'Nemo South','Nemo North','SE South','SE Centre','SE North','SE+Nemo'},'Location','NW');
%wavpo=0;nancumsum(W.climate.cp(Time.all(1:end-1),365));
