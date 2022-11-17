function XYZ=nemo_vb_txt2mat(vbpath)
%NEMO_VB_TXT2MAT Reads raw data from Vlugtenburg and exports a .mat-file.
%
%   Imports raw survey data from Vlugtenburg and outputs a struct with
%   surveypaths.
%
%   Syntax:
%   	XYZ=nemo_vb_txt2mat(vbpath)
%
%   Input: 
%       vbpath: path on OpenEarthRawData svn to Vlugtenburg directory.
%
%   Output:
%   	XYZ: struct with surveypaths
%
%   Example:
%       XYZ=nemo_vb_txt2mat(OPT.vbbasepath);
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

%%
%t_index time_walking   time_jetski
a={
[ 1]    '2011_07_20'    '2011_07_19'
[ 2]    '2011_08_17'    '2011_08_16'
[ 3]    '2011_10_16'    '2011_10_16'
[ 4]    '2011_11_12'    '2011_11_12'
[ 5]    '2011_12_22'    '2011_12_22'
[ 6]    '2012_01_10'    '2012_01_10'
[ 7]              []              []%'2012_02_13'    '2012_02_13' %overlaps with Nemo-survey
[ 8]    '2012_03_12'    '2012_03_13'
[ 9]    '2012_04_13'    '2012_04_13'
[10]              []              [] % does not exist
[11]    '2012_05_25'    '2012_05_24'
[12]              []              [] % does not exist
[13]    '2012_07_24'    '2012_07_23'
[14]    '2012_08_20'    '2012_08_20'
[15]    '2012_10_25'    '2012_10_25'
[16]    '2012_12_13'    '2012_12_13'};

jetskipath=[vbpath,'jetski\raw\'];
walkingpath=[vbpath,'walking\raw\'];
      
for n=1:size(a,1);
    if ~isempty(a{n,2});
    jetskifile=dir2([jetskipath,a{n,3},'\Products\'],'no_dirs',true,'file_incl','_RD_NAP.*\.txt');
    fprintf(1,'%s \n',[jetskifile.pathname,jetskifile.name]);
    jetski = nemo_read_txtVlugtenburg([jetskifile.pathname,jetskifile.name],9);
    
    walkingfile=dir2([walkingpath,a{n,2},'\Products\'],'no_dirs',true,'file_incl','.*\NAP.txt');
    fprintf(1,'%s \n',[walkingfile.pathname,walkingfile.name]);
    walking = nemo_read_txtwalking([walkingfile.pathname,walkingfile.name]);
    
    XYZ(n).X=[jetski.X ; walking.X];
    XYZ(n).Y=[jetski.Y ; walking.Y];
    XYZ(n).Z=[jetski.Z ; walking.Z];
    XYZ(n).time=datenum(a{n,3},'yyyy_mm_dd');
    end
end
save([vbpath,'/Vlugtenburg_path.mat'],'XYZ');