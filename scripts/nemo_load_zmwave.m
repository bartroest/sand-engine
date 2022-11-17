function WZM=nemo_load_zmwave(wavefile)
%NEMO_LOAD_ZMWAVE Load wavedata from the ZM wave buoy
%
%   Loads data from the wave buoy that was deployed off the Sand Engine
%   intermittently between 2011 and 2014.
%
%   Syntax:
%       WZM=nemo_load_zmwave(OPT)
%
%   Input: 
%       wavefile: full path to mat-file with wave data (call with 0 arguments to
%       attempt automated open).
%
%   Output:
%   	WZM: struct with measurement data.
%
%   Example:
%       WZM=nemo_load_zmwave;
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

if nargin == 0
    wavefile = fullfile(OPT.basepath,'..','..','..','meteohydro\Golfkarakterisitieken\Measurements_Zandmotor_Monitoring_Dec_2011_till_Nov_2014.mat');
%elseif isstr(wavefile)
end
W=load(wavefile,'data');
monthnames=fieldnames(W.data);
fn=fieldnames(W.data.(monthnames{1}));
WZM.time=[];
for f=1:length(fn)-1;
    WZM.(fn{f})=[];
end

for m=1:length(monthnames);
    time=W.data.(monthnames{m}).(fn{1})(:,1);
    WZM.time=[WZM.time;time];
    for f=1:length(fn)-1;
        temp=W.data.(monthnames{m}).(fn{f})(:,3);
        WZM.(fn{f})=[WZM.(fn{f});temp];
    end
end