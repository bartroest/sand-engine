function nemo_plot_wave_rose(D,t_index,WE,WZM,dirfld,hfld)
%NEMO_PLOT_WAVE_ROSE - Plots a wave rose for all time intervals
%
% Input D: datastruct
%       t_index: time indices for intervals to plot
%       WE: wavedata Europlatform
%       WZM: wavedata Zandmotor (buoy or transformation)
%       dirfld: 'dir' fieldname for wavedirection
%       hfld: 'hs' fieldname for wave height
%       locswitch: include|exclude ZM_BOEI
%
% Output: Figures
%
% See also: nemo, nemo_waves, nemo_wave_climate
%
% Bart Roest

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
if nargin <=2
    hfld = 'hs';
    dirfld = 'dir';
end

for t=1:length(t_index)-1;
    %% EURPFM
    figure;
    t_mask=WE.time>=D.time(t_index(t)) & WE.time<=D.time(t_index(t+1));
    if nargin>3
        %ax1=subplot(1,2,1);
        %ax=subplot_meshgrid(2,1,0,0,[0.5, 0.5],0.9);
        ax1=subplot('Position',[0 0 0.50 1]);
    end
    if sum(t_mask)>2;
    [~,~,ci]=wind_rose(WE.(dirfld)(t_mask),WE.(hfld)(t_mask),...
        'dtype',    'meteo',...
        'Ag',       [0:0.5:4],...
        'nAngles',  36,...
        'legStr',   'H_{s} [m]',...
        'units',    'm',...
        'titStr',   ['Europlatform'],...%, Data availability ',num2str(sum(~isnan(WE.d(t_mask)))/sum(t_mask)*100,'%3.0f'),'%'],...
        'quad',     4,...
        'coastline',311.3,...
        'percBg',   'none',...
        'parent',   ax1);%ax(1));
    else
        text(0,0.5,'No wave data in given interval');
    end
    %% ZM_BOEI
    if nargin>3
        %ax2=subplot(1,2,2);
        ax2=subplot('Position',[0.50 0 0.50 1]);
        t_mask=WZM.time>=D.time(t_index(t)) & WZM.time<=D.time(t_index(t+1));
        if sum(t_mask)>2;
            %wind_rose(WZM.Th0(t_mask),WZM.Hm0(t_mask)./100,...
            wind_rose(WZM.(dirfld)(t_mask),WZM.(hfld)(t_mask),...
                'dtype',    'meteo',...
                'Ag',       [0:0.5:4],...
                'nAngles',  36,...
                'legStr',   'H_{s} [m]',...
                'units',     'm',...
                'titStr',   ['Wave transformation Sand Engine'],...% Data availability ',num2str(sum(~isnan(WZM.phi(t_mask)))/sum(t_mask)*100,'%3.0f'),'%'],...
                'quad',     4,...
                'coastline',311.3,...
                'percBg',   'none',...                
                'parent',   ax2);%ax(2));
        else
            text(0,0.5,'No wave data in given interval');
            axis off;
        end
    end
    sgtitle(['Wave climate from ',datestr(D.time(t_index(t)),'dd-mmmm-yyyy'),' to ',datestr(D.time(t_index(t+1)),'dd-mmmm-yyyy'),' (',num2str(D.time(t_index(t+1))-D.time(t_index(t))),' days)']);
    %print2a4(['./figures/wave/annual/waveclimate_',datestr(D.time(t_index(t)),'yyyy-mm-dd'),'_',datestr(D.time(t_index(t+1)),'yyyy-mm-dd'),'.png'],'l','n','-r200','o');
    nemo_print2paper('waveclimate',[18 10]);
    close;
end
end