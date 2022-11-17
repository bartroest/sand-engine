function [meandz, meanabsdz]=nemo_altitude_change_distribution(D,h_down,h_up,dh,index,t_index,calc,figswitch)
%NEMO_ALTITUDE_CHANGE_DISTRIBUTION Calculates average bedlevel change for several altitudes in the coastal profile.
%
%   For every point in an altitude bin (eg. between 0 and 0.5 m NAP) the average
%   change in bedlevel is calculated. This provides insight at which elevations
%   the bed is eroding or accreting. Classification based on the survey t(n-1),
%   changes calculated as z(t)-z(t-1).
%   The optional plot shows this distribution over the vertical for all
%   timesteps.
%
%   Syntax:
%   [meandz, meanabsdz]=nemo_altitude_change_distribution(D,h_down,h_up,dh,index,t_index,calc,figswitch)
%
%   Input: 
%       D: Data struct
%       h_down: lower limit to take into account for bins [m] (scalar)
%       h_ip: upper limit to take into account for bins [m] (scalar)
%       dh: binsize [m] (scalar)
%       index: alongshore indices for calculation (vector)
%       t_index: time indices for calculation (vector)
%       calc: 'mean' average change per bin.
%             'std' standard deviation per bin.
%       figswitch: plot results [true|false]
%
%   Output:
%   	meandz: average bedlevel change per bin. [t n]
%       meanabsdz: absolute bedlevel change per bin [t n]
%
%   Example:
%       [meandz,meanabsdz]=nemo_altitude_change_distribution(D,-10,5,0.5,360:370,1:37,'mean',true);
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

z=D.altitude(t_index,index,:); z=z(:,:);
dz=diff(z); 
z=z(1:end-1,:);

ll=h_down:dh:h_up;
ul=ll+dh;

meandz=nan(length(t_index),length(ll));
meanabsdz=meandz;

for t=1:length(t_index)-1; 
    for h=1:length(ll); 
        mask=z(t,:)>=ll(h) & z(t,:)<ul(h); 
        switch calc
            case 'mean'
                meandz(t,h)=mean(dz(t,mask),2,'omitnan'); 
                meanabsdz(t,h)=mean(abs(dz(t,mask)),2,'omitnan');
            case 'std'
                meandz(t,h)=std(dz(t,mask),0,2,'omitnan'); 
                meanabsdz(t,h)=std(abs(dz(t,mask)),0,2,'omitnan');
        end
        %nop(t,h)=sum(mask); 
    end
end

if figswitch
    figure;
    pcolor(D.time(t_index),ll+0.5*dh,meandz');
    colormap(jwb(100,0));
    csym;
    datetick('x','mmm-''yy');
    ylabel('Altitude [m+NAP]');
    xlabel('Time');
    title(['Mean altitude difference (t_{n}-t_{n-1}) at previous altitude (t_{n-1}); transects ',num2str(index(1),'%3.0f'),'-',num2str(index(end),'%3.0f')]);
    %title(['Mean altitude difference (',num2str(t_index(end)),'-',num2str(t_index(1)),') at previous altitude; transects ',num2str(index(1),'%3.0f'),'-',num2str(index(end),'%3.0f')]);
    colorbar;
end