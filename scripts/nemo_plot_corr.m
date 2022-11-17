function nemo_plot_corr(D,Q,p1,p2,s,OPT)
%NEMO_PLOT_CORR Plots correlations between volume changes and hydrodynamics
%
%   Plots correlation coefficients in the alongshore domain between volume
%   changes net/gross and reduced hydrodynamic parameters.
%   Run nemo_corr_all first!
%
%   Syntax:
%       nemo_plot_corr(D,Q,p1,p2,s,OPT)
%
%   Input: 
%       D: Data struct
%       Q: Correlations struct from nemo_corr_all
%       p1: parameter1 name (str)
%       p2: parameter2 name (str)
%       s: filename
%       OPT: options structure
%
%   Output:
%   	figures of correlation coefficients
%
%   Example:
%      	nemo_plot_corr(D,Q,'Net volume change','RMS wave height','c_dvn_hrms',OPT)
%
%   See also: nemo, nemo_corr_all, nemo_plot_corr2

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
figure;
subplot(2,1,1);
plot(D.alongshore(1:length(Q.alongshore.rp)),Q.alongshore.rp,'.k'); %Plots r-p
hold on
%hh(2)=plot(D.alongshore(1:length(Q.alongshore.rp)),Q.alongshore.rs,'.k'); %Plots r-s
%plot(D.(dimension),Q.rs,'.k'); %Plots R^2
%hold on
grid on
if min(Q.alongshore.rp)<0
    ylim([-1 1]);
else
    ylim([0 1]);
end
xlim([0 17250]);
title(['Correlation of ',p1,' and ',p2]);
xlabel('Alongshore distance from HvH [m]');
ylabel('Coefficient of correlation: r');

%%
if OPT.print
    print2a4(['./figures/corr/',s,'.png'],'l','n','-r200','o');
end