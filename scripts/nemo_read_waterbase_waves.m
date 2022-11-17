function [W,D]=nemo_read_waterbase_waves(loc)%(tstart,dt,tend)
%NEMO_READ_WATERBASE_WAVES Reads waterbase txt-files and makes equidistant time vectors.
%
% NOTE! Waterbase is offline since 2018, therefore this scrip only works on
% local files!
% Reads wave-data from EURPFM and parses to equidistant time vector.
%
% Example:
%   W = nemo_read_waterbase_waves('EUR');
%
% See also: NEMO

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
if nargin<1
    loc='EUR';
end

if strncmpi(loc,'EUR',3)
    % EUROPLATFORM
    D(1)=rws_waterbase_read('./Data/id22-EURPFM-201101010000-201801012359.txt'); %Wave height
    D(2)=rws_waterbase_read('./Data/id23-EURPFM-201101010000-201801012359.txt'); %Wave direction
    D(3)=rws_waterbase_read('./Data/id24-EURPFM-201101010000-201801012359.txt'); %Wave period
    E=rws_waterbase_read('./Data/id1-SCHEVNGN-201107010000-201711012359.txt');   %Waterlevel Scheveningen

elseif strncmpi(loc,'IJ',2)
    % IJMUIDEN MUNITIESTORTPLAATS
    D(1)=rws_waterbase_read('./Data/id22-IJMDMNTSPS-201101010000-201801012359.txt'); %Wave height
    D(2)=rws_waterbase_read('./Data/id23-IJMDMNTSPS-201101010000-201801012359.txt'); %Wave direction
    D(3)=rws_waterbase_read('./Data/id24-IJMDMNTSPS-201101010000-201801012359.txt'); %Wave period

elseif strncmpi(loc,'EIE',3) || strncmpi(loc,'ELD',3);
    % EIERLANDSEGAT
    D(1)=rws_waterbase_read('./Data/id22-EIELSGT-201101010000-201801012359.txt'); %Wave height
    D(2)=rws_waterbase_read('./Data/id23-EIELSGT-201101010000-201801012359.txt'); %Wave direction
    D(3)=rws_waterbase_read('./Data/id24-EIELSGT-201101010000-201801012359.txt'); %Wave period  
    
end
%% Intersect to time
W.time=(datenum(2011,07,01):1/24:datenum(2017,11,01))';
%W.time=tstart:dt:tend;
W.h=nan(size(W.time));
W.d=nan(size(W.time));
W.p=nan(size(W.time));

[~, m, n]=intersect(W.time,D(1).data.datenum);
W.h(m)=D(1).data.waarde(n);
W.h(W.h>1000)=nan;
W.h=W.h/100;

[~, m, n]=intersect(W.time,D(2).data.datenum);
W.d(m)=D(2).data.waarde(n);
W.d(W.d>1000)=nan;

[~, m, n]=intersect(W.time,D(3).data.datenum);
W.p(m)=D(3).data.waarde(n);
W.p(W.p>1000)=nan;

if exist('E','var');
[~, m, n]=intersect(W.time,E.data.datenum);
W.wl(m)=E.data.waarde(n);
W.wl(W.wl>1000)=nan;
end

W.mask=~isnan(W.h) & ~isnan(W.d) & ~isnan(W.p);
end