function [zfirst, zlast]=nemo_bathyfila(D,z,t_end)
%NEMO_BATHYFILA Determines the first and last available altitude at a position.
%
%   Quick and dirty script to provide a map with the oldest and latest measured
%   points at a location; the first and last survey results.
%
%   Syntax:
%   [zfirst, zlast] = nemo_bathyfila(D,z,t_end)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       t_end: latest survey to take into account.
%
%   Output:
%   	zfirst: altitude at the first time a point was surveyed
%   	zlast:  altitude at the last  time a point was surveyed
%
%   Example
%   [zfirst, zlast]=nemo_bathyfila(D,'altitude',37)
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
zlast=nan(size(D.(z),2),size(D.(z),3));
zfirst=zlast;
%for t=[7,17:1:t_end];%t=1:length(D.time);
for t=1:1:t_end;
    mask=~isnan(squeeze(D.(z)(t,:,:)));
    zlast(mask)=squeeze(D.(z)(t,mask));
end

%for t=length(D.time):-1:1;
for t=t_end:-1:1;
    mask=~isnan(squeeze(D.(z)(t,:,:)));
    zfirst(mask)=squeeze(D.(z)(t,mask));
end
end