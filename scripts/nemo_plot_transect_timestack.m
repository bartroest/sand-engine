function nemo_plot_transect_timestack(D,z,index,t_index,subswitch,barswitch)
%NEMO_PLOT_TRANSECT_TIMESTACK Plots a timestack of a single transect(-parameter)
%
% Creates a plot of a time x cross-shore matrix in the form of a time-stack.
%
% Syntax:
%   nemo_plot_transect_timestack(D,z,index,t_index,subswitch,barswitch)
%
% Input:
%   D: Datastruct
%   z: fieldname OR matrix(t,cs)
%   index: alongshore index (n)
%   t_index: time indices (range)
%   subswitch: include profile sub-plot [true|false]
%   barswitch: detect bar positions [true|false]
%
% Output: figure
%
% Example:
%   nemo_plot_transect_timestack(D,'altitude',365,1:37,1,1)
%
% See also: nemo, findpeaks

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

figure;
if D.time(1)<datenum(1970,1,1);
    jarkus=1;
else
    jarkus=0;
end

if subswitch
    ax1=subplot(3,1,1);
    plot(D.dist,squeeze(D.(z)(t_index(2:end-1),index,:)),'.-','Color',[0.7 0.7 0.7]);
    hold on
    ax1.ColorOrderIndex=1;
    handle=plot(D.dist,squeeze(D.(z)(t_index([1 end]),index,:)),'.-');
    hline(0,'--k')
    xlim([D.dist(min(D.min_cross_shore_measurement(t_index,index))),D.dist(max(D.max_cross_shore_measurement(t_index,index)))]);
    ylabel('Altitude [m+NAP]');
    xlabel('Cross shrore distance from RSP [m]')
    if jarkus
    legend(handle,datestr(D.time(t_index(1))+datenum(1970,1,1),'mmm-yyyy'),datestr(D.time(t_index(end))+datenum(1970,1,1),'mmm-yyyy'));
    else
    legend(handle,datestr(D.time(t_index(1)),'mmm-yyyy'),datestr(D.time(t_index(end)),'mmm-yyyy'));
    end
    ax2=subplot(3,1,[2 3]);
    colorbar;
    linkaxes([ax1,ax2],'x');
end

if ischar(z)
    if jarkus
    pcolorcorcen([D.dist; nan],[D.time(t_index); D.time(t_index(end))+30]+datenum(1970,1,1),squeeze(D.(z)(t_index,index,:)));
    else
    pcolorcorcen([D.dist; nan],[D.time(t_index); D.time(t_index(end))+30],squeeze(D.(z)(t_index,index,:)));
    end
    %pcolor([D.dist],[D.time(t_index)],squeeze(D.(z)(t_index,index,:)));
    if barswitch;
        for t=t_index; 
            [~,x]=nemo_bar_detector(squeeze(D.altitude(t,index,:)),D.dist,0.2,0);
            hold on;
            if ~isempty(x);
                plot(x,D.time(t),'r*');
            end
        end
    end
else
    pcolor(D.dist,D.time(t_index),z(t_index,:));
end
shading flat
xlim([D.dist(min(D.min_cross_shore_measurement(t_index,index))),D.dist(max(D.max_cross_shore_measurement(t_index,index)))]);

if jarkus
title(['Timestack of bathymetry of transect ',num2str(index,'%3.0f'),', ',num2str(D.alongshore1(index)/1000,'%3.1f'),'km from HvH']);
else
title(['Timestack of bathymetry of transect ',num2str(index,'%3.0f'),', ',num2str(D.alongshore(index)/1000,'%3.1f'),'km from HvH']);
end
xlabel('Distance from RSP [m]');
datetick('y','mmm-yy','keeplimits');
ylabel('Time [year]');
%EOF