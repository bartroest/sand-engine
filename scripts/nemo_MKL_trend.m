function MKL_trend=nemo_MKL_trend(D,MKL)
%nemo_MKL_trend Calculates the trend based on calculated MKL's in m/year.
%
%   Calculates the linear trend of MKL positions per transect.
%
%   Syntax:
%   MKL_trend = nemo_altitude_trend(D,xMKL)
%
%   Input: 
%       D: Data struct
%       xMKL: MKL positions
%
%   Output:
%   	MKL_trend: MKL position trend in m/year
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
%
%   See also: nemo, jarkus_getMKL, nemo_MKL

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

MKL_trend=nan(size(D.alongshore));

for n=1:size(MKL,2);
    mask=~isnan(MKL(:,n));
    if sum(mask) > 3;
        p=polyfit(D.time(mask),MKL(mask,n),1);
        MKL_trend(n)=p(1)*365;
    end
end
end
%EOF
