function tr=nemo_altitude_trend(D,z);
%NEMO_ALTITUDE_TREND Calculates the linear trend of bed-level per point.
%
%   Calculates the linear trend of bed-elevation in m/year, per point. A minimum
%   of 5 surveys is required before the trend is calculated.
%
%   Syntax:
%       trend = nemo_altitude_trend(D,z)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%
%   Output:
%   	trend: bedlevel trend in m/year
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
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

mask=find(squeeze(sum(~isnan(D.(z)),1)>5));
tr=nan(size(D.x));
t=(D.time-D.time(1))./365.25;

for n=mask(:)';
    tmask=~isnan(D.(z)(:,n));
    temp=polyfit(t(tmask),squeeze(D.(z)(tmask,n)),1);
    tr(n)=temp(1);
end
end