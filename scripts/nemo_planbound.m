function [xlims, ylims]=nemo_planbound(area,x,y)
% NEMO_PLANBOUND Sets limits to axes for the NeMo or SE area.
%
% Script to quickly set plot limits to Sand Engine or Nemo area.
% Limits are chosen arbitrarily, and can (should) be finetuned.
% Coordinates in RD (Rijksdriekhoeksstelsel).
%
% Input:
%   area: 'zm' (zandmotor) or 'nemo' (delfland).
%   x: [true|false] set xlim.
%   y: [true|false] set ylim.
%
% Output:
%   xlims: x-axis limits for current axes
%   ylims: y-axis limits for current axes
%
% See also: XLim, Ylim, ZLim, CLim, Axis.

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
switch lower(area);
    case {'zm','zandmotor','se','sandengine'}
        switch x
            case 0
                xlims=[];
            otherwise
                xlims=[70340,74700];
        end
        switch y
            case 0
                ylims=[];
            otherwise
                ylims=[450400,454900];
        end
%        xlims=[70340,74700];
%        ylims=[450400,454900];
    case {'nemo','dl','delfland','kustvak','wl','westland'}
        switch x
            case 0
                xlims=[];
            otherwise
                xlims=[65400,77640];
        end
        switch y
            case 0
                ylims=[];
            otherwise
                ylims=[444600,458000];
        end
        
%        xlims=[65900,77640];
%        ylims=[444900,458000];
    otherwise
        warning('area not declared/not available');
end
if x
    set(gca,'XLim',xlims);
end
if y
    set(gca,'YLim',ylims);
end

%bounds=[xlims,ylims];

% x_lim=[min(min(min(D.x)),min(min(E.x))),max(max(max(D.x)),max(max(D.x)))];
% y_lim=[min(min(min(D.y)),min(min(E.y))),max(max(max(D.y)),max(max(E.y)))];
% z_lim=[min(min(D.z(:)),min(E.z(:))),max(max(D.z(:)),max(E.z(:)))];