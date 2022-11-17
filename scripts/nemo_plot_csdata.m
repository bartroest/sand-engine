function T=nemo_plot_csdata(D);
%NEMO_PLOT_CSDATA Plots a stack of the minimum and maximum CS-position with data.
%
% Visualisations of cross-shore data reach.
%
% see also: nemo

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

for i_date=1:length(D.time)
    for i_l=1:length(D.alongshore)
        ind=find(~isnan(D.altitude(i_date,i_l,:)));
        if length(ind)>=1
          T.min_cross_shore_measurement(i_date,i_l)=D.dist(ind(1));
          T.max_cross_shore_measurement(i_date,i_l)=D.dist(ind(end));
        else
          T.min_cross_shore_measurement(i_date,i_l)=nan ;
          T.max_cross_shore_measurement(i_date,i_l)=nan ;
        end
    end
end

figure; pcolor(T.min_cross_shore_measurement); shading flat;
figure; pcolor(T.max_cross_shore_measurement); shading flat;
figure; pcolor(T.max_cross_shore_measurement-T.min_cross_shore_measurement); shading flat;
end