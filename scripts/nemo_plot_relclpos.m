function [cspos,relpos,smpos]=nemo_plot_relclpos(D,Time,relsurv,depth)
%nemo_plot_relclpos Plots depth contour positions relative to a certain survey
%
%   Syntax:
%       [cspos,clpos,smpos]=nemo_plot_relclpos(D,Time,relsurv,depth)
%
%   Input: 
%       D: Data struct
%       Time: time indices struct
%       relsurv: reference survey for isobath positions
%       depth: isobath to calculate
%
%   Output:
%   	figure
%       cspos: absolute cross-shore postions
%       relpos: relative cross-shore postions
%       smpos: smoothed relative cross-shore positions
%
%   Example:
%       [cspos,clpos,smpos]=nemo_plot_relclpos(D,Time,relsurv,depth)
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
cspos=nan(length(D.time),length(D.alongshore));
relpos=cspos;
smpos=cspos;

for t=Time.all; [~,~,cspos(t,:)]=nemo_depth_contour_accurate(D,'altitude',depth,t); end
for t=Time.all; relpos(t,:)=cspos(t,:)-cspos(relsurv,:); end
for t=Time.all; smpos(t,:)=smooth1_nan(relpos(t,:),7); end

%%
figure; pcolor(D.alongshore,D.time(Time.all),relpos(Time.all,:)); 
shading flat
csym; colormap(jwb(100,0.01));

datetickzoom('y','mm-''yy','keeplimits');
title(['Relative coastline position (0m+NAP) w.r.t. Survey ',num2str(relsurv)]);
xlabel('Alongshore position from HvH [m]');
ylabel('Time');
colorbar

%print2a4('./figures/stacks/relclpos','l','n','-r200','o');

%%
figure; pcolor(D.alongshore,D.time(Time.all),smpos(Time.all,:)); 
shading flat
csym; colormap(jwb(100,0.01));

datetickzoom('y','mm-''yy','keeplimits');
title(['Smoothed relative coastline position (0m+NAP) w.r.t. Survey ',num2str(relsurv)]);
xlabel('Alongshore position from HvH [m]');
ylabel('Time');
colorbar

%print2a4('./figures/stacks/relsmpos','l','n','-r200','o');