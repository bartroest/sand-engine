function nemo_plot_profile_std(D,z,index,t_index,threshold,minnop);
%NEMO_PLOT_PROFILE_STD Plots profiles with standard deviation.
%
%   Plots all surveys of a transect and calculates the standard deviation of the
%   bed level, shown too.
%
%   Syntax:
%       nemo_plot_profile_std(D,z,index,t_index,threshold,minnop);
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       index: alongshore indices to plot
%       t_index: time indices to plot and calculate std for
%       treshold: std treshold for bedlevel activity (ca. 0.20 m)
%       minnop: minimum number of points for reliable standard deviation (5)
%
%   Output:
%       figures
%
%   Example:
%       nemo_plot_profile_std(D,'altitude',365,Time.all,0.20,5);
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
%figure;

for n=index;
    mask=sum(~isnan(squeeze(D.(z)(t_index,n,:))),1)>=minnop; %Point with minimum number of observations
    zmean=squeeze(nanmean(D.(z)(t_index,n,mask))); %Mean altitude
    stdz=squeeze(nanstd(D.(z)(t_index,n,mask))); %Std of altitude
    
    if any(mask)
        subplot(3,1,1:2);
            cla;
            h=plot(D.cs(n,:),squeeze(D.(z)(t_index,n,:)),'.-','Color',[0.7 0.7 0.7]);
            hold on;
            hm=plot(D.cs(n,mask),zmean,'.-k');

            xlim([0 max([D.cs(n,mask),2500])]);
            ylim([-10 5]);

            xlabel('Cross-shore distance [m]');
            ylabel('Altitude [m NAP]');
            title(['Transect ',num2str(n)]);
            legend([h(1),hm],{'Profiles','Mean altitude'});

        subplot(3,1,3);
            cla;
            plot(D.cs(n,mask),stdz,'.-k');
            hold on;
            plot(D.cs(n,mask),smooth1_nan(stdz,5),'.-r');
            plot([0 2500],[threshold threshold],'-k');

            xlim([0 max([D.cs(n,mask),2500])]);
            ylim([0 1]);

            xlabel('Cross-shore distance [m]');
            ylabel('Standard deviation of altitude [m]');

        %print
        pause;
    end
end