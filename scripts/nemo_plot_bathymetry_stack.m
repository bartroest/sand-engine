function nemo_plot_bathymetry_stack(D,z,index,t_index)
%nemo_plot_bathymetry_stack Plots figure with grid of bathymetries.
%
%   Syntax:
%   trend = nemo_altitude_trend(D,z,index,t_index)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       index: alongshore indices
%       t_index: time indices
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_bathymetry_stack(D,'altitude',Index.zm,Time.july)
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

figure;
% ax1=axes('Position',[0,0,1,1]);
% ylabel('Cross-shore distance from RSP [m]');
% title('Bathymetry');
T=length(t_index);
for t=1:T;
    if t<=ceil(T/2) && T>16
        ax(t)=axes('Position',[0.07, 0.05+(t-1)/(ceil(T/2)/0.95), 0.42, 1/(ceil(T/2)/0.95)]);
    elseif t>ceil(T/2) && T>16
        ax(t)=axes('Position',[0.52, 0.05+(t-1-(ceil(T/2)))/(ceil(T/2)/0.95), 0.42, 1/(ceil(T/2)/0.95)]);
    else
        ax(t)=axes('Position',[0.07, 0.05+(t-1)/(T/0.95), 0.85, 1/(T/0.95)]);
    end
    %set(ax(t),'XAxis','Visible','off')
    
    pcolor(ax(t),D.L,D.C,squeeze(D.(z)(t_index(t),index,:)));
    shading flat;
    grid on;
    axis equal;
    xlim([0 17500]);
    ylim([-250  2250]);
    clim([-12 7]);
    hold on;
    nemo_northarrow('auto');
    text(13000,1800,[datestr(D.time(t_index(t)),'dd mmm yyyy')]);
    ax(t).XAxis.TickValues=0:1000:17500;
    if t==1;
        ax(t).XAxis.TickLabels=0:1:17;
        xlabel('Distance from HvH [km]');
    elseif t==ceil(T/2)+1 && T>16;
        ax(t).XAxis.TickLabels=0:1:17;
        xlabel('Distance from HvH [km]');
    else
        ax(t).XAxis.TickLabels=[];
    end

end
axes(ax(floor(T/2)));
ylabel('Distance from RSP [m]');
colormap(zmcmap);
cba=axes('Position',[0.92 0.12 0.05 0.60]);
cb=colorbar(cba,'Location','West');
clim([-12 7]);
cba.Visible='off';
cb.Label.String='Altitude [m+NAP]';
%suptitle('Bathymetries for all surveys');
end
%EOF