function [lval,cval]=nemo_depth_contour_lc(D,z,depth,t)
%NEMO_DEPTH_CONTOUR_LC Finds the most seaward position of the desired depth on ls,cs grid.
% Uses jarkus_distancetoZ
%
% Input:
%   D: datstruct
%   z: altitude fieldname [string]
%   depth: altitude level [scalar]
%   t: time index [scalar]
% 
% Output:
%   lval: alongshore coordinate [m RD]
%   cval: cross-shore coordinace [m RD]
%
% Syntax: [xval,yval]=nemo_depth_contour_lc(D,'altitude',0,t_idx)
%
% See also: nemo, jarkus_distancetoZ, nemo_depth_contour.
%

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


lval=nan(size(D.(z),2),1);
cval=nan(size(D.(z),2),1);

for n=1:size(D.(z),2);
    
    ltemp=jarkus_distancetoZ(depth,squeeze(D.(z)(t,n,:)),D.ls(n,:));
    lval(n)=ltemp(end);
    
    ctemp=jarkus_distancetoZ(depth,squeeze(D.(z)(t,n,:)),D.cs(n,:));
    cval(n)=ctemp(end);
    
end
