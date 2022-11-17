function S = nemo_subset(D,varargin)
%NEMO_SUBSET  Takes a subset from a Jarkus compliant struct.
%
%   nemo_subset slices a Jarkus compliant matlab struct on its main
%   dimensions: time, alongshore and cross-shore. Slices are based on
%   indices in the respective dimensions and may be either index values or
%   logicals. When using logicals, the input must be the same size as the
%   respective dimension. 
%   By default all indices are true.
%
%   Syntax:
%       S = nemo_subset(D,varargin)
%
%   Input: For <keyword,value> pairs call belcoSubset() without arguments.
%     varargin  =
%       tidx: time dimension idices, index numbers or logicals of size(D.time).
%       lsidx: alongshore dimension idices, index numbers or logicals of
%           size(D.alongshore).
%       csidx: cross_shore dimension idices, index numbers or logicals of
%           size(D.cross_shore).
%   Output:
%       S: Subset of the original Jarkus-compliant struct D.
%
%   Example
%       D=nc2struct(jarkus_url);
%       S=nemo_subset(D,'tidx',[40:52],'lsidx',DL.alongshore>10000 & D.area_id==9,...
%       'csidx',sum(sum(~isnan(D.altitude),1),2)>0);
%
%   See also: nemo, jarkus, jarkus_transects

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2019 TU Delft
%       Bart Roest
%
%       bart.roest@kuleuven.be
%       l.w.m.roest@tudelft.nl
%
%       Stevinweg 1
%       2628 CN Delft
%       The Netherlands
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

% This tool is part of <a href="http://www.OpenEarth.eu">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 14 Nov 2019
% Created with Matlab version: 9.5.0.1178774 (R2018b) Update 5

% $Id: $
% $Date: $
% $Author: $
% $Revision: $
% $HeadURL: $
% $Keywords: $

%%
OPT.tidx= true(size(D.altitude,1),1);
OPT.lsidx=true(size(D.altitude,2),1);
OPT.csidx=true(size(D.altitude,3),1);

% return defaults (aka introspection)
if nargin==0;
    S = OPT;
    return
end
% overwrite defaults with user arguments
OPT = setproperty(OPT, varargin);

%% Verify input
if islogical(OPT.tidx) && any(size(OPT.tidx(:)) ~= size(D.time))
    error('tidx must be %d x %d, not %d x %d',size(D.time,1),size(D.time,2),size(OPT.tidx,1),size(OPT.tidx,2));
end
if islogical(OPT.lsidx) && any(size(OPT.lsidx(:)) ~= size(D.alongshore));
    error('lsidx must be %d x %d, not %d x %d',size(D.alongshore,1),size(D.alongshore,2),size(OPT.lsidx,1),size(OPT.lsidx,2));
end
if islogical(OPT.csidx) && any(size(OPT.csidx(:)) ~= size(D.cross_shore));
    error('csidx must be %d x %d, not %d x %d',size(D.cross_shore,1),size(D.cross_shore,2),size(OPT.csidx,1),size(OPT.csidx,2));
end
%% code
fn=fieldnames(D);
tlen=size(D.altitude,1);
lslen=size(D.altitude,2);
cslen=size(D.altitude,3);
slices={OPT.tidx; OPT.lsidx; OPT.csidx};

for n=1:length(fn);
    %Determine dimensions
    [dimmask,loc]=ismember([tlen, lslen, cslen],size(D.(fn{n})));

    %Take subset
    idx={1;1;1};
    for i=1:length(loc);
        if dimmask(i)
            idx(loc(i))=slices(i);
        end
    end
    S.(fn{n})=D.(fn{n})(cell2mat(idx(1)),cell2mat(idx(2)),cell2mat(idx(3)));
end
%EOF