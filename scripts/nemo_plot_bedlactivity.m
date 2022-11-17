%nemo_plot_bedlactivity Plots the scaled variance of bedlevel change.
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
%%
blch=nan(size(D.z_jnz));
figure; hold on;

blch(Time.jarkus(1:end-1),Index.jarkus,:)=diff(D.z_jnz(Time.jarkus,Index.jarkus,:),1);
pcolor(D.ls(Index.jarkus,:),D.cs(Index.jarkus,:),squeeze(nansum(abs(blch(:,Index.jarkus,:)),1))./squeeze(nansum(~isnan(blch(:,Index.jarkus,:)),1))); 
shading flat;

blch(Time.nemo(1:end-1)  ,Index.nemo,:)  =diff(D.z_jnz(Time.nemo,  Index.nemo,:)  ,1);
pcolor(D.ls,D.cs,squeeze(nansum(abs(blch),1))./squeeze(nansum(~isnan(blch),1))); 
shading flat;

blch(Time.vbnemo(1:end-1),Index.vb,:)    =diff(D.z_jnz(Time.vbnemo,Index.vb,:)    ,1);
pcolor(D.ls,D.cs,squeeze(nansum(abs(blch),1))./squeeze(nansum(~isnan(blch),1))); 
shading flat;

blch(Time.zmplus(1:end-1),Index.zmplus,:)=diff(D.z_jnz(Time.zmplus,Index.zmplus,:),1);
pcolor(D.ls,D.cs,squeeze(nansum(abs(blch),1))./squeeze(nansum(~isnan(blch),1))); 
shading flat;

blch(Time.all(1:end-1)   ,Index.zm,:)    =diff(D.z_jnz(Time.all,   Index.zm,:)    ,1);
pcolor(D.ls,D.cs,squeeze(nansum(abs(blch),1))./squeeze(nansum(~isnan(blch),1))); 
shading flat;

title('Cumulative absolute bedlevel change (Activity) scaled by #surveys [m/survey]');
xlabel('Distance from HvH [m]');
ylabel('Distance form RSP [m]');

colorbarwithtitle('Cummulative absolute bedlevel change [m/survey]','SouthOutside');
clim([0 0.6])
colormap(hot);

axis equal;
xlim([-200 17200]);
%ylim([-200 2000]);
ylim([100 2600]);
