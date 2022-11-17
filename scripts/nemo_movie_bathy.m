%NEMO_MOVIE_BATHY Creates a movie from prepared frames of the bathymetry
%
% Creates a movie of bathymetries. Frames must be pre-generated and numbered
% sequentially. Frames are shown at constant interval, not taking actual time
% into account.
%
%
% See also: NEMO, NEMO_PLOT_BATHYMETRY, NEMO_MOVIE_VAR

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

writerObj = VideoWriter('./figures/b_mov/bathymetry_delfland.avi');
writerObj.FrameRate = 1;

open(writerObj);
%for K = 1 : length(D.time)+47;
for K = 45 : length(D.time)+47;
%     if K <= 47;
%         filename = sprintf('./figures/bathymetry/jarkframe_%d.png', K);
%     else
%         filename = sprintf('./figures/bathymetry/frame_%d.png', K-47);
        filename = sprintf('./figures/b_mov/frame_%d.png', K);
%     end
  thisimage = imread(filename);
  writeVideo(writerObj, thisimage);
end
close(writerObj);