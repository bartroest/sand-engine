function nemo_plot_volume_timeseries(D,z,time,V,index,t_index,usecase)
%NEMO_PLOT_VOLUME_TIMESERIES Plots timeseries of the volumetric development of a transect.
%
% Plots timeseries of volume change for each transect in index.
% Calculate volumes first!
%
% Syntax:
%   nemo_plot_volume_timeseries(D,'altitude',V,index,t_index,Index);
%
% Input:
%   D: data struct
%   z: altitude fieldname
%   V: volume struct
%   index: alongshore indices
%   t_index: time indices
%   usecase: 'jarkus', 'combined' or 'zm' (sets properties)
%
% Output
%   One plot per transect (#=length(index))
%
% See also: nemo, nemo_volumes
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

%% Plot
if ~exist(usecase,'var');
    usecase='def';
end

figure;

hold on;
subplot(1,2,1);
hold on
%Vdata=nancumsum([0 dV(index,~isnan(dV(index,:)))])
%Tdata=D.(time)(t_index(~isnan(Volume(index,:))))
title(['Timeseries of transect ',num2str(index),', ',num2str(D.alongshore(index)/1000,'%4.2f'),'km from HvH, \DeltaV_{net}=',num2str(round(nansum([0; V.dv(t_index(1:end-1),index)]),-2),'%d'),'m^3/m''']);

h(2)=plot(D.(time)(t_index),nancumsum([0;V.accretion(t_index(1:end-1),index)]),'.-r');
h(3)=plot(D.(time)(t_index),nancumsum([0; -V.erosion(t_index(1:end-1),index)]),'x-b','MarkerSize',5);
h(1)=plot(D.(time)(t_index),nancumsum([0;       V.dv(t_index(1:end-1),index)]),'*-k');
legend(h,{'Net','Deposition','Erosion'},'Location','NW');

switch lower(usecase);
    case {'jarkus','combined'}
        yl=get(gca,'YLim');
        if max(abs(yl))>10000
        else
            ylim([-10000, 10000]);
        end
        %No fixed scaling
    otherwise
        %Shore/ZM/Nemo
        
%plot(Tdata,Vdata,'+-r');
        if index>=300 && index<=426; %Zandmotor area
            ylim([-4500 4500]); %pm 400;
        elseif index>=94 && index<=160 %Vlugtenburg area
            ylim([-2200 2200]);
        else
            ylim([-1500 1500]); %Nemo aera
        end
end

xlabel('Time');
ylabel('\DeltaVolume [m^3/m'']');
datetick('x');
grid on

subplot(1,2,2);
hold on;

for t=t_index(2:end-1);
gg=  plot(D.dist,squeeze(D.(z)(t,index,:)),'.-','Color',[0.9 0.9 0.9]);
end
switch lower(usecase);
    case {'jarkus','combined'}
        g(1)=plot(D.dist,squeeze(D.(z)(t_index(1),index,:)),'x-','Color',[0.4 0.4 0.4]);
        g(2)=plot(D.dist,squeeze(D.(z)(t_index(end),index,:)),'+-','Color',[0.2 0.2 0.2]);
        g(3)=plot(D.dist,squeeze(D.(z)(48,index,:)),'.-','Color',[0.5 0.5 0.5]);
        legend([g,gg],{'first profile','last profile','1st ZM','intermediate profiles'});
    otherwise
        g(1)=plot(D.dist,squeeze(D.(z)(t_index(1),index,:)),'x-','Color',[0.4 0.4 0.4]);
        g(2)=plot(D.dist,squeeze(D.(z)(t_index(end),index,:)),'+-','Color',[0.2 0.2 0.2]);
        legend([g,gg],{'first profile','last profile','intermediate profiles'});
        
        if V.dist_on(index)>=D.dist(min(D.min_cross_shore_measurement(t_index,index)));
            %vline(D.dist(c(index)));
            %vline(V.dist_on(index),'-k');
            xl=get(gca,'XLim');
            %yl=get(gca,'YLim');
            patch([xl(1) V.dist_on(index) V.dist_on(index) xl(1)],[-12 -12 6 6],[0.5 0.5 0.5],'FaceAlpha',.5)
        end
end

xlabel('Cross-shore distance w.r.t. RSP [m]');
ylabel('Height w.r.t NAP [m]');
xl=get(gca,'XLim');
if max(xl)>3000;
    xlim([xl(1) 3000]);
end
ylim([-12 6]);
grid on

end
%EOF