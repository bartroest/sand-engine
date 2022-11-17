function x=nemo_zm_retreat(D,z,Z,index,t_index)
%nemo_zm_retreat Shows and calculates the cross shore extent of a transect at a certain height.
%
%   Calculates the linear trend of bed-elevation in m/year, per point. A minimum
%   of 5 surveys is required before the trend is calculated.
%
%   Syntax:
%   dxdt = nemo_zm_retreat(D,z)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       Z: altitude to evaluate [m NAP]
%       index: transect index number
%       t_index: time indexes for evaluation
%
%   Output:
%   	x: cross-shore position in [m RSP].
%
%   Example
%   cs = nemo_altitude_trend(D,'altitude',0,365,1:37);
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
k=1:length(index);
for t=t_index;
    for k=1:length(index);%n=index;
        d=jarkus_distancetoZ(Z,squeeze(D.(z)(t,index(k),:)),D.dist);
        x(t,k)=d(end);
    end
end
dx=diff(x,1,1);

figure;

for k=1:length(index);
    h(k)=plot(D.time(t_index),x(t_index,k),'.-');
    hold on;
    legentry{k}=['transect ',num2str(index(k),'%3.0f')];
end
%
%vline([D.time(22),D.time(32)]);

title(['Cross shore position of the ',num2str(Z,'%3.1f') ,' m depth contour [m]']);
xlabel('Time');
ylabel('Cross-shore position w.r.t. RSP [m]');

legend(h,legentry);
datetick('x','mmm-yyyy');