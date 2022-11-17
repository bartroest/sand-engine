function [Stats]=nemo_stats(D,z,threshold,index,t_index)
%NEMO_STATS Calculates various statistics of a (t,x,y)-array over t.
% Calculates: mean, std, var, median, iqr and nuber of non-nan-values.
%
% Input: 
%   D: datastruct
%   z: fieldname
%   threshold: minimum number of non-nans
%   index: alongshore-indices
%   t_index: time-indices
%
% Syntax: Stat_struct=nemo_stats(Datastruct,'altitude',thresh_val,index_alongsh,time_index);
%
% See also: nemo, nemo_plot_stats
%
% Bart Roest, 2016

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

Stats.nnanz=    squeeze(sum(~isnan(D.(z)(t_index,index,:)),1));         %Number of non-NaN values per point
mask=Stats.nnanz>=threshold;

Stats.meanz   = nan(size(Stats.nnanz));
Stats.stdz    = nan(size(Stats.nnanz));
Stats.varz    = nan(size(Stats.nnanz));
Stats.medianz = nan(size(Stats.nnanz));
Stats.iqrz    = nan(size(Stats.nnanz));

Stats.meanz(mask)  = squeeze(mean(   D.(z)(t_index,mask),  1,'omitnan')); %Mean, omitting NaN's
Stats.stdz(mask)   = squeeze(std(    D.(z)(t_index,mask),0,1,'omitnan')); %Standard deviation, omitting NaN's
Stats.varz(mask)   = squeeze(var(    D.(z)(t_index,mask),0,1,'omitnan')); %Variance, omitting NaN's
Stats.medianz(mask)= squeeze(median( D.(z)(t_index,mask),  1,'omitnan')); %Median, omitting NaN's
Stats.iqrz(mask)   = squeeze(iqr(    D.(z)(t_index,mask),  1          )); %Inter quartile range

end
%EOF