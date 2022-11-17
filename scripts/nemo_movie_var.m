function nemo_movie_var(filename_out,framefolder,framerate,D)
%NEMO_MOVIE makes a movie based on prepared frames, based on D.time.
%
% Creates a movie in which surveys are shown based on the time between
% surveys, insted of a fixed time per survey. Frames must be pre-generated and
% sequentially numbered.
%
%
%   Syntax:
%   nemo_movie(filename_out,framefolder,framerate,D)
%
%   Input: 
%       filename_out: filename of movie
%       framefolder: path to folder with frames
%       framerate: number of frames to show per second
%       D: data struct
%
%   Output:
%   	movie file
%
%   Example:
%       nemo_movie('./bathy_var.avi','./figures/frames',24,D);
%
% See also: NEMO, NEMO_PLOT_BATHYMETRY, NEMO_MOVIE_BATHY.

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

n=1;
writerObj = VideoWriter([filename_out,'.avi']);
writerObj.FrameRate = framerate;
open(writerObj);
for t = 1 : (D.time(end)-D.time(1))/min(diff(D.time));
    if t < (D.time(n+1)-D.time(1))/min(diff(D.time));
    else
        n=n+1;
    end
    filename = sprintf([framefolder,'/frame_%d.png'], n);
    fprintf(1,'frame %4.0f, n= %2.0f \n',t,n);
    thisimage = imread(filename);
    writeVideo(writerObj, thisimage);
end
close(writerObj);
end
%EOF