function [D, Raw] = nemo_read_zmwavebuoy(filename, startRow, endRow)
%nemo_read_zmwavebuoy Read wave data from the ZM-Wavebuoy.
%   [D Raw] = nemo_read_zmwavebuoy(FILENAME) Reads data from text file FILENAME for the
%   default selection.
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
delimiter = ';';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[17,23]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [17,23]);
rawCellColumns = raw(:, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
%Raw.monster_identificatie					= rawCellColumns(:, 1);
Raw.meetpunt_identificatie					= rawCellColumns(:, 2);
%Raw.typering_omschrijving					= rawCellColumns(:, 3);
%Raw.typering_code							= rawCellColumns(:, 4);
%Raw.grootheid_omschrijving					= rawCellColumns(:, 5);
Raw.grootheid_code							= rawCellColumns(:, 6);
%Raw.parameter_omschrijving					= rawCellColumns(:, 7);
%Raw.parameter_code							= rawCellColumns(:, 8);
%Raw.eenheid_code							= rawCellColumns(:, 9);
%Raw.hoedanigheid_omschrijving				= rawCellColumns(:, 10);
%Raw.hoedanigheid_code						= rawCellColumns(:, 11);
%Raw.compartiment_omschrijving				= rawCellColumns(:, 12);
%Raw.compartiment_code						= rawCellColumns(:, 13);
%Raw.waardebewerkingsmethode_omschrijving	= rawCellColumns(:, 14);
%Raw.waardebewerkingsmethode_code			= rawCellColumns(:, 15);
%Raw.waardebepalingsmethode_omschrijving	= rawCellColumns(:, 16);
%Raw.waardebepalingsmethode_code			= cell2mat(rawNumericColumns(:, 1));
%Raw.bemonsteringssoort_omschrijving		= rawCellColumns(:, 17);
%Raw.bemonsteringssoort_code				= rawCellColumns(:, 18);
Raw.waarnemingdatum							= rawCellColumns(:, 19);
Raw.waarnemingtijd							= rawCellColumns(:, 20);
%Raw.limietsymbool							= rawCellColumns(:, 21);
Raw.meetwaarde                              = cell2mat(rawNumericColumns(:, 2));
%Raw.alfanumeriekewaarde					= rawCellColumns(:, 22);
%Raw.kwaliteitsoordeel_code					= rawCellColumns(:, 23);
%Raw.statuswaarde							= rawCellColumns(:, 24);
%Raw.opdrachtgevende_instantie				= rawCellColumns(:, 25);
%Raw.meetapparaat_omschrijving				= rawCellColumns(:, 26);
%Raw.meetapparaat_code						= rawCellColumns(:, 27);
%Raw.bemonsteringsapparaat_omschrijving		= rawCellColumns(:, 28);
%Raw.bemonsteringsapparaat_code				= rawCellColumns(:, 29);
%Raw.plaatsbepalingsapparaat_omschrijving	= rawCellColumns(:, 30);
%Raw.plaatsbepalingsapparaat_code			= rawCellColumns(:, 31);
%Raw.bemonsteringshoogte					= rawCellColumns(:, 32);
%Raw.referentievlak							= rawCellColumns(:, 33);
%Raw.epsg									= rawCellColumns(:, 34);
%Raw.x										= rawCellColumns(:, 35);
%Raw.y										= rawCellColumns(:, 36);
%Raw.orgaan_omschrijving					= rawCellColumns(:, 37);
%Raw.orgaan_code							= rawCellColumns(:, 38);
%Raw.taxon_name								= rawCellColumns(:, 39);

Raw.time=datenum(Raw.waarnemingdatum,'dd-mm-yyyy')+datenum(Raw.waarnemingtijd,'HH:MM:SS')-datenum('0101','ddmm');

%% Post-processing
% D.time=Raw.time;
% un=unique(Raw.grootheid_code);   
% for n=1:length(un);
%     mask=Raw.grootheid_code==un{n};
%     D.(un{n}).value=Raw.meetwaarde(mask);
%     D.(un{n}).time=Raw.time(mask);
% end

%%% Tijdstempels zijn uniek, dus beide boeien zijn eigenlijk hetzelfde :)
%%% MI hoeft niet te worden gesorteerd.

% % MI=unique(MEETPUNT_IDENTIFICATIE);
% % for n=1:length(MI);
% %     miindex=find(strcmp(MEETPUNT_IDENTIFICATIE,MI{n}));
    GC=unique(Raw.grootheid_code);
    for m=1:length(GC);
        idx=find(strcmp(Raw.grootheid_code,GC{m})); %Pak 1 grootheid (zitten door elkaar)
        [time, sidx] = sort(Raw.time(idx)); % Sorteer op oplopende tijd (is niet gesorteerd)
        temp = Raw.meetwaarde(idx); % Sorteer grootheid ook
        D.(GC{m})=temp(sidx);
        D.(GC{m})(D.(GC{m}) > 1000) = nan; % Converteer naar nan
        
        [D.time, ii]=unique(time); % Zoek unieke tijdstempels, sommige waarden zijn dubbel
        D.(GC{m})=D.(GC{m})(ii); % Vind bijbehorende grootheid
    end
    D.mask=~isnan(D.(GC{1}));
end
%EOF