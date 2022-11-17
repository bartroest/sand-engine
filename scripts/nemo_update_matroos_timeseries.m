%UPDATE MATROOS WAVE CONDITIONS!
% This script updates the timeseries from a matroos server.
% Usually waves and waterlevels are not available at the same location.
% Nearby stations are merged.

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

%% Download NOOS files
fprintf(1,'Okay great! Stuff is updating.\nHowever Matroos is excruciatingly slow.\nRun this script preferably over night.\n');

[matroos.locs,matroos.sources,matroos.units] = matroos_list('server','https://noos.matroos.rws.nl/');
locations={'Europlatform','europlatform 2','europlatform 3','ijmuiden munitiestort 1','ijmuiden munitiestort 2','ijmond stroompaal','wadden eierlandse gat','texel noordzee','Terschelling Noordzee','Schiermonnikoog Noord','Wierumergronden'};
sources={'observed'};
parameters={'wave_height_h1d3','wave_height_hm0','wave_direction','wave_period_tm02','wave_period_tp','wave_dirspread_s0bh','wind_speed','wind_direction','waterlevel_astro','waterlevel_surge','waterlevel'};
tstr=cellstr(datestr(datenum((2019:year(now))',1,1),'yyyy-mm-dd'));
% tstr(end+1)=cellstr(datestr(now,'yyyy-mm-dd'));

for t=1:length(tstr)-1;
    [~]=nemo_download_matroos(locations,sources,parameters,tstr{t},tstr{t+1},matroos);
end

%% Combine NOOS files per location
ii=1;
for n=1:length(locations);
    tmp=nemo_combine_noos([pwd,filesep,'matroos'],locations{n});
    switch locations{n}
        case {'Europlatform'};
            EPL=tmp;
        case {'europlatform 2'};
            EUR2=tmp;
        case {'europlatform 3'};
            EUR3=tmp;
        case {'ijmuiden munitiestort 1'};
            IJM1=tmp;
        case {'ijmuiden munitiestort 2'};
            IJM2=tmp;
        case {'ijmond stroompaal'};
            SPY=tmp;
        case {'wadden eierlandse gat'};
            ELD=tmp;
        case {'texel noordzee'};
            TEXE=tmp;
        case {'Terschelling Noordzee'}
            TERS=tmp;
        case {'Schiermonnikoog Noord'};
            SON=tmp;
        case {'Wierumergronden'};
            WIER=tmp;
        otherwise
            fprintf('Unknown location %s, saved in U(%i)\n',locations{n},ii);
            U(ii)=tmp;
            ii=ii+1;
    end
end

%% Merge locations
% Usually waves and waterlevels are not available at the same location.
% Nearby stations are merged.
% Europlatform (waterlevels) europlatform 2/3 (waves)
EUR=nemo_combine_matroos_locations(EUR3,EUR2);
EUR=nemo_combine_matroos_locations(EUR,EPL);
clear EUR3 EUR2 EPL

% ijmuiden munitiestortplaats 1/2 (waves), ijmuiden stroommeetpaal
% (waterlevels)
YM6=nemo_combine_matroos_locations(IJM1,IJM2);
YM6=nemo_combine_matroos_locations(YM6,SPY);
clear IJM1 IJM2 IJMS

% wadden eierlandse gat (waves), texel noordzee/terschelling noordzee (waterlevels)
ELD=nemo_combine_matroos_locations(ELD,TEXE);
ELD=nemo_combine_matroos_locations(ELD,TERS);
clear TEXE TERS

% Schiermonnikoog Noord (waves), wierumergronden (waterlevels)
SON=nemo_combine_matroos_locations(SON,WIER);
clear WIER

%% Update existing struct ASCData
ASCData=load('D:\Users\Bart\openearthrawdata\ecoshape\HK3.2\wavetransformation\WaveTable\ASCdata.mat','B','M');

M(1)=nemo_combine_matroos_locations(ASCData.M(1),EUR);
M(2)=nemo_combine_matroos_locations(ASCData.M(2),YM6);
M(3)=nemo_combine_matroos_locations(ASCData.M(3),ELD);
M(4)=nemo_combine_matroos_locations(ASCData.M(4),SON);
M(5)=nemo_combine_matroos_locations(ASCData.M(5),SON);
B=ASCData.B;
clear ASCData

save('ASCData2.mat','B','M');

%EOF