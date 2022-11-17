function [R,a,b]=nemo_correlate_profiles(D,z,t1,t2,i1,i2,varargin)
%NEMO_CORRELATE_PROFILES Correlates two profiles, and return paramters.
% Linearly correlates the altitudes of two transects for the given indices.
% The optional plot shows the deviation from a 1:1 relation.
%
% Input: D data-struct
%        z altitude field ['altitude','z_jnz']
%        t1 time_index profile 1
%        t2 time_index profile 2
%        i1 alongshore index profile 1
%        i2 alongshore index profile 2
%        fig: plot figure [true|false]
%
% Output: R correlation coefficient
%         a slope of linear fit
%         b intercept of linear fit
%
% Example:
%   [R,a,b]=nemo_correlate_profiles(D,'altitude',17,17,365,370,true);
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

OPT.fig=1;
if ~isempty(varargin);
    OPT.fig=varargin{1};
end

z1=squeeze(D.(z)(t1,i1,:));
z2=squeeze(D.(z)(t2,i2,:));
mask=~isnan(z1) & ~isnan(z2);
r=corrcoef(z1(mask),z2(mask));
R=r(1,2).^2;

[a,b]=polyfit(z1(mask),z2(mask),1);

if OPT.fig
    figure;
    hold on
    plot(z2,z1,'.');
    xlabel(['Depth profile 2 t=',num2str(t1,'%2.0f'),' i=',num2str(i1,'%3.0f'),' [m]']);
    ylabel(['Depth profile 1 t=',num2str(t1,'%2.0f'),' i=',num2str(i1,'%3.0f'),' [m]']);
    axis equal
    grid on
    xl=get(gca,'XLim');
    yl=get(gca,'YLim');
    h=line([min(xl) max(xl)],[min(xl),max(xl)]); h.LineStyle='-'; h.Color='k';
    title(['R^2= ',num2str(R,'%5.4f')]);
end
end
%EOF