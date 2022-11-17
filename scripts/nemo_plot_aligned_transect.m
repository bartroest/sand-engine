function deltadist=nemo_plot_aligned_transect(D,z,index,t_index,h)
%NEMO_PLOT_ALIGNED_TRANSECT plots all surveys at transect aligned at arbitrary altitude.
%
%   Plots surveyed profiles of 1 transect, but shifted cross-shore to be aligned
%   at altitude of h m+NAP. Profiles referenced to t_index(1).
%
%   Syntax:
%       dx = nemo_plot_aligned_transect(D,z,index,t_index,h)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       index: alongshore index of transect
%       t_index: time index of surveys
%       h: altitude to align profiles.
%
%   Output:
%   	deltadist: cross-shore shift.
%
%   Example:
%       dx = nemo_plot_aligned_transect(D,'altitude',365,1:17,1.5)
%
%   See also: nemo, jarkus_align_at_contour

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

for t=1:length(t_index);
    deltadist(t)=jarkus_align_at_contour(D.dist,squeeze(D.(z)(t_index(1),index,:)),D.dist,squeeze(D.(z)(t_index(t),index,:)),'contour',h,'index','last');
    dist(t,:)=D.dist-deltadist(t);
end

figure;
hh(1)=plot(D.dist,squeeze(D.(z)(t_index(1),index,:)),'.-k');
ltxt{1}=num2str(t_index(1));
hold on

for t=2:length(t_index);
    hh(t)=plot(dist(t,:),squeeze(D.(z)(t_index(t),index,:)),'.-');
    ltxt{t}=num2str(t_index(t));
end
   
hline(h,'-k');
xlabel('Distance from RSP profile 1 [m]');
ylabel('Height w.r.t. NAP [m]');
title(['Aligned profiles transect ',num2str(index)]);
%legend(hh,cellstr(num2str(t_index)));
legend(hh,ltxt);