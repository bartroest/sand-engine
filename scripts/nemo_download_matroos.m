function D=nemo_download_matroos(location,source,unit,tstart,tstop,matroos);
%NEMO_DOWNLOAD_MATROOS_DATA Downloads NOOS files from the RWS Matroos server.
%
%   Download metocean timeseries from Matroos that are used for ZM/Nemo
%   research, since Donar is no longer online.
%
%   Syntax:
%   NOOS=nemo_download_matroos(location,source,unit,tstart,tstop,matroos);
%
%   Input: 
%       location: matroos location ('EURPFM')
%       source: matroos source ('observed')
%       unit: 'hm0'
%       tstart: starting time string
%       tstop: end time string
%       matroos: matroos catalog (optional, but greatly speeds thing up!)
%
%   Output:
%       D: Combined noos data.
%
%   Example
%   EUR = nemo_download_matroos(location,source,unit,tstart,tstop,matroos);
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

outputfolder=[pwd,'\matroos\'];
if ~exist(outputfolder,'dir');
    mkdir(outputfolder);
end

%Get catalog
if nargin < 6;
    fprintf(1,'Retreiving catalog\n');
    [matroos.locs,matroos.sources,matroos.units] = matroos_list('server','https://noos.matroos.rws.nl/');
end

locmask=false(length(matroos.locs),length(location));
for n=1:length(location);
    locmask(:,n)=strcmpi(location{n},matroos.locs); 
end
locmask=any(locmask,2);

soumask=false(length(matroos.sources),length(location));
for n=1:length(source);
    soumask(:,n)=strcmpi(source{n},matroos.sources);
end
soumask=any(soumask,2);

unimask=false(length(matroos.units),length(location));
for n=1:length(unit);
    unimask(:,n)=strcmpi(unit{n},matroos.units);
end
unimask=any(unimask,2);

% Identifiy all valid combinations of Location, Source and Unit.
idx=find(all([locmask, soumask, unimask],2));

% | strcmpi('wave_period_tm02',matroos.units) | strcmpi('wave_direction',matroos.units)))

fprintf(1,'Downloading data...\n');
D=[];
for n=1:length(idx);
    
    fname=[outputfolder,matroos.locs{idx(n)},'-',matroos.units{idx(n)},'-',matroos.sources{idx(n)},'-',tstart,'-',tstop,'.noos'];
%     fprintf(1,'%i of %i %s\n',n,length(idx),fname);
    if exist(fname,'file');
        fprintf(1,'Skipping...\n');
        continue
    else
    [D] = matroos_get_series('server','http://noos.matroos.rws.nl/',...
        'loc',matroos.locs{idx(n)},...
        'unit',matroos.units{idx(n)},...
        'source',matroos.sources{idx(n)},...
        'tstart',tstart,'tstop',tstop,'check',false,'file',fname);
    end
end
end