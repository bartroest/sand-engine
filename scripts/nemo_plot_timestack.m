function nemo_plot_timestack(D,stack,index,t_index,s)
%NEMO_PLOT_TIMESTACK - Plots an arbitrary timestack
%
% Input: D: Datastruct
%        stack: The timestack matrix [alongsh time]
%        index: Alongshore indices
%        t_index: time indices
%        s: title string
%
% Output: Plot with timestack
%
% See also: nemo

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
figure; 
pcolor(D.alongshore(index),D.time(t_index),stack(t_index,index));
shading flat

vline(D.alongshore([304 428]),'--k');
if nargin<5;
    s=input('title: ','s');
end
title(s);
xlabel('Alongshore distance from HvH [m]');
ylabel('Time');
datetickzoom('y','mmm-yyyy');

print2a4(['./figures/stacks/',s],'l','n','-r200','o');
end
%EOF