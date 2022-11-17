function [XYZ] = nemo_read_txtVlugtenburg(filename,sta)
%NEMO_READ_TXTVLUGTENBURG Read Shore Vlugtenburg-survey txt-files and output a struct.
%
%   Import numeric data from a text file as column vectors.
%
%   [XYZ] = nemo_read_txtVlugtenburg(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
%
%    See also NEMO, TEXTSCAN.

% Auto-generated by MATLAB on 2016/12/09 11:57:35

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
startRow = sta;
endRow = inf;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.

% % if startRow==9
    formatSpec = '%10f%11f%11f%[^\n\r]';
% % else
% %     formatSpec = '%10s%12s%s%[^\n\r]';
% % end
%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines', startRow, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

% % %% READ DATE
% % if nargin<=2
% %     startRow = 1;
% %     endRow = 1;
% % end
% % % Format string for each line of text:
% % %   column2: text (%s)
% % formatSpec = '%*10s%11s%[^\n\r]';
% % 
% % % Read columns of data according to format string.
% % data2 = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
% % for block=2:length(startRow)
% %     frewind(fileID);
% %     dataAB = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
% %     data2{1} = [data2{1};dataAB{1}];
% % end
% % % Remove white space around all cell columns.
% % data2{1} = strtrim(data2{1});

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
XYZ.X    = dataArray{:, 1};
XYZ.Y    = dataArray{:, 2};
XYZ.Z    = dataArray{:, 3};
% % XYZ.time = datenum(data2{1},'mm/dd/yyyy');
%EOF