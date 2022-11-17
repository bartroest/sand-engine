function MB=nemo_read_pathmultibeam(OPT)
%NEMO_READ_PATHMULTIBEAM Reads raw data of Delfland Multibeam surveys, creates a struct and saves a .mat file.
%
%   Reads raw xyz data of multibeam surveys, appends the files and stores the
%   resulting surveypath in a mat-file for faster loading.
%
%   Syntax:
%   	MB=nemo_read_pathmultibeam(OPT);
%
%   Input: 
%       OPT: Options structure from NEMO, alternatively enter the path to the
%       multibeam surveys.
%
%   Output:
%   	MB: multibeam surveypath struct
%
%   Example:
%       MB=nemo_read_pathmultibeam(OPT);
%
%   See also: nemo, nemo_readmultibeam

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
if ischar(OPT);
    basepath = OPT;
else
    basepath=fullfile(OPT.basepath,'..','..','Multibeam');
end

%% MB survey1 (2012)
% This one is spread over multiple ascii files.
files=dir2(fullfile(basepath,'73701_20120222_Delflandse Kust\ASCII\Ascii_gevalideerd'),'no_dirs',true);
for n=1:length(files); 
    try 
        fprintf(1,'Processing %s ... \n',fullfile(basepath,'73701_20120222_Delflandse Kust\ASCII\Ascii_gevalideerd',files(n).name));
        [E(n).x, E(n).y, E(n).z]=nemo_readmultibeam2(fullfile(basepath,'73701_20120222_Delflandse Kust\ASCII\Ascii_gevalideerd',files(n).name),1,Inf);
    catch
        disp('Failed to read file %s \n',files(n).name);
    end; 
end

x=[]; y=[]; z=[];
for n=1:length(E);
    x=[x;E(n).x];
    y=[y;E(n).y];
    z=[z;E(n).z];
end
clear E
%% MB survey2 (2015)
% This one is nicely in one ascii file.
    fprintf(1,'Processing Multibeam survey 2015... \n');
    [F.x, F.y, F.z]=nemo_readmultibeam([basepath,'79901_20150724_Delflandse Kust\ASCII\79901_Zandmotor compleet_2x2m_val.txt'],n,Inf);

%% Combine & Export
    MB.x=nan(2,max(length(x),length(F.x)));
    MB.y=MB.x;
    MB.z=MB.x;
    
    MB.x(1,1:length(x))=x;
    MB.y(1,1:length(x))=y;
    MB.z(1,1:length(x))=z;
    
    MB.x(2,1:length(F.x))=F.x;
    MB.y(2,1:length(F.x))=F.y;
    MB.z(2,1:length(F.x))=F.z;
    
    MB.time=([datenum(2012,02,22);datenum(2015,07,24)]);
    MB.meta={'Survey path of Multibeam surveys of the Delfland coast. Coordinates in RD-NAP.'};
    
    if OPT.save
    save([basepath,'\Multibeam\Path_Multibeam_Delfland.mat'],'-struct','MB');
    end
    %clear x y z E F
end