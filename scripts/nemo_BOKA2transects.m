%NEMO_BOKA2TRANSECTS Interpolates construction surveys to transects.
%
% Uses:
% nemo_Schematize_data,
% nemo_extract_line_Shore,
% nemo_data2netcdf,
% nemo_path2netcdf,
% convertCoordinates (Open Earth Tools package (OET))
% OpenEarthTools
%
% Shore Monitoring & Reseach, Jan 2014
% info@shoremonitoring.nl
% Adapted by Bart Roest, Okt 2016, Okt 2017
% l.w.m.roest@tudelft.nl
%
% See also: nemo_Schematize_data, nemo_extract_line_Shore, CreateZMtransectNetCDF, CreateZMpathNetCDF, convertCoordinates.

% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% $Id: $
% $Date: $
% $Author: $
% $Revision: $
% $HeadURL: $
% $Keywords: $

%clear all
%close all
%clc
%% INPUT VARS
%basepath=OPT.basepath; %Path to the folder with raw data (containing individual folders with surveys).

dist_perpendicular=2.5; %Distance perpendicular from transect to look for points
max_dist_cs=5; %Interpolation treshold between raw data and interpolated positions.
altswitch=false; %[true|false] Interpolate 'short' ZM-transects to 'long' ZM-transects. Introduces small interpolation errors but improves volume calculations!


% Initiate NetCDF Transects
FillValue=-9999;  % number to be used to fill the data gaps in NetCDF file (similar to Jarkus)
NCdata.areacode=9; % Delfland!
NCdata.areaname='Delfland';

%% /INPUT VARS
%% PRE-PROCESSING
% load file with the surveylines definitions
%load([basepath,'..\scripts\matlab\Surveylines_Delfland'],'Surveylines'); % 5m CS-spacing
load('Surveylines_Delfland.mat','Surveylines');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Any .mat-file containing the same fields as "Surveylines_Delfland" should
%work for interpolation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select the folder waar de QC-ed XYZ.mat files staan
QC_dir=fullfile([OPT.basepath,'..\..\construction\raw\survey\']); %BOKA-surveys
QC_files = dir2(QC_dir,'no_dirs', true,'file_incl','\.mat$');
nsurveys=length(QC_files);
svninfo = svn_info(QC_dir);
rawdataurl = svninfo.url;

%% Load Surveys and interpolate to Transects
for i=1:nsurveys %For the number of ZM surveys, ZM is leading in determining the index, other cojoining surveys are appended.
    %LOAD ZM_SURVEY

    fprintf('[# %.1f%% procprog info #] processing survey %2.0f of %2.0f\n', (i-1)/nsurveys*100, i, nsurveys);
    T.data = load(fullfile(QC_files(i).pathname, QC_files(i).name));
    fnames = fieldnames(T.data);
    if ~any(strcmp(fnames, 'XYZ'))
        % assume that fieldname is the first available field
        monthname = fnames{1};
        datafieldnames = fieldnames(T.data.(monthname));
        xfieldname = datafieldnames{strcmpi(fieldnames(T.data.(monthname))', 'x')};
        T.data.XYZ.X = T.data.(monthname).(xfieldname);
        yfieldname = datafieldnames{strcmpi(fieldnames(T.data.(monthname))', 'y')};
        T.data.XYZ.Y = T.data.(monthname).(yfieldname);
        zfieldname = datafieldnames{strcmpi(fieldnames(T.data.(monthname))', 'z')};
        T.data.XYZ.Z = T.data.(monthname).(zfieldname);
    end
    T.date=T.data.XYZ.time;
    T.data.XYZ=rmfield(T.data.XYZ,{'time','zi'});
    
    %END LOAD ZM_SURVEY
    
%%% INTERPOLATE AND SCHEMATIZE DATA
    %temp = nemo_Schematize_data(Surveylines,XYZ(i).data.XYZ,10,7.5); %NORMAL
    temp = nemo_Schematize_data(Surveylines,T.data.XYZ,dist_perpendicular,max_dist_cs,i,altswitch);
%%% END INTERPOLATION
    
    for k=1:length(temp.line.CS) %Write data to struct.
        if i==1
            NCdata.id(k,1)   = temp.line.CS(k).JarkusAlongID+9e6; %Jarkus-raai id.
            NCdata.x(k,:)    = temp.line.CS(k).xi; %RD x-coordinates.
            NCdata.y(k,:)    = temp.line.CS(k).yi; %RD y-coordinates.
            NCdata.rsp_x(k,1)= temp.line.CS(k).x_origin; %RSP RD-x.
            NCdata.rsp_y(k,1)= temp.line.CS(k).y_origin; %RSP RD-y.
            NCdata.angle(k,1)= temp.line.CS(k).angle; %Angle of transect wrt N.
            NCdata.kind(k,1) = temp.line.CS(k).kind; %Zandmotor (1), Nemo (2), or Nemo_additional (3).
            NCdata.linetype(k,1)=temp.line.CS(k).linetype; % linetype Jarkus (1), Jarkus verdicht (2), or Shore (3).
            NCdata.transectnr(k,1)=k; % Number Shore survey line alongshore (starting south).
            if k==1
                NCdata.dist(:,1) = temp.line.CS(k).dist;
            end
        end
        NCdata.altitude(i,k,:)   = temp.line.CS(k).z_gridded;
        NCdata.interpmask(i,k,:) = temp.line.CS(k).InterpolationMask;
    end
    NCdata.time(i)= T.date;
    clear temp
    clear T
end
fprintf('[# 100%% procprog info #] processing completed\n')

%%
NCdata.altitude(isnan(NCdata.altitude))=FillValue;
% Max and min cross shore location with actual data
for i_date=1:length(NCdata.time)
    for i_l=1:length(Surveylines.CS)
        ind=find(squeeze(NCdata.altitude(i_date,i_l,:))~=FillValue);
        if length(ind)>=1
          NCdata.min_cross_shore_measurement(i_date,i_l)=ind(1) ;
          NCdata.max_cross_shore_measurement(i_date,i_l)=ind(end) ;
        else
          NCdata.min_cross_shore_measurement(i_date,i_l)=FillValue ;
          NCdata.max_cross_shore_measurement(i_date,i_l)=FillValue ;
        end
    end
end

%Convert Coordinates from RD to WGS84
[NCdata.lon,NCdata.lat,~]      =convertCoordinates(NCdata.x,    NCdata.y,    'CS1.code',28992,'CS2.code',4326);
[NCdata.rsp_lon,NCdata.rsp_lat]=convertCoordinates(NCdata.rsp_x,NCdata.rsp_y,'CS1.code',28992,'CS2.code',4326);

%% survey paths
% % % NCdata.path_RD=ones(nsurveys,400000,3)*FillValue; % Create empty matrix first, 4e5 points is enough for ZM+Nemo, for MB 1.1e7 is required!
% % % for i_date=1:nsurveys;
% % %     %  XYZ should be in right format;1 row and a lot of columns. If not, transpose fields
% % %     if size(XYZ(i_date).data.XYZ.X,1)~=1
% % %         NCdata.path_RD(i_date,1:length(XYZ(i_date).data.XYZ.X),:)=[ XYZ(i_date).data.XYZ.X XYZ(i_date).data.XYZ.Y XYZ(i_date).data.XYZ.Z];
% % %     else
% % %         NCdata.path_RD(i_date,1:length(XYZ(i_date).data.XYZ.X),:)=[ XYZ(i_date).data.XYZ.X' XYZ(i_date).data.XYZ.Y' XYZ(i_date).data.XYZ.Z'];
% % %     end
% % % end
% % % NCdata.path_RD(isnan(NCdata.path_RD))=FillValue; % Check for remaining nans.
% % % NCdata.path=NCdata.path_RD;
% % % 
% % % % Path in lon/lat
% % % for i_date=1:nsurveys;
% % %     [NCdata.path(i_date,:,1),NCdata.path(i_date,:,2),~]=convertCoordinates(NCdata.path_RD(i_date,:,1),NCdata.path_RD(i_date,:,2),'CS1.code',28992,'CS2.code',4326);
% % % end
% % % NCdata.path(NCdata.path_RD==FillValue)=FillValue;


%% Temporary save
save('NCdata_boka.mat','-struct','NCdata');

%% Save as Matlab-structs
if 1
    fprintf(1,'%s \n','Saving *.mat files');
% %     %Save raw data separated to transects
% %     save([basepath,'..\NCdata\raw_data_combined'],'Raw','-v7.3');
% %     clear Raw
    
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
        D.min_cross_shore_measurement(isnan(D.min_cross_shore_measurement))=1; %Nan is not accepted as index, therefore default to 1 (where there is never data)
        D.max_cross_shore_measurement(isnan(D.max_cross_shore_measurement))=1; %Nan is not accepted as index, therefore default to 1 (where there is never data)
        D.alongshore=sqrt((D.rsp_x-D.rsp_x(1)).^2+(D.rsp_y-D.rsp_y(1)).^2);
    save('BOKA_INTERP','D');
    %save('./Morfologische data/DL_trans_fine','-struct','D');
    %save([basepath,'..\NCdata\transects_combined.mat'],'-struct','D');
    %if ~OPT.vb;save('./Morfologische data/DL_trans','-struct','D');       end
    %if OPT.vb; save('./Morfologische data/DL_trans_vb','-struct','D');    end
    %if OPT.mb; save('./Morfologische data/DL_trans_alles','-struct','D'); end
    clear D

%     % Build struct
%     Path=struct('path_RD',NCdata.path_RD,'path',NCdata.path,'time',NCdata.time,'time_nemo',NCdata.time_nemo,'Jarkus_time',NCdata.Jarkus_time,...
%         'areacode',NCdata.areacode,'areaname',NCdata.areaname);
%     fn=fieldnames(Path);
%     for f=1:length(fn)
%         Path.(fn{f})(Path.(fn{f})==FillValue)=nan;
%         if isrow(Path.(fn{f}))
%             Path.(fn{f})=Path.(fn{f})';
%         end
%     end
%     save([basepath,'..\NCdata\surveypath_combined.mat'],'-struct','Path');
%     %if ~OPT.vb;save('./Morfologische data/DL_path','-struct','Path');       end
%     %if OPT.vb; save('./Morfologische data/DL_path_vb','-struct','Path');    end
%     %if OPT.mb; save('./Morfologische data/DL_path_alles','-struct','Path'); end
%     clear Path
%     

end

%% save Netcdf with transect data
% % % % if OPT.write_nc
% % % %     fprintf(1,'%s \n','Writing transect netCDF');
% % % %     %Properties for geospatial coordinate system
% % % %     [~,~,CClog]=convertCoordinates(0,0,'CS1.code',28992,'CS2.code',4326);
% % % %     %Set proper dimensions
% % % %     NCdata.areacode(1:length(Surveylines.CS))=NCdata.areacode(1); NCdata.areacode=NCdata.areacode';
% % % %     %NCdata.areaname(1:length(Surveylines.CS))={'Delfland'}; NCdata.areaname=NCdata.areaname';
% % % %     NCdata.areaname(1:length(Surveylines.CS),:)=repmat(NCdata.areaname,length(Surveylines.CS),1);
% % % %     %Add local coordinate system
% % % %     [NCdata.L, NCdata.C, NCdata.alongshore,  NCdata.dist, NCdata.ls, NCdata.cs] =nemo_build_shorenormalgrid(NCdata);
% % % %     %Add RSP alongshore coordinates
% % % %     NCdata.RSP=NCdata.id*10-9e7;
% % % %     %Add jarkus altitude data, mapped to shore grid.
% % % %     jarkusncpath=input('Path for Jarkus transect.nc (string): ');
% % % %     DL=nemo_jarkus(jarkusncpath,9);
% % % %     NCdata.altitude(NCdata.altitude==FillValue)=nan;
% % % %     [NCdata.z_jarkus,NCdata.z_jnz,NCdata.time_jarkus]=nemo_combine_jarkus_shore(NCdata,DL);
% % % %     NCdata.altitude(isnan(NCdata.altitude))=FillValue;
% % % %     NCdata.z_jarkus(isnan(NCdata.z_jarkus))=FillValue;
% % % %     NCdata.z_jnz(isnan(NCdata.z_jnz))=FillValue;
% % % %     %Make time vectors in days from 1970-1-1
% % % %     fn=fieldnames(NCdata);
% % % %     idx=find(strncmpi('time',fn,4)); 
% % % %     for n=idx'; 
% % % %         NCdata.(['J',fn{n}])=NCdata.(fn{n})-datenum(1970,1,1); 
% % % %         NCdata.(['J',fn{n}])(NCdata.(['J',fn{n}])<0)=FillValue;
% % % %         NCdata.(['J',fn{n}])=NCdata.(['J',fn{n}])(:);
% % % %     end
% % % % 
% % % %     NcTransectFileName = 'combined_data_delfland_transects.nc';
% % % %     NCpath=fullfile(basepath,'..','NCdata');
% % % %     mkpath(NCpath); 
% % % %     %nemo_data2netcdf(NCfile,           NCpath,data, ,CClog,OPT,FillValue, rawdataurl, varargin)
% % % %     nemo_data2netcdf(NcTransectFileName,NCpath,NCdata,CClog,OPT,FillValue, rawdataurl, 'overwrite', false)
% % % %     
% % % %     fprintf(1,'%s \n','Writing surveypath netCDF');
% % % %     % save Netcdf with surveypath
% % % %     NCpathFile = 'combined_data_delfland_surveypath.nc';
% % % %     %nemo_build_pathNetCDF(NCpathfile,NCpath,NCdata.time,NCdata.Jarkus_time,NCdata.path,NCdata.path_RD,CClog, rawdataurl, 'overwrite', false);
% % % %     nemo_surveypath2netcdf(NCpathFile,NCpath,NCdata.time,NCdata.Jarkus_time,NCdata.path,NCdata.path_RD,CClog, rawdataurl, 'overwrite', false);
% % % % end
%EOF