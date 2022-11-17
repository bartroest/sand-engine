function nemo_animate_transect(D,z,index,t_index)
%NEMO_ANIMATE_TRANSECT Shows a cycle of all consecutive surveys for 1 transect.
%
%   Syntax:
%   trend = nemo_altitude_trend(D,z,index,t_index)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       index: transect index number [scalar]
%       t_index: time-indexes to plot [vector].
%
%   Output:
%   	figure
%
%   Example
%   nemo_animate_transect(D,'altitude',365,1:37)
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
figure;
hold on
n=0;
for t=t_index;
   f=0.9-(n/(length(t_index))*0.9);
plot(D.dist,squeeze(D.(z)(t,index,:)),'.-','Color',f*[1 1 1]);
n=n+1;
end
hold on

for t=t_index;
   h=plot(D.dist,squeeze(D.(z)(t,index,:)),'.-r');
   pause
   delete(h);
end