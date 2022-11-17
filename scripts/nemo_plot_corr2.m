function nemo_plot_corr2(D,Q,gn,func,param,fname);
%NEMO_PLOT_CORR2 Plots correlations between volume changes and hydrodynamics
%
%   Improved version of nemo_plot_corr
%   Plots correlation coefficients in the alongshore domain between volume
%   changes net/gross and reduced hydrodynamic parameters.
%   Run nemo_corr_all first!
%
%   Syntax:
%       nemo_plot_corr2(D,Q,gn,func,param,fname);
%
%   Input: 
%       D: Data struct
%       Q: Correlations struct from nemo_corr_all
%       gn: gross/net volume change ['g'|'n']
%       func: reduction function name ['min'|'max'|'rms'|'mean']
%       param: hydrodynamic parameter ['hm0'|'tp'|'power'|'gourlay'|...] 
%       fname: filename
%
%   Output:
%   	figures
%
%   Example:
%      	nemo_plot_corr2(D,Q,'g','rms','power','c_dvg_prms');
%
%   See also: nemo, nemo_corr_all, nemo_plot_corr

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
switch gn
    case 'g'
        tt='Gross volume change';
    case 'n'
        tt='Net volume change';
end

figure;
ax1=subplot(2,1,1);
plot(ax1,D.alongshore,Q.(['dv',gn,'1']).   (func).(param).alongshore.rp,'.-r');
hold on;
% plot(ax1,D.alongshore,Q.(['dv',gn,'100']). (func).(param).alongshore.rp,'x-k');
% plot(ax1,D.alongshore,Q.(['dv',gn,'200']). (func).(param).alongshore.rp,'v-m');
plot(ax1,D.alongshore,Q.(['dv',gn,'500']).(func).(param).alongshore.rp,'o-b');
% plot(ax1,D.alongshore,Q.(['dv',gn,'1000']).(func).(param).alongshore.rp,'s-c');
ylim([-1 1]);
xlabel('Alongshore');
ylabel('Correlation coefficient');
title([func,' of ',param,' and ',tt]);
legend(ax1,{'transect','500m window'},'Location','Best');

ax2=subplot(2,1,2);
plot(ax2,D.alongshore,Q.(['dv',gn,'1']).   (func).(param).alongshore.pp,'.-r');
hold on;
% plot(ax2,D.alongshore,Q.(['dv',gn,'100']).(func).(param).alongshore.pp,'x-k');
% plot(ax2,D.alongshore,Q.(['dv',gn,'200']).(func).(param).alongshore.pp,'v-m');
plot(ax2,D.alongshore,Q.(['dv',gn,'500']).(func).(param).alongshore.pp,'o-b');
% plot(ax2,D.alongshore,Q.(['dv',gn,'1000']).(func).(param).alongshore.pp,'s-c');
hline(0.05,'--k');
ylim([0 1]);
xlabel('Alongshore');
ylabel('Probability of non-correlation');

if nargin>3;
    print2a4(['./figures/newcorrs/',fname,'.png'],'l','n','-r200','o');
end

