function D = nemo_read_wavedata(OPT)
%NEMO_READ_WAVEDATA Read data from the wave transformation model in zandmotordata.nl
%
%   Read ascii files with spectral timeseries from zandmotordata svn.
%   OPT to provide path.
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
%% Initialize variables.
delimiter = ' ';
if nargin<=2
    startRow = 10;
    endRow = inf;
end
D=struct('time',[],'Hm0',[],'Hdir',[],'Tp',[]);

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
for year=2011:2015;

    filename=fullfile(OPT.basepath,'..','..','..','meteohydro\Golftransformatie\Yearly transformation',num2str(year),'data\loc2.asc');
    fileID = fopen(filename,'r');

    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end

    %% Close the text file.
    fclose(fileID);

    %% Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for
    % unimportable data, select unimportable cells in a file and regenerate the
    % script.

    %% Allocate imported array to column variable names
    date1 = dataArray{:, 1};
    time = dataArray{:, 2};
    temp.time=nan(size(date1));
    for t=1:length(date1);
        temp.time(t)=datenum([date1{t},time{t}],'yyyymmddHHMMSS');
    end
    temp.Hm0 = dataArray{:, 3};
    temp.Hdir = dataArray{:, 4};
    temp.Tp = dataArray{:, 5};
    
    %% Append
    D.time=[D.time;temp.time];
    D.Hm0=[D.Hm0;temp.Hm0];
    D.Hdir=[D.Hdir;temp.Hdir];
    D.Tp=[D.Tp;temp.Tp];
end


end
