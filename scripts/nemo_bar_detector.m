function [z_max, x_max, z_min, x_min]=nemo_bar_detector(z,x,mpp,figs)
%NEMO_BAR_DETECTOR Detects locations of local maxima (bars) and minima (troughs).
%
% Find locations of beach bars and troughs in a coastal profile. Uses findpeaks.
% It is required to set a 'minimum peak prominence' (mpp), 0.2m will do.
% Optionally outputs a figure.
%
% Input:
%   z: altitude (vector);
%   x: cross-shore distance (vector);
%   mpp: threshold prominence to detect (scalar).
%   figs: plot figure [true|false].
%
% Output:
%   z_max: altitude of bars.
%   x_max: distance of bars.
%   z_min: altitude of trough.
%   x_max: distance of trough.
%
% Syntax: 
%   [z_top,x_top, z_trough,x_trough]=nemo_bar_detector(transect_altitude,transect_distance,minimum_bar_height);
%
%   See also: nemo, findpeaks.

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
%find bars
[z_max, x_max]=findpeaks( z,x,'MinPeakProminence',mpp);
%find troughs (on flipped altitude)
[z_min, x_min]=findpeaks(-z,x,'MinPeakProminence',mpp);
z_min=-z_min;

if figs
    figure;
    h(1)=plot(x,z,'k');
    hold on
    grid on
    h(2)=plot(x_max,z_max,'*r');
    h(3)=plot(x_min,z_min,'+b');
    
    xlabel('Distance from RSP [m]');
    ylabel('Elevation w.r.t. NAP [m]');
    title(['Cross-shore profile with bars']);
    legend(h,{'profile','bar position','trough position'},'Location','NE')
end