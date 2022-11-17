function nemo_plot_gaussfit(D,z,h,t)
%NEMO_PLOT_GAUSSFIT Plots Gaussian fit to depth contour
%
%   Syntax:
%       nemo_plot_gaussfit(D,z,h,t);
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       h: altitude/isobath to fit
%       t: time index to fit
%
%   Output:
%   	figure
%
%   Example:
%       nemo_plot_gaussfit(D,'altitude',0,7)
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
%[l,c]=nemo_depth_contour_lc(D,'altitude',h,t);
[l,c]=nemo_depth_contour_lc(D,z,h,t);

csoffset=780; %Difference between shorenormal (ls,cs) coordinates and RSP-line near the ZM.
%Alongshore indices: 266:473 = ZMplus area.
q=nemo_gaus_fit(D,l',c'-csoffset,266:473,1,1);
close;
set(gcf,'Position',[1 31 1920 973]);
ax=gca;
ax.XAxis.Exponent=3;
ax.YAxis.Exponent=3;
axis equal
ylim([-800 2500]);
title(['Fit on the ',num2str(h,'%+2.0f'),' m NAP depth contour of ',datestr(D.time(t),'mmm yyyy')]);
hold on;
hline(q.e,'--k');
arrow([q.b,0],[q.b,q.e]); %CS-offset
arrow([q.b,q.e],[q.b,q.e+q.a]); %Amplitude

arrow([q.b,-350],[q.b-q.c,-350]); %STD
arrow([q.b,-350],[q.b+q.c,-350]); %STD
arrow([q.b,-700],[q.b+2*sqrt(2)*q.c,-700]); %LS-extent
arrow([q.b,-700],[q.b-2*sqrt(2)*q.c,-700]); %LS-extent
arrow([min(xlim),500],[q.b,500]); %LS-pos
vline(q.b-2*sqrt(2)*q.c,'--k');
vline(q.b+2*sqrt(2)*q.c,'--k'); %2STD/LSX
vline(q.b-q.c,'--k'); %STD
vline(q.b+q.c,'--k'); %STD


text(q.b+50,-50,'Cross-shore off-set [d]');
text(q.b+50,400,'Amplitude [a]');
text(q.b-600,-225,'2\cdotStandard deviation [2c]');
text(q.b-2250,-550,['Alongshore extent [4',char(8730),'2\cdotc]']);
text(7000,750,'Alongshore position [b]');

xlabel('Alongshore position [m]');
ylabel('Cross-shore position [m]');

legend(['Depth contour ',num2str(h,'%+2.0f'),' m NAP'], 'Planform fit', 'Location', 'NorthEast' );

print2a4(['./figures/gaussfit/',num2str(h,'%2.0f'),'m/',datestr(D.time(t),'yyyy_mm_dd')],'l','n','-r200','o');
end
%EOF