function nemo_raw_plot_transect(R,index,t_index)
%NEMO_RAW_PLOT_TRANSECT Plots a single defined transect for the given surveys.
%
% During interpolation raw data 'attributed' to a transect can be stored in a
% struct: RAW. Raw data may contain more points, thus slopes could be better
% estimated.
% Plots one transect (index) for given suveys (t_index).
%
% Input: R raw datastruct
%        index alongshore index (transect)
%        t_indec time indices of surveys
%
% Output: figure
%
% Example:
%       nemo_plot_raw_transect(R,365,[1,7,17,37]);
%
%   See also: nemo, nemo_plot_transect

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

%figure;
hold on

for t=t_index
    h(t)=plot(R(t).line.CS(index).data.dist , R(t).line.CS(index).data.Z,'.-');
%    h(t)=plot(D.cross_shore,squeeze(D.(z)(t,index,:)),'.-');
    d{t}=datestr(R(t).time);
end

MHW=1.2; MSL=0; MLW=-1.2;
hline([MHW MSL MLW], {':k','--k',':k'});
hold on

%title(['Raw profiles of transect ',num2str(index,'%3.0f'),', ',num2str(D.alongshore(index)/1000,'%3.1f'),' km from HvH']);
title(['Raw profiles of transect ',num2str(index,'%3.0f'),', ',num2str(...
    sqrt((R(t).line.CS(index).x_origin-R(t).line.CS(1).x_origin).^2+(R(t).line.CS(index).y_origin-R(t).line.CS(1).y_origin).^2) ...
    ,'%3.1f'),' km from HvH']);
xlabel('distance from RSP [m]');
ylabel('height [m+NAP]');
legend(h(t_index),d{t_index},'Location','Best');