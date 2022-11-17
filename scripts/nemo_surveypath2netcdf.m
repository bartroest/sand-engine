function nemo_surveypath2netcdf(NCfile,NCpath,time,path_LL,path_RD,OPT, rawdataurl, varargin)
%NEMO_SURVEYPATH2NETCDF writes survey-path xyz-data to a netCDF file.
%
%   Exports the combined surveypath data of Nemo, Zandmotor and Vlugtenburg
%   to a NetCDF file.
%
%   Syntax:
%   nemo_surveypath2netcdf(NCfile,NCpath,time,path,path_RD,OPT, rawdataurl, varargin)
%
%   Input: 
%       NCfile: NetCDF filename to write to.
%       NCpath: path to NCfile
%       path_LL: surveypath WGS'84
%       path_RD: surveypath Rijksdriehoek
%       OPT: Nemo Options structure
%       rawdataurl: url to find the raw data
%
%   Output:
%   	NetCDF file.
%
%   Example:
%       nemo_surveypath2netcdf(NCpathFileName,NCpath,NCdata.time,NCdata.path,...
%           NCdata.path_RD,CClog, rawdataurl, 'overwrite', true);
%
%   See also: nemo, nemo_raw2transects, nemo_surveypath2netcdf

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

optargs = struct('overwrite', false);
optargs = setproperty(optargs, varargin);

%% ------------------ Zm path NETCDF
NCpathfile = fullfile(NCpath, NCfile);

%%%%%%%%%%%
%%% Make new NetCDF file
%%%%%%%%%%%
if exist(NCpathfile, 'file')
    if optargs.overwrite == false
        % ask user to confirm that file will be overwritten
        fprintf(1,'%s already exists.\n',NCpathfile);
        reply = input(sprintf('Are you sure you want to create or overwrite it? y/n : '), 's');
    else
        % option 'overwrite' == true, so interprete as a "yes"
        reply = 'y';
    end
    
    if isempty(reply) || reply~='y'
        error('%s.m stopped', mfilename)
    else
        delete(NCpathfile)
        fprintf('"%s"\n as resulted from previous run deleted \n', NCpathfile)
    end
    
end
STRINGSIZE = 100;
nc_create_empty(NCpathfile);  % Create a new empty netcdf file.
nc_padheader (NCpathfile, 400000 );   %     make sure there's enough space for headers. This will speed up
%     putting attributes

fprintf('Starting to create\n "%s"\n', NCpathfile)

FillValue=-9999;  % number to be used to fill the data gaps in NetCDF file (similar to Jarkus)

%% Put global attributes      
nc_attput(NCpathfile, nc_global, 'naming_authority', 'shoremonitoring.nl');
nc_attput(NCpathfile, nc_global, 'Metadata_Conventions', 'CF-1.4');  
nc_attput(NCpathfile, nc_global, 'id', ['morphology_surveypaths_delfland_' datestr(nowutc,'yyyymmdd')]);
nc_attput(NCpathfile, nc_global, 'title', 'Delfland Topographic Survey, actual surveyed paths');
nc_attput(NCpathfile, nc_global, 'summary', 'Bathymetry and topography at the Zandmotor after construction');
nc_attput(NCpathfile, nc_global, 'keywords', 'Bathymetry');
nc_attput(NCpathfile, nc_global, 'keywords_vocabulary', 'http://www.eionet.europa.eu/gemet');
nc_attput(NCpathfile, nc_global, 'standard_name_vocabulary', 'http://cf-pcmdi.llnl.gov/documents/cf-standard-names/');
nc_attput(NCpathfile, nc_global, 'history'    , ['Data surveyed by Shore Monitoring and Research, converted to netCDF on ' datestr(nowutc,'yyyy-mm-dd')]);    
nc_attput(NCpathfile, nc_global, 'institution', 'Shore Monitoring and Research & Technische Universiteit Delft');
nc_attput(NCpathfile, nc_global, 'cdm_data_type','trajectory'); 
nc_attput(NCpathfile, nc_global, 'acknowledgment','This data is collected with financial support within the ERC advanced grant 291206-NEMO and NatureCoast, a Perspectief project of technology foundation STW, applied science division of NWO. Additional support is provided by the Dutch Ministry of Infrastructure and the Environment (Rijkswaterstaat), the Province of South-Holland, the European Fund for Regional Development EFRO and EcoShape/Building with Nature.');
nc_attput(NCpathfile, nc_global, 'creator_name',       'L. Roest, R. de Zeeuw, M. de Schipper, S. de Vries ');
nc_attput(NCpathfile, nc_global, 'creator_url',        'https://www.shoremonitoring.nl and https://www.tudelft.nl');
nc_attput(NCpathfile, nc_global, 'creator_email',      'l.w.m.roest@tudelft.nl, roeland@shoremonitoring.nl, m.a.deschipper@tudelft.nl, sierd.devries@tudelft.nl');
fmt = 'yyyy-mm-ddTHH:MMZ';
nc_attput(NCpathfile, nc_global, 'date_created',       datestr(nowutc, fmt));
nc_attput(NCpathfile, nc_global, 'date_modified',      datestr(nowutc, fmt));
nc_attput(NCpathfile, nc_global, 'date_issued',        datestr(nowutc, fmt));
nc_attput(NCpathfile, nc_global, 'publisher_name',     'L.W.M. Roest');
nc_attput(NCpathfile, nc_global, 'publisher_url',      'https://www.tudelft.nl');
nc_attput(NCpathfile, nc_global, 'publisher_email',    'l.w.m.roest@tudelft.nl');
nc_attput(NCpathfile, nc_global, 'processing_level',   'final');
nc_attput(NCpathfile, nc_global, 'license',            'DISCLAIMER: This data is made available in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'); 
nc_attput(NCpathfile, nc_global, 'geospatial_lon_units','degrees_east') 
temp=squeeze(path_LL(:,:,1)); %lon; 
nc_attput(NCpathfile, nc_global, 'geospatial_lon_min', min(temp(temp>0)) );
nc_attput(NCpathfile, nc_global, 'geospatial_lon_max', max(temp(temp>0)) );
nc_attput(NCpathfile, nc_global, 'geospatial_lat_units','degrees_north') 
temp=squeeze(path_LL(:,:,2)); %lat 
nc_attput(NCpathfile, nc_global, 'geospatial_lat_min', min(temp(temp>0)) );
nc_attput(NCpathfile, nc_global, 'geospatial_lat_max', max(temp(temp>0)) );
nc_attput(NCpathfile, nc_global, 'geospatial_vertical_units','m'); 
nc_attput(NCpathfile, nc_global, 'geospatial_vertical_positive','up'); 
temp=squeeze(path_LL(:,:,3)); %height
nc_attput(NCpathfile, nc_global, 'geospatial_vertical_min', min(temp(temp>-100)) );
nc_attput(NCpathfile, nc_global, 'geospatial_vertical_max', max(temp(temp>-100)) );
nc_attput(NCpathfile, nc_global, 'time_coverage_units','days since 1970-01-01'); 
nc_attput(NCpathfile, nc_global, 'Unlimited_Dimension','time'); 
nc_attput(NCpathfile, nc_global, 'dim16','16'); 

nc_attput(NCpathfile, nc_global, 'source'     , 'Combined Ski, Quad and Walking measurements');
nc_attput(NCpathfile, nc_global, 'references' , sprintf(['Original source: Shore Monitoring and Research\n' ...
                                                    'Zandmotor data storage: http://data.4tu.nl/repository/collection:zandmotor ,\n' ...
                                                    'Converted with script with: nemo_surveypath2netcdf.m'],  rawdataurl));


%% build NetCDF file
fprintf('Adding dimensions to Netcdf\n')
nc_add_dimension(NCpathfile, 'time',            length(time))
nc_add_dimension(NCpathfile, 'survey_path',     size(path_LL,2))
nc_add_dimension(NCpathfile, 'survey_path_dim', size(path_LL,3))
nc_add_dimension(NCpathfile, 'stringsize' ,     STRINGSIZE)

s.Name      = 'time';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time', 'T', 'days since 1970-01-01', 'measurement date'});
nc_addvar(NCpathfile , s);


% %%% NEW!!! date of the survey in string format
% % s.Name      = 'timestring';
% % s.Nctype    = nc_char;
% % s.Dimension = {'time','stringsize'};
% % s.Attribute = struct('Name', {'standard_name', 'units', 'comment', 'axis'}, ...
% %     'Value', {'time', 'year', 'survey date', 'dd-mm-yyyy'});
% % nc_addvar(NCpathfile , s);

% EPSG
    s.Name      = 'epsg';
    s.Nctype    = nc_int;
    s.Dimension = {};
    s.Attribute = struct('Name', ...
       {'grid_mapping_name', ...
        'semi_major_axis', ...
        'semi_minor_axis', ...
        'inverse_flattening', ...
        'latitude_of_projection_origin', ...
        'longitude_of_projection_origin', ...
        'false_easting', ...
        'false_northing', ...
        'scale_factor_at_projection_origin',...
        'comment'}, ...
        'Value', ...
        {OPT.proj_conv1.method.name,    ...
        OPT.CS1.ellips.semi_major_axis, ...
        OPT.CS1.ellips.semi_minor_axis, ...
        OPT.CS1.ellips.inv_flattening,  ...
        OPT.proj_conv1.param.value(strcmp(OPT.proj_conv1.param.name,'Latitude of natural origin'    )), ...
        OPT.proj_conv1.param.value(strcmp(OPT.proj_conv1.param.name,'Longitude of natural origin'   )),...
        OPT.proj_conv1.param.value(strcmp(OPT.proj_conv1.param.name,'False easting'                 )),...
        OPT.proj_conv1.param.value(strcmp(OPT.proj_conv1.param.name,'False northing'                )),...
        OPT.proj_conv1.param.value(strcmp(OPT.proj_conv1.param.name,'Scale factor at natural origin')),...
        'value is equal to EPSG code'});
nc_addvar(NCpathfile, s);

    % NEW!! Survey path
s.Name      = 'survey_path';
s.Nctype    = nc_double;
s.Dimension = {'time','survey_path','survey_path_dim'};
s.Attribute = struct('Name', {'standard_name', 'units', 'comment', 'coordinates', 'survey_type' ,'_FillValue'}, ...
    'Value', {'survey_path', 'm', 'XYZ coordinates of survey path', 'lon / lat / NAP', 'Combined Jetski, Quad and Walking' , FillValue});
nc_addvar(NCpathfile , s);

% NEW!! Survey path
s.Name      = 'survey_path_RD';
s.Nctype    = nc_double;
s.Dimension = {'time','survey_path','survey_path_dim'};
s.Attribute = struct('Name', {'standard_name', 'units', 'comment', 'coordinates', 'survey_type' ,'_FillValue'}, ...
    'Value', {'survey_path', 'm', 'XYZ coordinates of survey path', 'Dutch Coordinate system RDNAP', 'Combined Jetski, Quad and Walking' , FillValue});
nc_addvar(NCpathfile , s);

fprintf('Write data to Netcdf \n');
nc_varput(NCpathfile , 'time', time-datenum(1970,1,1)); % time from 1970 as used in Jarkus
% % nc_varput(NCpathfile , 'timestring', datestr(time','dd-mm-yyyy')) 
nc_varput(NCpathfile , 'epsg', OPT.CS1.code);
nc_varput(NCpathfile , 'survey_path', path_LL);
nc_varput(NCpathfile , 'survey_path_RD', path_RD);

fprintf('"%s"\n netcdf writing process completed\n', fullfile(NCpathfile));
%EOF
