function [c,l,Cval]=nemo_depth_contour_accurate(D,z,depth,t)
%NEMO_DEPTH_CONTOUR_ACCURATE Finds the most seaward position from RSP to the desired depth.
% Uses jarkus_distancetoZ
%
% Input:
%   D: datstruct
%   z: altitude fieldname [string]
%   d: altitude level [scalar]
%   t: time index [scalar]
% 
% Output:
%   c: cross-shore index
%   d: alongshore index
%   Cval: most seaward cross-shore distance to altitude.
%
% Syntax: [c,l,Cval]=nemo_depth_contour_accurate(D,z,depth,t);
%
%See also: nemo, jarkus_distancetoZ, nemo_depth_contour.
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

c1=nan(size(D.(z),2),1);
c=c1;
l=1:size(D.(z),2);
Cval=nan(size(D.(z),2),1);
%Lval=nan(size(D.(z),2),1);

for n=1:size(D.(z),2);
% % [~, i1]=find(D.(z)(t,n,:)>=depth,1,'last');
% % 
% %     if ~isempty(i1) && ~isnan(D.(z)(t,n,i1+1));
% %         c1(n)=i1; h1=squeeze(D.(z)(t,n,c1(n)));
% %         %c2(n)=i1+1; 
% %                     h2=squeeze(D.(z)(t,n,c1(n)+1));
% %         
% %         h=h1:-0.01:h2;
% %         x=linspace(0,5,length(h));
% %         
% %         [~, i]=find(h>=depth,1,'last');
% %         c(n)=c1(n)+(x(i)./5);
% %         Cval(n)=D.C(n,i1)+x(i);
% %         Lval(n)=D.L(n,i1);
% %         
% %     end
% % %z(n)=D.z(t,n,b(n));
temp=jarkus_distancetoZ(depth,squeeze(D.(z)(t,n,:)),D.dist);
Cval(n)=temp(end); %Most seaward point.
if ~isnan(Cval(n));
c(n)=find(D.dist>=Cval(n),1,'first');
end

end
