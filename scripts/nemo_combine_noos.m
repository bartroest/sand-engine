function D=nemo_combine_noos(basepath,location);
%nemo_combine_noos Combined NOOS files from a location.
%
% Combines timeseries from different noos files taken at the same location. This
% effectively synchronises and bundles metocean data.
%
%   Syntax:
%   	D = nemo_combine_noos(path_to_noos_files,noos_station)
%
%   Example
%   EUR=nemo_combine_matroos_locations(pwd,'EUR');
%
%   See also: nemo, noos, matroos

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

% Get all files for location
fn=dir2('basepath',basepath,'file_incl',['^',location,'.*.-observed-.*.noos$'],'no_dirs',true);
if isempty(fn)
    warning('No files found for location %s, skipping...\n',location);
    D=[];
    return
end
% Preallocate struct with all desired fieldnames
T=struct('hm0',[],'hs',[],'th0',[],'tm02',[],'tp',[],...
    'dspr',[],'u10',[],'udir',[],'wl',[],'wlastro',[],'wlsurge',[]);
t_all=[];

% Prepare contents with empties
fldn=fieldnames(T);
for n=1:length(fldn);
    T.(fldn{n}).t=[];
    T.(fldn{n}).v=[];
end    

%% Load all data
% Cycle trough files, determine parameters and append data.
fprintf(1,'%3i files found.\nReading [',length(fn));
for n=1:length(fn);
%     fprintf(1,'File %i of %i\n',n,length(fn));
    fprintf(1,'#');
    [t,v]=noos_read([fn(1).pathname,fn(n).name]);
    loc=strfind(fn(n).name,'-'); 
    param=fn(n).name(loc(1)+1:loc(2)-1);
    switch param
        case 'wave_height_h1d3'
            fld='hs';
        case 'wave_height_hm0'
            fld='hm0';
        case 'wave_period_tm02'
            fld='tm02';
        case 'wave_period_tp'
            fld='tp';
        case 'wave_direction'
            fld='th0';
        case 'wave_dirspread_s0bh'
            fld='dspr';
        case 'wind_speed'
            fld='u10';
        case 'wind_direction'
            fld='udir';
        case 'waterlevel'
            fld='wl';
        case 'waterlevel_astro'
            fld='wlastro';
        case 'waterlevel_surge'
            fld='wlsurge';
        otherwise
            fld=input(sprintf('Unknown parameter: %s, enter fieldname: ',param),'s');
            if ~isfield(T,fld);
                T.(fld).t=[];
                T.(fld).v=[];
            end
    end
    t_all=[t_all;t'];
    T.(fld).t=[T.(fld).t;t'];
    T.(fld).v=[T.(fld).v;v'];
end
fprintf(1,']\n');

% Unique time stamps for all data
t_all=unique(t_all);
% Make intervals uniform and correct for truncation errors.
t_all=(t_all(1):datenum(0,0,0,0,10,0):t_all(end))';
temp=datevec(t_all); 
temp(:,end)=0; % Set seconds back to 0, more than sufficient for 30 years of 10min data.
t_all=datenum(temp); 

D=struct(... %'file','',...
    'time',t_all,...
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

% Match data to the common time stamps
for n=1:length(fldn);
    [~,id,it]=intersect(t_all, T.(fldn{n}).t);
    D.(fldn{n})(id)=T.(fldn{n}).v(it);
end

%% Post-processing
% Patch missing values.
mask=find(isnan(D.hm0));
D.hm0(mask)=D.hs(mask);
D=rmfield(D,'hs');
end

