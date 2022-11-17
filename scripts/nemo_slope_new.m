function S=nemo_slope_new(D,z,h1,h2,t_index)%[sl,dist1,dist2]=nemo_slope_new(D,z,h1,h2,t_index)
%nemo_slope_new Determines the slope between two altitudes by linear fitting.
%
% The average cross-shore slope is determined by linear fitting the points
% bounded between two altitudes h1 and h2. Most seaward crossings are taken as
% boundaries.
%
% Input:
%   D: datastruct
%   z: altitude field name
%   h1: upper altitude boundary
%   h2: lower altitude boundary
%   t_index: time indices to perform the analysis
%
% Output:
%   S: struct with fields:
%       sl: slope in radians [m/m]
%       x1: onshore boundary distance [m RSP]
%       x2: offshore boundary distance [m RSP]
%       dhdx: fallback slope: (h1-h2)/(x2-x1)
%
% Example:
%   S = nemo_slope_new(D,'altitude',0,-2,1:37));
%
%   See also: nemo, nemo_slope

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
if h2>=h1
    warning('h2 must be lower than h1')
    return
end

dist1=nan(length(D.time),length(D.alongshore));
dist2=nan(length(D.time),length(D.alongshore));
sl=nan(length(D.time),length(D.alongshore));

%Determine CS positions of crossings with altitude
for t=t_index; 
    for i=1:length(D.alongshore); 
        cr1=jarkus_findCrossings(D.dist,squeeze(D.(z)(t,i,:)),[D.dist(1) D.dist(end)],[h1 h1]);
        cr2=jarkus_findCrossings(D.dist,squeeze(D.(z)(t,i,:)),[D.dist(1) D.dist(end)],[h2 h2]);
        if ~isempty(cr1); 
            dist1(t,i)=cr1(end);
        end;
        if ~isempty(cr2);
            dist2(t,i)=cr2(end);
        end
        % If crossings are found, select prfile between crossings.
        if ~isnan(dist1(t,i)) && ~isnan(dist2(t,i));
            mask=D.dist>=dist1(t,i) & D.dist<=dist2(t,i);
        elseif ~isnan(dist1(t,i));
            mask=D.dist>=dist1(t,i) & squeeze(D.altitude(t,i,:))<=h1 & squeeze(D.altitude(t,i,:))>=h2;
        else
            continue
        end
        % Linear fit profile selection
        a=polyfit(D.dist(mask),squeeze(D.(z)(t,i,mask)),1); 
        if ~isempty(a); 
            sl(t,i)=a(1); 
        end
    end
end
S.sl=sl;
S.x1=dist1;
S.x2=dist2;
S.dhdx=(h2-h1)./(dist2-dist1);
end