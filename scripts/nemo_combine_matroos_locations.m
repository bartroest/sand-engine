function D=nemo_combine_matroos_locations(E,F);
%nemo_combine_matroos_locations Patches missing data from other station.
%
% Patches missing data from a timeseries on location E with corresponding data
% from location F. Then outputs the patched E.
% Data from location F is patched on nans in location E.
%
%   Syntax:
%   	C = nemo_combine_matroos_locations(E,F)
%
%   Input: 
%       E: NOOS struct to be patched
%       F: NOOS struct to patch with
%
%   Output:
%   	C: Patched NOOS struct
%
%   Example
%   EUR=nemo_combine_matroos_locations(EUR,YM6);
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

t_all=(min([E.time;F.time]):datenum(0,0,0,0,10,0):max([E.time;F.time]))';
% temp=datevec(temp);
% temp(:,end-1)=round(temp(:,end-1),-1);
% temp(:,end)=0; % Set seconds back to 0, more than sufficient for 30 years of 10min data.
% t_all=datenum(temp);
t_all=correct_time(t_all);
E.time=correct_time(E.time);
F.time=correct_time(F.time);

D=struct('time',t_all,...
    'hm0',nan(size(t_all)),...
    'hs',nan(size(t_all)),...
    'th0',nan(size(t_all)),...
    'tm02',nan(size(t_all)),...
    'tp',nan(size(t_all)),...
    'dspr',nan(size(t_all)),...
    'u10',nan(size(t_all)),...
    'udir',nan(size(t_all)),...
    'wl',nan(size(t_all)),...
    'wlastro',nan(size(t_all)),...
    'wlsurge',nan(size(t_all)));

fn=fieldnames(E);
% [~,id,ie]=intersect(D.time,E.time);
[ism,idxf]=ismembertol(D.time,E.time);
for n=1:length(fn);
    if all(size(E.(fn{n}))==size(E.time));
%         D.(fn{n})(id)=E.(fn{n})(ie);
        D.(fn{n})(ism)=E.(fn{n})(idxf(ism));
    end
end

fn=fieldnames(F);
%[~,id,ie]=intersect(D.time,F.time);
[ism,idxf]=ismembertol(D.time,F.time);
for n=1:length(fn);
    if all(size(F.(fn{n}))==size(F.time));
        mask=isnan(D.(fn{n})) & ism;
        D.(fn{n})(mask)=F.(fn{n})(idxf(mask));
    end
end
end

function tt=correct_time(tt);
    tt=datevec(tt);
    tt(:,end-1)=round(tt(:,end-1),-1); %Round minutes to mult. of 10.
    tt(:,end)=0; % Set seconds back to 0, more than sufficient for 30 years of 10min data.
    tt=datenum(tt);
end
%EOF