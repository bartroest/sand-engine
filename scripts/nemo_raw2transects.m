%NEMO_RAW2TRANSECTS Script to convert the .mat files of the Shore surveys into a NetCDF file
%
% This script takes the raw xyz-point clouds of the Zandmotor surveys,
% checks for additional surveys (Nemo, Vlugtenburg...) at the same
% timestamp and appends point clouds. The combined point clouds are then
% interpolated to transects, using parameters defined in OPT.
% 2D-linear interpolation is applied, with checks for the proximity of real
% data to an interpolated point. If real data is too far away, the
% interpolation is set to nan.
%
% Time indices are obtained from crossref_surveydates.xls. Adust this file
% for new surveys.
%
% Parameters can be adjusted in the script.
%
% Uses:
% nemo_Schematize_data,
% nemo_extract_line_Shore,
% nemo_data2netcdf,
% nemo_path2netcdf,
% OpenEarthTools (https://publicwiki.deltares.nl/display/OET/OpenEarth)
%
% Shore Monitoring & Reseach, Jan 2014
% info@shoremonitoring.nl
% Adapted by Bart Roest, Okt 2016, Okt 2017, 2018
% l.w.m.roest@tudelft.nl
%
% See also: nemo_Schematize_data, nemo_extract_line_Shore, nemo_data2netcdf, nemo_path2netcdf, convertCoordinates.

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

%% INPUT VARS

dist_perpendicular=15; %Distance perpendicular from transect to look for points
max_dist_cs=10; %Interpolation treshold between raw data and interpolated positions.
altswitch=true; %[true|false] Interpolate 'short' ZM-transects to 'long' ZM-transects. Introduces small interpolation errors but improves volume calculations!

if ~exist('OPT','var')
    fprintf(1,'No OPT struct was found, cannot continue. Run nemo.m \n');
    edit('nemo.m');
    return 
end

%Path to the folder with raw data (containing individual folders with surveys).    
while ~exist(OPT.basepath,'dir')
    fprintf(2,'%s \n',['Directory: ',OPT.basepath,' does not exist! Change basepath.']);
    OPT.basepath=input('Path to raw data & surveys: \n','s');
end

%Path to the output directory for .mat and .nc
while ~any(strcmp(fieldnames(OPT),'outputfolder'))
    fprintf(2,'%s \n',['Directory: ',OPT.outputfolder,' does not exist!']);
    OPT.outputfolder=input('Path to the output directory: \n','s');
    mkdir(OPT.outputfolder);
end

%If Vlugtenburg surveys are added, also check for VB-data folder.
if ~any(strcmp(fieldnames(OPT),'vb'))
    OPT.vb=input('Include Vlugtenburg surveys (Aug 2011 - Feb 2013)? [1 0]: ');
    while ~exist(OPT.vbbasepath,'dir') && OPT.vb
        fprintf(2,'%s \n',['Directory: "',OPT.vbbasepath,'" does not exist! Change VBbasepath.']);
        OPT.vbbasepath=input('Path to Vlugtenburg surveys: \n','s');
    end
end

%If Multibeam surveys are added, also check for MB-data folder.
if ~any(strcmp(fieldnames(OPT),'mb'))
    OPT.mb=input('Include Multibeam surveys (Feb 2012 & Jun 2015)? [1 0]: ');
    while ~exist(OPT.mbbasepath,'dir') && OPT.mb
        fprintf(2,'%s \n',['Directory: "',OPT.mbbasepath,'" does not exist! Change MBbasepath.']);
        OPT.mbbasepath=input('Path to Multibeam surveys: \n','s');
    end
end

if ~any(strcmp(fieldnames(OPT),'keepraw'))
    fprintf(1,'This saves the raw surveypoints per transect. \n');
    OPT.keepraw=input('Save Raw transect data? [1 0]: ');
end

if ~any(strcmp(fieldnames(OPT),'save')) %Save mat files in outputfolder
    OPT.save=input('Save .mat files? [1 0]: ');
end

if ~any(strcmp(fieldnames(OPT),'write_nc')) %Save netCDF files in outputfolder
    OPT.write_nc=input('Write data to NetCDF? [1 0]: ');
end
%% /INPUT VARS

%% PRE-PROCESSING
fprintf(1,'Collecting all files... \n')
%addpath(fullfile(fileparts(mfilename('fullpath')), 'matlab'))
% select the folder waar de QC-ed XYZ.mat files staan
%QC_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'raw', 'zandmotor');%uigetdir(pwd,'Select folder with .mat files containing XYZ data');
QC_dir=fullfile(OPT.basepath,'zandmotor'); %ZM-surveys
QC_files = dir2(QC_dir,...
    'no_dirs', true,...
    'file_incl', '_XYZ_.*\.mat$');

%QC_dir_N = fullfile(fileparts(mfilename('fullpath')), '..', 'raw', 'delfland_coast');%uigetdir(pwd,'Select folder with .mat files containing XYZ data');
QC_dir_N=fullfile(OPT.basepath,'delfland_coast'); %NEMO-surveys
QC_files_N = dir2(QC_dir_N,...
    'no_dirs', true,...
    'file_incl', '_XYZ_.*\.mat$');

% load file with the surveylines definitions
%load('Surveylines_DL_fine','Surveylines'); % 1m CS-spacing
if exist([OPT.outputfolder,'\Surveylines_Delfland.mat'],'file')
    load([OPT.outputfolder,'\Surveylines_Delfland.mat'],'Surveylines');
else
    fprintf(1,'No custom Surveyline file found, fallback to old one in "%s"\n',OPT.basepath);
    load([OPT.basepath,'..\scripts\matlab\Surveylines_Delfland'],'Surveylines'); % 5m CS-spacing
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Any .mat-file containing the same fields as "Surveylines_Delfland" should
%work for interpolation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Reading crossref_surveydates.xls for coupling of surveys.\n');
[Date_ZM,Date_NEMO,Date_Jarkus_topo,Date_Jarkus_bathy,Vluchtenburg_lopen,Vluchtenburg_jetski]=nemo_read_crsurvdates([OPT.basepath,'..\scripts\matlab\crossref_surveydates.xls']);
svninfo = svn_info(QC_dir);
rawdataurl = svninfo.url;

nsurveys=length(QC_files);
if nsurveys>length(Date_ZM)
    fprintf(2,'Please update crossref_surveydates.xls to contain the most recent surveys! \n');
    fprintf(1,'The number of surveys is larger than the length of crossref_surveydates. \n');
    fprintf(1,'%i .mat files found, crossref_surveydates.xls contains %i entries, %s is the most recent \n',...
        nsurveys,length(Date_ZM),Date_ZM{end});
    fprintf(1,'%s \n',fullfile(OPT.basepath,'..','scripts','matlab','crossref_surveydates.xls'));
    return
end
% %% Try to automate coupling
% % Automated coupling of Nemo & Zandmotor is impossible due to differences
% % in gaps between surveys and the otherwise double use of some nemo data.
% % Coupling is now done using a manually edited cross-reference list.
% for i=1:length(QC_files_N)
% date_nemo{i} = datestr(datenum(regexp(QC_files_N(i).pathname, '\d{4}_\d{2}_\d{2}', 'match'), 'yyyy_mm_dd'), 'yyyy-mmm-dd');
% end
% for i=1:nsurveys
% XYZ(i).date = datestr(datenum(regexp(QC_files(i).pathname, '\d{4}_\d{2}_\d{2}', 'match'), 'yyyy_mm_dd'), 'yyyy-mmm-dd');   
%     [dt, j]=min(abs(datenum(XYZ(i).date,'yyyy-mmm-dd')-datenum(date_nemo,'yyyy-mmm-dd')));
%     if dt<=30;
%         XYZ(i).date_nemo=date_nemo{j};
%     else
%         XYZ(i).date_nemo=[];
%     end
% end


%% ADDITIONAL DATASETS TO COMBINE: VLUGTENBURG, MULTIBEAM and RAW JARKUS.
if OPT.vb %Add Vlugtenburg surveys (Aug 2011 - Feb 2013)?
    fprintf(1,'Loading Vlugtenburg surveys \n');
    QC_dir_V=fullfile(OPT.vbbasepath); %Vlugtenburg surveys
    QC_files_V = dir2(QC_dir_V,...
    'no_dirs', true,...
    'file_incl', 'XYZ_*\.txt');
    XYZ_V=nemo_vb_txt2mat(OPT);
end
if OPT.mb %Add off-shore Multibeam surveys (Feb 2012 & Jun 2015)
    fprintf(1,'Loading Multibeam surveys \n');
%     QC_dir_V=fullfile([OPT.basepath,..\..\Multibeam]); %Vlugtenburg surveys
%     QC_files_V = dir2(QC_dir_V,...
%     'no_dirs', true,...
%     'file_incl', 'XYZ_*\.txt');
    XYZ_MB(1)=load('./Morfologische data/Path_multibeam_20120211.mat');
    XYZ_MB(2)=load('./Morfologische data/Path_multibeam_20150624.mat');
end
% % % if OPT.jraw %Add raw jarkus data
% % %     fprintf(1,'Loading raw jarkus survey \n');
% % %     QC_dir_J=fullfile([OPT.basepath]); %Jarkus 2012 bathy surveys
% % %     QC_files_J = dir2(QC_dir_J,...
% % %     'no_dirs', true,...
% % %     'file_incl', 'XYZ_*\.txt');
% % % end

% Initiate NetCDF Transects
FillValue=-9999;  % number to be used to fill the data gaps in NetCDF file (similar to Jarkus)
NCdata.areacode=9; % Delfland!
NCdata.areaname='Delfland';


%% Load Surveys and interpolate to Transects
fprintf(1,'Interpolating raw data to transects... \n');
for i=1:nsurveys %For the number of ZM surveys, ZM is leading in determining the index, other cojoining surveys are appended.
    %LOAD ZM_SURVEY
    %Survey date is inherited from path.
    XYZ(i).date = datestr(datenum(regexp(QC_files(i).pathname, '\d{4}_\d{2}_\d{2}', 'match'), 'yyyy_mm_dd'), 'yyyy_mm_dd');   
    XYZ(i).time = Date_ZM{i};
    fprintf('[# %.1f%% procprog info #] processing survey %s\n', (i-1)/nsurveys*100, XYZ(i).date)
    Z = load(fullfile(QC_files(i).pathname, QC_files(i).name));
    fnames = fieldnames(Z);
    if ~any(strcmp(fnames, 'XYZ'))
        % if field XYZ is not present assume that the first fieldname
        % contains the data and rename.
        monthname = fnames{1};
        datafieldnames = fieldnames(Z.(monthname));
        xfieldname = datafieldnames{strcmpi(fieldnames(Z.(monthname))', 'x')};
        Z.XYZ.X = Z.(monthname).(xfieldname);
        yfieldname = datafieldnames{strcmpi(fieldnames(Z.(monthname))', 'y')};
        Z.XYZ.Y = Z.(monthname).(yfieldname);
        zfieldname = datafieldnames{strcmpi(fieldnames(Z.(monthname))', 'z')};
        Z.XYZ.Z = Z.(monthname).(zfieldname);
    end
    %END LOAD ZM_SURVEY
    
    %LOAD NEMO_SURVEY
    %[~,~,j]=intersect(XYZ(i).date,Date_ZM);
    if ~isempty(Date_NEMO{i}) %Only add NEMO when there is a survey.
        data_file = dir(fullfile(QC_dir_N,Date_NEMO{i},'*.mat'));
        N = load(fullfile(QC_dir_N,Date_NEMO{i},data_file.name));
        %N = load(fullfile(QC_files_N(i).pathname, QC_files_N(i).name));
        fnames = fieldnames(N);
        if strcmp(Date_NEMO{i},'2012_02_26') %Special case!
            N.XYZ.X=[N.NeMoDry.x N.NeMoJet.x];
            N.XYZ.Y=[N.NeMoDry.y N.NeMoJet.y];
            N.XYZ.Z=[N.NeMoDry.z N.NeMoJet.z];
        elseif ~any(strcmp(fnames, 'XYZ'))
            % assume that fieldname is the first available field
            monthname = fnames{1};
            datafieldnames = fieldnames(N.(monthname));
            xfieldname = datafieldnames{strcmpi(fieldnames(N.(monthname))', 'x')};
            N.XYZ.X = N.(monthname).(xfieldname);
            yfieldname = datafieldnames{strcmpi(fieldnames(N.(monthname))', 'y')};
            N.XYZ.Y = N.(monthname).(yfieldname);
            zfieldname = datafieldnames{strcmpi(fieldnames(N.(monthname))', 'z')};
            N.XYZ.Z = N.(monthname).(zfieldname);
        end
    %END NEMO_SURVEY
    
    %MERGE ZM+NEMO
        %Merge data if Nemo is also surveyed (append both surveypaths)
        XYZ(i).data.XYZ.X=[Z.XYZ.X(:); N.XYZ.X(:)];
        XYZ(i).data.XYZ.Y=[Z.XYZ.Y(:); N.XYZ.Y(:)];
        XYZ(i).data.XYZ.Z=[Z.XYZ.Z(:); N.XYZ.Z(:)];
    else
        %Only zandmotor
        XYZ(i).data.XYZ.X=Z.XYZ.X(:);
        XYZ(i).data.XYZ.Y=Z.XYZ.Y(:);
        XYZ(i).data.XYZ.Z=Z.XYZ.Z(:);
    end
    clear N Z
    %END MERGE ZM+NEMO
    
    %MERGE VLUGTENBURG
    if OPT.vb
        %Append Vlughtenburg if available
        if i<=length(XYZ_V) %VB only available for first 16 ZM-surveys.
            XYZ(i).data.XYZ.X=[XYZ(i).data.XYZ.X; XYZ_V(i).X];
            XYZ(i).data.XYZ.Y=[XYZ(i).data.XYZ.Y; XYZ_V(i).Y];
            XYZ(i).data.XYZ.Z=[XYZ(i).data.XYZ.Z; XYZ_V(i).Z];
        end
    end
    %END MERGE VLUGTENBURG
    
    %MERGE MULTIBEAM
    if OPT.mb
        %Append Multibeam if available (SLOW! due to huge amount of data)
        if i==7 %ZM-survey February 2012
            fprintf(1,'Adding MB-survey of 22-02-2012 to ZM survey %s\',XYZ(i).date);
            XYZ(i).data.XYZ.X=[XYZ(i).data.XYZ.X; XYZ_MB(1).x];
            XYZ(i).data.XYZ.Y=[XYZ(i).data.XYZ.Y; XYZ_MB(1).y];
            XYZ(i).data.XYZ.Z=[XYZ(i).data.XYZ.Z; XYZ_MB(1).z];
        elseif i==30 %ZM-survey July 2015
            fprintf(1,'Adding MB-survey of 24-07-2015 to ZM survey %s\',XYZ(i).date);
            XYZ(i).data.XYZ.X=[XYZ(i).data.XYZ.X; XYZ_MB(2).x];
            XYZ(i).data.XYZ.Y=[XYZ(i).data.XYZ.Y; XYZ_MB(2).y];
            XYZ(i).data.XYZ.Z=[XYZ(i).data.XYZ.Z; XYZ_MB(2).z];
        end
    end
    %END MERGE MULTIBEAM
    
%%% INTERPOLATE AND SCHEMATIZE DATA
    %temp = nemo_Schematize_data(Surveylines,XYZ(i).data.XYZ,10,7.5); %NORMAL
    temp = nemo_Schematize_data(Surveylines,XYZ(i).data.XYZ,dist_perpendicular,max_dist_cs,i,altswitch);
    if OPT.keepraw
        Raw(i)=temp; %Keep the 'raw' data.
    end
%%% END INTERPOLATION
    
    for k=1:length(temp.line.CS) %Write data to struct.
        if i==1
            NCdata.id(k,1)   = temp.line.CS(k).JarkusAlongID+9e6; %Jarkus-raai id.
            NCdata.x(k,:)    = temp.line.CS(k).xi; %RD x-coordinates [m RD].
            NCdata.y(k,:)    = temp.line.CS(k).yi; %RD y-coordinates [m RD].
            NCdata.rsp_x(k,1)= temp.line.CS(k).x_origin; %RSP RD-x [m RD].
            NCdata.rsp_y(k,1)= temp.line.CS(k).y_origin; %RSP RD-y [m RD].
            NCdata.angle(k,1)= temp.line.CS(k).angle; %Angle of transect wrt N [deg N].
            NCdata.kind(k,1) = temp.line.CS(k).kind; %Zandmotor (1), Nemo (2), or Nemo_additional (3).
            NCdata.linetype(k,1)=temp.line.CS(k).linetype; % linetype Jarkus (1), Jarkus verdicht (2), or Shore (3).
            NCdata.transectnr(k,1)=k; % Number Shore survey line alongshore (starting south).
%             NCdata.alongshore(k,1)=sqrt((temp.line.CS(k).x_origin-temp.line.CS(1).x_origin).^2 ...
%                                        +(temp.line.CS(k).y_origin-temp.line.CS(1).y_origin).^2)';
%                                    %Alongshore distance form first transect RSP.
            if k==1
                NCdata.dist(:,1) = temp.line.CS(k).dist; %Cross-shore distance from RSP-line [m]
            end
        end
        NCdata.altitude(i,k,:)   = temp.line.CS(k).z_gridded; %Altitude, positive up [m NAP]
        NCdata.interpmask(i,k,:) = temp.line.CS(k).InterpolationMask; % Interpolation {1} or not {0}.
    end
    
    NCdata.time(i)= datenum(XYZ(i).date,'yyyy_mm_dd'); %Timestamp of Zandmotor survey.
    try %Add time nemo survey
        NCdata.time_nemo(i)=datenum(Date_NEMO{i},'yyyy_mm_dd'); %Timestamp of Nemo survey.
    catch
        NCdata.time_nemo(i)=0;
    end
    if OPT.vb
        try %Add time VB survey
            NCdata.time_vb(i)=XYZ_V(i).time; %Timestamp Vlugtenburg survey.
        catch
            NCdata.time_vb(i)=0;
        end
        try
            if NCdata.time_vb(i)~=0
                NCdata.time_vbnemo(i)=XYZ_V(i).time;
            else
                NCdata.time_vbnemo(i)=datenum(Date_NEMO{i},'yyyy_mm_dd');
            end
        catch
            NCdata.time_vbnemo(i)=0;
        end
        if i==1;
            NCdata.kind(94:160)=4;%Nemo OR Vlugtenburg datasource.
        end
    end
end
clear temp XYZ_V XYZ_MB %Clear current temporary struct, and continue...
fprintf('[# 100%% procprog info #] processing completed\n')

%%
NCdata.altitude(isnan(NCdata.altitude))=FillValue;
% Max and min cross shore location with actual data
for i_date=1:length(NCdata.time)
    for i_l=1:length(Surveylines.CS)
        ind=find(squeeze(NCdata.altitude(i_date,i_l,:))~=FillValue);
        if length(ind)>=2
          NCdata.min_cross_shore_measurement(i_date,i_l)=ind(1) ;
          NCdata.max_cross_shore_measurement(i_date,i_l)=ind(end) ;
        else
          NCdata.min_cross_shore_measurement(i_date,i_l)=FillValue ;
          NCdata.max_cross_shore_measurement(i_date,i_l)=FillValue ;
        end
    end
    if OPT.keepraw
        Raw(i_date).time=NCdata.time(i_date);
    end
end

% %Additional time vectors
% NCdata.Jarkus_time= datenum(NCdata.time)     -datenum(1970,1,1); %  time from 1970 as used in Jarkus
% NCdata.Jtime_nemo=  datenum(NCdata.time_nemo)-datenum(1970,1,1); %  time from 1970 as used in Jarkus
% if OPT.vb
%   NCdata.Jtime_vb=    datenum(NCdata.time_vb)  -datenum(1970,1,1); %  time from 1970 as used in Jarkus
% end

%Convert Coordinates from RD to WGS84
[NCdata.lon,NCdata.lat,~]      =convertCoordinates(NCdata.x,    NCdata.y,    'CS1.code',28992,'CS2.code',4326);
[NCdata.rsp_lon,NCdata.rsp_lat]=convertCoordinates(NCdata.rsp_x,NCdata.rsp_y,'CS1.code',28992,'CS2.code',4326);


%% survey paths
NCdata.path_RD=ones(nsurveys,400000,3)*FillValue; % Create empty matrix first, 4e5 points is enough for ZM+Nemo, for MB 1.1e7 is required!
for i_date=1:nsurveys;
    %  XYZ should be in right format;1 row and a lot of columns. If not, transpose fields
    if size(XYZ(i_date).data.XYZ.X,1)~=1
        NCdata.path_RD(i_date,1:length(XYZ(i_date).data.XYZ.X),:)=[ XYZ(i_date).data.XYZ.X XYZ(i_date).data.XYZ.Y XYZ(i_date).data.XYZ.Z];
    else
        NCdata.path_RD(i_date,1:length(XYZ(i_date).data.XYZ.X),:)=[ XYZ(i_date).data.XYZ.X' XYZ(i_date).data.XYZ.Y' XYZ(i_date).data.XYZ.Z'];
    end
end
NCdata.path_RD(isnan(NCdata.path_RD))=FillValue; % Check for remaining nans.
NCdata.path=NCdata.path_RD;

% Path in lon/lat
for i_date=1:nsurveys;
    [NCdata.path(i_date,:,1),NCdata.path(i_date,:,2),~]=convertCoordinates(NCdata.path_RD(i_date,:,1),NCdata.path_RD(i_date,:,2),'CS1.code',28992,'CS2.code',4326);
end
NCdata.path(NCdata.path_RD==FillValue)=FillValue;

clear XYZ
%% Temporary save
%save('NCdata_struct.mat','-struct','NCdata');

%% Save as Matlab-structs
if OPT.save
    fprintf(1,'%s \n','Saving *.mat files');
    %Save raw data separated to transects
    if OPT.keepraw
        save([OPT.outputfolder,'raw_data_combined.mat'],'Raw','-v7.3');
        clear Raw
    end
    
    % Build struct
    D=rmfield(NCdata,{'path_RD','path'});
    fn=fieldnames(D);
    for f=1:length(fn)
        fprintf(1,'%s \n',fn{f});
        D.(fn{f})(D.(fn{f})==FillValue)=nan;
        if isrow(D.(fn{f}))
            D.(fn{f})=D.(fn{f})';
        end
    end
    D.areaname=D.areaname'; %make this a row again...
    D.min_cross_shore_measurement(isnan(D.min_cross_shore_measurement))=1; %Nan or 0 is not accepted as index, therefore default to 1 (where there is never data)
    D.max_cross_shore_measurement(isnan(D.max_cross_shore_measurement))=1; %Nan or 0 is not accepted as index, therefore default to 1 (where there is never data)
    D.alongshore=sqrt((D.rsp_x-D.rsp_x(1)).^2+(D.rsp_y-D.rsp_y(1)).^2); % Distance along RSP-line from 1st transect near HvH.
    save([OPT.outputfolder,'transects_combined.mat'],'-struct','D');
    %if ~OPT.vb;save('./Morfologische data/DL_trans','-struct','D');       end
    %if OPT.vb; save('./Morfologische data/DL_trans_vb','-struct','D');    end
    %if OPT.mb; save('./Morfologische data/DL_trans_alles','-struct','D'); end
    clear D

    % Build struct
    Path=struct('path_RD',NCdata.path_RD,'path',NCdata.path,'time',NCdata.time,'time_nemo',NCdata.time_nemo,...%'Jarkus_time',NCdata.Jarkus_time,...
        'areacode',NCdata.areacode,'areaname',NCdata.areaname);
    fn=fieldnames(Path);
    for f=1:length(fn)
        Path.(fn{f})(Path.(fn{f})==FillValue)=nan;
        if isrow(Path.(fn{f}))
            Path.(fn{f})=Path.(fn{f})';
        end
    end
    save([OPT.outputfolder,'surveypath_combined.mat'],'-struct','Path');
    %if ~OPT.vb;save('./Morfologische data/DL_path','-struct','Path');       end
    %if OPT.vb; save('./Morfologische data/DL_path_vb','-struct','Path');    end
    %if OPT.mb; save('./Morfologische data/DL_path_alles','-struct','Path'); end
    clear Path
    

end
clear Raw D Path temp XYZ XYZ_V XYZ_MB

%% save Netcdf with transect data
if OPT.write_nc
    fprintf(1,'%s \n','Writing transect netCDF');
    %Properties for geospatial coordinate system
    [~,~,CClog]=convertCoordinates(NCdata.rsp_x(1),NCdata.rsp_y(1),'CS1.code',28992,'CS2.code',4326);
    %Set proper dimensions
    NCdata.areacode(1:length(Surveylines.CS),1)=NCdata.areacode(1); %NCdata.areacode=NCdata.areacode';
    %NCdata.areaname(1:length(Surveylines.CS))={'Delfland'}; NCdata.areaname=NCdata.areaname';
    NCdata.areaname(1:length(Surveylines.CS),:)=repmat(NCdata.areaname(1,:),length(Surveylines.CS),1);
    %Add local coordinate system
    [NCdata.L, NCdata.C, NCdata.alongshore, NCdata.cross_shore, NCdata.ls, NCdata.cs] =nemo_build_shorenormalgrid(NCdata);
    %Add RSP alongshore coordinates
    NCdata.RSP=NCdata.id*10-9e7;
    NCdata.binwidth=nemo_binwidth(NCdata);
    %Add jarkus altitude data, mapped to shore grid.
% % %     try
% % %         %Retreives most recent version from openDAP server.
% % %         nc_info('http://opendap.tudelft.nl/thredds/dodsC/data2/deltares/rijkswaterstaat/jarkus/profiles/transect.nc');
% % %         jarkusncpath='http://opendap.tudelft.nl/thredds/dodsC/data2/deltares/rijkswaterstaat/jarkus/profiles/transect.nc';
% % %     catch
% % %         jarkusncpath=input('Path to the Jarkus "transect.nc" file (string): ');
% % %     end
    
    try
        DL=load([OPT.outputdir,'jarkus_delfland.mat']);
    catch
        jarkusncpath=jarkus_url;
        DL=nemo_jarkus(jarkusncpath,9,NCdata.dist);
    end
    NCdata.altitude(NCdata.altitude==FillValue)=nan;
    [NCdata.z_jarkus,NCdata.z_jnz,NCdata.time_jarkus]=nemo_combine_jarkus_shore(NCdata,DL);
    clear DL
    NCdata.altitude(isnan(NCdata.altitude))=FillValue;
    NCdata.z_jarkus(isnan(NCdata.z_jarkus))=FillValue;
    NCdata.z_jnz(isnan(NCdata.z_jnz))=FillValue;
    %Make time vectors in days from 1970-1-1
    fn=fieldnames(NCdata);
    idx=find(strncmpi('time',fn,4)); 
    for n=idx'
        NCdata.(['J',fn{n}])=NCdata.(fn{n})-datenum(1970,1,1); %Days since 1st Jan 1970.
        NCdata.(['J',fn{n}])(NCdata.(['J',fn{n}])<0)=FillValue; %Fill empty slots with FillValue.
        NCdata.(['J',fn{n}])=NCdata.(['J',fn{n}])(:); %Make it a columnvector.
    end

    NcTransectFileName = ['combined_data_delfland_transects_r',datestr(now,'yyyymmdd'),'.nc'];
    NCpath=fullfile(OPT.basepath,'..','NCdata');
    mkdir(NCpath); 
    %nemo_data2netcdf(NCfile,           NCpath,data, ,CClog,OPT,FillValue, rawdataurl, varargin)
    nemo_data2netcdf(NcTransectFileName,NCpath,NCdata,CClog,OPT,FillValue, rawdataurl, 'overwrite', true)
    
    fprintf(1,'%s \n','Writing surveypath netCDF');
    % save Netcdf with surveypath
    NCpathFileName = ['combined_data_delfland_surveypath_r',datestr(now,'yyyymmdd'),'.nc'];
    %nemo_build_pathNetCDF(NCpathfile,NCpath,NCdata.time,NCdata.path,NCdata.path_RD,CClog, rawdataurl, 'overwrite', false);
    nemo_surveypath2netcdf(NCpathFileName,NCpath,NCdata.time,NCdata.path,NCdata.path_RD,CClog, rawdataurl, 'overwrite', true);
end

fprintf(1,'Done! \n');
%EOF