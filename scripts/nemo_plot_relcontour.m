function nemo_plot_relcontour(D,CL,reltime,Index,Time)
%NEMO_PLOT_RELCONTOUR pcolor of relative coastline position.
%
% Input: 
%   D: datastruct
%   CL: Coastline (depth contour) struct
%   reltime: time index for relativation
%
% Output:
%   Pcolor plot of the relative coastline position.
%
% See also: nemo

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
if nargin <4
    load('./Morfologische data/Time_indices.mat');
    load('./Morfologische data/Alongshore_indices.mat');
end
reldist=CL.dist-repmat(CL.dist(reltime,:),size(CL.dist,1),1);

figure; 
pcolor(D.alongshore,D.time_nemo(Time.nemo),reldist(Time.nemo,:)); 
shading flat; 
hold on;
pcolor(D.alongshore(Index.vb),D.time_vbnemo(Time.vbnemo),reldist(Time.vbnemo,Index.vb)); 
shading flat; 
hold on;
pcolor(D.alongshore(Index.zm),D.time(Time.all),reldist(Time.all,Index.zm)); 
shading flat; 
hold on;
grid on
csym; 
colormap(jwb(100,0));
colorbar;   
xlim([0 17500]);
datetickzoom('y','mmm-''yy');
ylabel('Time')
xlabel('Alongshore distance from Hoek van Holland [m]');
title(['Relative position of the 0m+NAP depth contour w.r.t survey ',num2str(reltime)]);
end
%EOF
