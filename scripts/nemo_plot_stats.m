function nemo_plot_stats(D,ST,statvar,threshold)
%NEMO_PLOT_STATS Plots the desired statistical value of the depth array.
%
% Syntax:
%   nemo_plot_stats(Datastruct,STatistical_datastruct,'statistical_entry',...
%               treshold for the number of data in points);
%
%   Input: 
%       D: Data struct
%       ST: statistics struct from nemo_stats
%       statvar: fieldname of ST to plot
%       threshold: minimum number of observations to plot a point
%
%   Output:
%   	figure
%
%   Example:
%       ST=nemo_stats(D,'altitude',5,1:644,1:37);
%       nemo_plot_stats(D,ST,'mean');
%
%   See also: nemo, nemo_stats

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

if nargin<4;%isempty(threshold);
    threshold=0;
end
%mask=true(size(ST.(stats)));
mask=ST.nnanz>threshold;
c=nan(size(ST.(statvar)));
c(mask)=ST.(statvar)(mask);

%% PColor figure
figure; 
hold on;
pcolor(D.L,D.C,c); shading flat; axis equal;
colorbar;
xlabel('Alongshore distance from HvH [m]');
ylabel('Cross-shore distance from RSP [m]');
title([statvar(1:end-1),' of altitude measurements']);

% %% Scatter figure
% %figure;
% %scatter(D.L(~isnan(ST.(stats))),D.C(~isnan(ST.(stats))),10,ST.(stats)(~isnan(ST.(stats))),'filled');
% figure;
% scatter(D.L(ST.nnanz>threshold),D.C(ST.nnanz>threshold),10,ST.(statvar)(ST.nnanz>threshold),'filled');
% axis equal;
% colorbar;
% 
% xlabel('Alongshore distance from HvH [m]');
% ylabel('Cross-shore distance from RSP [m]');
% title([statvar(1:end-1),' of altitude measurements']);
end
%EOF