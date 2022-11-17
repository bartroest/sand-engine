%NEMO_BUILD_INDICES Build time and alongshore indices for useful subsets.
%
% Creates two structs with index numbers for easy access to the data.
% Time: contains time-indices for different temporal subsets.
% Index: contains alongshore-indices for different spatial subsets.
%
% This script must be updated manually!
% 
% Also look inside this script!
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
%% Warning
warning('These indices are hard-coded. Adjust this file when new surveys are added, or when redefining the transect struct.');
%% Check
% % % [Date_ZM,Date_NEMO,Date_Jarkus_topo,Date_Jarkus_bathy,Date_VB_lopen,Date_VB_jetski]=nemo_read_crsurvdates([OPT.basepath,'..\scripts\matlab\crossref_surveydates.xls']);
% % % if length(Date_ZM)>44;%Adjust to new number of surveys!
% % %     fprintf(1,'New surveys have been added. \n Supply additional information to the ''TIME'' struct! \n');
% % %     edit nemo_build_indices
% % %     return
% % % end

% % % %% Time indices
% % % idx=1:length(Date_ZM);
% % % Time.all=       idx;                                                %All full (ZM) surveys
% % % Time.bimonthly= [1   3   5   7   9    12    14 15 16 17 18 19 20    22 23 24 25 26 27 28 29 30    32 33 34 35 36 37 38 39 40 41 42 43 44]; %Surveys on a bi-monthly interval (approximate)
% % % Time.jarkus=    idx(~isnan(Date_Jarkus_bathy));                     %ZM Surveys coinciding with JARKUS bathymetry surveys
% % % Time.july=      [1                       13                19                25                31                37          41]; %Surveys around july (annual interval)
% % % Time.nemo=      idx(~isnan(Date_NEMO));                             %ZM Surveys coinciding with Nemo surveys
% % % Time.vb=        idx(~isnan(Date_VB_jetski));                        %ZM Surveys coinciding with Vlugtenburg surveys
% % % Time.vbnemo=    idx(~isnan(Date_NEMO) | ~isnan(Date_VB_jetski));    %ZM Surveys coinciding with Nemo/Vlugtenburg surveys
% % % Time.zmplus=    [            7                       17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38       41]; %ZM+Nemo Surveys covering the extended ZM-area (as of 41).


%% Time indices
% Range currently is [1:50], 10 is incomplete (additional spit survey after damming interventions)                                                        v-- Add new indices here.
Time.all=       [1 2 3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50]; %All full (ZM) surveys.
Time.bimonthly= [1   3   5   7   9    12    14 15 16 17 18 19 20    22 23 24 25 26 27 28 29 30    32 33 34 35 36 37 38 39 40 41 42 43 44 45               ]; %Surveys on a bi-monthly interval (approximate).
Time.jarkus=    [            7                          18             23                   30                   37          41    43          47         ]; %ZM Surveys coinciding with JARKUS bathymetry surveys.
Time.july=      [1                       13                19                25                31                37          41       44       47    49   ]; %Surveys around july (annual interval).
Time.nemo=      [            7                       17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38                                    ]; %ZM Surveys coinciding with Nemo surveys.
Time.vb=        [1 2 3 4 5 6 7 8 9 11    13 14 15 16                                                                                                      ]; %ZM Surveys coinciding with Vlugtenburg surveys.
Time.vbnemo=    [1 2 3 4 5 6 7 8 9 11    13 14 15 16 17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38                                    ]; %ZM Surveys coinciding with Nemo/Vlugtenburg surveys.
Time.zmplus=    [            7                       17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38    40 41 42 43 44 45 46 47 48 49 50]; %ZM+Nemo Surveys covering the extended ZM-area (as of 40/41).
%TIME (year)    [2011     |2012                     |2013             |2014          |2015             |2016             |2017 |2018       |2019 |2020    ];
%save([OPT.basepath,'..\NCdata\Time_indices.mat'],'Time');
save([OPT.outputfolder,'time_indices.mat'],'Time');

%% Alongshore indices
%There are 644 transects alongshore, of which 1:612 carry data. Transect
%1:15 are added extra to cover the corner near Hoek van Holland. The
%original Sand Engine domain is from [305:428], the extended domain (from
%2017) [266:473]. The Vlugtenburg Area roughly corresponds to [94:160].
Index.all=   [1:644]; % All alongshore indices
Index.jarkus=[15 25 35 45 55 65 75 80 90 100 110 120 130 140 150 159 166 ...
    173 180 187 194 201 208 216 223 231 239 247 254 263 272 280 283 285 ...
    291 297 299 305 309 311 315 319 321 325 329 331 335 339 341 345 349 ...
    351 355 359 361 365 369 371 375 379 381 385 389 391 394 397 399 402 ...
    405 407 410 412 414 417 420 422 425 428 430 435 440 442 447 457 465 ...
    473 481 489 497 500 502 510 516 518 528 538 540 550 560 562 572 582 ...
    584 594 600 607 610 631 637]; % Alongshore indices coinciding with Jarkus transects
Index.zm=    [305:428]; % Zandmotor indices
% Zandmotor extended area (January 2017 onward)
Index.zmplus=[266:2:280, 281:2:303,... % Uitbreiding West
              305:428,...              % Zandmotor (original)
              429:430, 433 435 436:2:444 445:2:451 455:2:457 458 460 463 465 466:2:470 473]; % Uitbreiding oost (might need revision).
            %[266:473]; 
Index.nemo=  [1:304,429:644]; % Nemo indices
Index.vb=    [94:160]; % Vlugtenburg indices

% save([OPT.basepath,'..\NCdata\alongshore_indices.mat'],'Index');
save([OPT.outputfolder,'alongshore_indices.mat'],'Index');
%EOF