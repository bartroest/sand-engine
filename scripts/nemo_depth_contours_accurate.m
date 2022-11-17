function [Cval_1,Cval_2,c1,c2]=nemo_depth_contours_accurate(D,z,depth1,depth2,t)
%NEMO_DEPTH_CONTOURS_ACCURATE Finds most seaward position of depth1 and first position of depth2 following depth1.
%Uses jarkus_distancetoZ
%Looks from RSP offshore.
%
% Cval_n = CS-distance
% cn = CS-index from D.dist
%
%See also: nemo, nemo_depth_contour_accurate, nemo_depth_contour, jarkus_distancetoZ.

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

%c1=375.*ones(size(D.(z),2),1);
c1=nan(size(D.(z),2),1);
c2=c1;
%c_1=c1;
%c_2=c1;
%l=1:size(D.(z),2);
Cval_1=nan(size(D.(z),2),1);
Cval_2=nan(size(D.(z),2),1);
%Lval=nan(size(D.(z),2),1);

for n=1:size(D.(z),2);
% % [~, i1]=find(D.(z)(t,n,:)>=depth1,1,'last'); %Find last index still larger than depth1.
% % 
% %     if ~isempty(i1) && ~isnan(D.(z)(t,n,i1+1));
% %         c1(n)=i1; h1=squeeze(D.(z)(t,n,c1(n))); %Depth at point
% %         %c2(n)=i1+1; 
% %                     h2=squeeze(D.(z)(t,n,c1(n)+1)); %Depth at point+1
% %         
% %         h=h1:-0.01:h2; %Interpolate depth
% %         x=linspace(0,5,length(h)); %Interpolate distance between points
% %         
% %         [~, i]=find(h>=depth1,1,'last'); %Find last index still larger than depth1.
% %         c_1(n)=c1(n)+(x(i)./5);
% %         Cval_1(n)=D.C(n,i1)+x(i);
% %         Lval(n)=D.L(n,i1);
% %         
% %         %% Find Second depth // First instance after c(depth1)
% %         [~, i3]=find(D.(z)(t,n,i1:end)<=depth2,1,'first'); %Find last index still smaller than depth2.
% %         i2=i1+i3-1;
% %         if ~isempty(i3) && ~isnan(D.(z)(t,n,i2)) && ~isnan(D.(z)(t,n,i2-1));
% %             c2(n)=i2; h1=squeeze(D.(z)(t,n,c2(n))); %Depth at point
% %                       h2=squeeze(D.(z)(t,n,c2(n)-1)); %Depth at point-1
% %             h=h2:-0.01:h1; 
% %             x=linspace(0,5,length(h)); %Interpolate distance between points
% %             [~, i]=find(h>=depth2,1,'last');
% %             %c_2(n)=c2(n)+(x(i)./5);
% %             Cval_2(n)=D.C(n,i2)+x(i);
% %         end
% %     end
% % %z(n)=D.z(t,n,b(n));

temp=jarkus_distancetoZ(depth1,squeeze(D.(z)(t,n,:)),D.dist);
Cval_1(n)=temp(end);
if ~isnan(Cval_1(n));
c1(n)=find(D.dist>=Cval_1(n),1,'first');

temp=jarkus_distancetoZ(depth2,squeeze(D.(z)(t,n,c1(n):end)),D.dist(c1(n):end));
Cval_2(n)=temp(1);
if ~isnan(Cval_2(n));
c2(n)=find(D.dist>=Cval_2(n),1,'first');
end
end


end