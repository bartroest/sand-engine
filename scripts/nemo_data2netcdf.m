function nemo_data2netcdf(NCfile,NCpath,data,CClog,OPT,FillValue, rawdataurl, varargin)
%NEMO_DATA2NETCDF Exports Delfland combined transect data to NetCDF.
%
%   Exports the combined and schematised data of Nemo, Zandmotor and Vlugtenburg
%   to a NetCDF file.
%
%   Syntax:
%   nemo_data2netcdf(NCfile,NCpath,data,CClog,OPT,FillValue, rawdataurl, varargin)
%
%   Input: 
%       NCfile: NetCDF filename to write to.
%       NCpath: path to NCfile
%       data: transect datastruct
%       CClog: logfiles of convertCoordinates
%       OPT: Nemo Options structure
%       FillValue: NC empty value
%       rawdataurl: url to find the raw data
%
%   Output:
%   	NetCDF file.
%
%   Example:
%       nemo_data2netcdf(NcTransectFileName,NCpath,NCdata,CClog,OPT,...
%           FillValue, rawdataurl, 'overwrite', true);
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

optargs = struct('overwrite', false);
optargs = setproperty(optargs, varargin);

%% ------------------ Zm path NETCDF
NcTransectFile = fullfile(NCpath, NCfile);

%%%%%%%%%%%
%%% Make new NetCDF file
%%%%%%%%%%%
if exist(NcTransectFile, 'file')
    if optargs.overwrite == false
        % ask user to confirm that file will be overwritten
        reply = input(sprintf('Are you sure you want to create or overwrite: \n "%s"? y/n : ', NcTransectFile), 's');
    else
        % option 'overwrite' == true, so interprete as a "yes"
        reply = 'y';
    end
    
    if isempty(reply) || reply~='y'
        error('%s.m stopped', mfilename)
    else
        delete(NcTransectFile)
        fprintf('"%s"\n as resulted from previous run deleted \n', NcTransectFile)
    end
    
end

STRINGSIZE = 100;
nc_create_empty(NcTransectFile);  % Create a new empty netcdf file.
nc_padheader ( NcTransectFile, 400000 );   %     make sure there's enough space for headers. This will speed up
%     putting attributes


fprintf('Starting to create\n "%s"\n', NcTransectFile)

%% Put global attributes    
nc_attput( NcTransectFile, nc_global, 'naming_authority',       'shoremonitoring.nl');    
nc_attput( NcTransectFile, nc_global, 'Metadata_Conventions',   'CF-1.4'); 
nc_attput( NcTransectFile, nc_global, 'id',                     ['morphology_surveys_delfland_' datestr(nowutc,'yyyymmdd')]);
nc_attput( NcTransectFile, nc_global, 'title',                  'Delfland Topographic Survey, schematized to cross-shore transects');
nc_attput( NcTransectFile, nc_global, 'summary',                'Bathymetry and topography of the whole Delfland coast after Zandmotor construction');
nc_attput( NcTransectFile, nc_global, 'keywords',               'Bathymetry');
nc_attput( NcTransectFile, nc_global, 'keywords_vocabulary',    'http://www.eionet.europa.eu/gemet');
nc_attput( NcTransectFile, nc_global, 'standard_name_vocabulary', 'http://cf-pcmdi.llnl.gov/documents/cf-standard-names/');
nc_attput( NcTransectFile, nc_global, 'history'    ,            ['Data surveyed by Shore Monitoring and Research, converted to netCDF on ' datestr(nowutc,'yyyy-mm-dd')]);    
nc_attput( NcTransectFile, nc_global, 'institution',            'Shore Monitoring & Research and Technische Universiteit Delft');
nc_attput( NcTransectFile, nc_global, 'cdm_data_type',          'grid'); 
nc_attput( NcTransectFile, nc_global, 'acknowledgment',         'This data is collected with financial support within the ERC advanced grant 291206-NEMO and NatureCoast, a Perspectief project of technology foundation STW, applied science division of NWO. Additional support is provided by the Dutch Ministry of Infrastructure and the Environment (Rijkswaterstaat), the Province of South-Holland, the European Fund for Regional Development EFRO and EcoShape/Building with Nature.');
nc_attput( NcTransectFile, nc_global, 'creator_name',           'L. Roest, R. de Zeeuw, M. de Schipper, S. de Vries');
nc_attput( NcTransectFile, nc_global, 'creator_url',            'https://www.shoremonitoring.nl and https://www.tudelft.nl');
nc_attput( NcTransectFile, nc_global, 'creator_email',          'l.w.m.roest@tudelft.nl, roeland@shoremonitoring.nl, m.a.deschipper@tudelft.nl, sierd.devries@tudelft.nl');
fmt = 'yyyy-mm-ddTHH:MMZ';
nc_attput( NcTransectFile, nc_global, 'date_created',           datestr(nowutc, fmt));
nc_attput( NcTransectFile, nc_global, 'date_modified',          datestr(nowutc, fmt));
nc_attput( NcTransectFile, nc_global, 'date_issued',            datestr(nowutc, fmt));
nc_attput( NcTransectFile, nc_global, 'publisher_name',         'L.W.M. Roest');
nc_attput( NcTransectFile, nc_global, 'publisher_url',          'https://www.tudelft.nl');
nc_attput( NcTransectFile, nc_global, 'publisher_email',        'l.w.m.roest@tudelft.nl');
nc_attput( NcTransectFile, nc_global, 'processing_level',       'final');
nc_attput( NcTransectFile, nc_global, 'license',                'DISCLAIMER: This data is made available in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'); 
nc_attput( NcTransectFile, nc_global, 'geospatial_lon_units',   'degrees_east') 
nc_attput( NcTransectFile, nc_global, 'geospatial_lon_min',     min(data.lon(:)) );
nc_attput( NcTransectFile, nc_global, 'geospatial_lon_max',     max(data.lon(:)) );
nc_attput( NcTransectFile, nc_global, 'geospatial_lat_units',   'degrees_north') 
nc_attput( NcTransectFile, nc_global, 'geospatial_lat_min',     min(data.lat(:)) );
nc_attput( NcTransectFile, nc_global, 'geospatial_lat_max',     max(data.lat(:)) );
nc_attput( NcTransectFile, nc_global, 'geospatial_vertical_units','m'); 
nc_attput( NcTransectFile, nc_global, 'geospatial_vertical_positive','up'); 
nc_attput( NcTransectFile, nc_global, 'geospatial_vertical_min', min(data.altitude(data.altitude>FillValue)) );
nc_attput( NcTransectFile, nc_global, 'geospatial_vertical_max', max(data.altitude(:)) );
nc_attput( NcTransectFile, nc_global, 'time_coverage_units',    'days since 1970-01-01'); 
nc_attput( NcTransectFile, nc_global, 'Unlimited_Dimension',    'time'); 
nc_attput( NcTransectFile, nc_global, 'dim16',                  '16'); 

nc_attput( NcTransectFile, nc_global, 'source'     ,            'Combined Jetski, Quad and Walking RTK-GPS-measurements');
nc_attput( NcTransectFile, nc_global, 'references' , sprintf(['Original source: Shore Monitoring and Research,\n' ...
                                                    'Zandmotor data storage: http://data.4tu.nl/repository/collection:zandmotor ,\n' ...
                                                    'Converted with script with: nemo_data2netcdf.m'],  rawdataurl));
   

%% build NetCDF file
fprintf('Adding dimensions to Netcdf \n')
%%% Add dimensions
nc_add_dimension(NcTransectFile, 'alongshore', size(data.altitude,2))
nc_add_dimension(NcTransectFile, 'cross_shore',size(data.altitude,3))
nc_add_dimension(NcTransectFile, 'time',       size(data.altitude,1))
nc_add_dimension(NcTransectFile, 'stringsize', STRINGSIZE)
%
%%%% Add variables

fprintf('Adding variables to Netcdf \n')
%%% id
s.Name      = 'id';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name',  'comment', 'axis'}, ...
    'Value', {'identifier', 'sum of area code (x1000000) and alongshore RSP-coordinate', 'X'});
nc_addvar(NcTransectFile, s);

%%% areacode
s.Name      = 'areacode';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name',  'comment', 'axis'}, ...
    'Value', {'area code', 'codes for the 15 coastal areas as defined by Rijkswaterstaat', 'X'});
nc_addvar(NcTransectFile, s);

%%% areaname
s.Name      = 'areaname';
s.Nctype    = nc_char;
s.Dimension = {'alongshore','stringsize'};
s.Attribute = struct('Name', {'long_name',  'comment', 'axis'}, ...
    'Value', {'area name', 'names for the 15 coastal areas as defined by Rijkswaterstaat', 'X'});
nc_addvar(NcTransectFile, s);

s.Name      = 'rsp';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'units', 'comment', 'axis'}, ...
    'Value', {'alongshore coordinate', 'm', 'alongshore coordinate within the 15 coastal areas as defined by Rijkswaterstaat. To be used with "cross_shore".', 'X'});
nc_addvar(NcTransectFile, s);

s.Name      = 'alongshore';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'units', 'comment', 'axis'}, ...
    'Value', {'alongshore coordinate', 'm', 'local coordinate along the rsp-line, positive North. To be used with "cross_shore".', 'X'});
nc_addvar(NcTransectFile, s);

s.Name      = 'cross_shore';
s.Nctype    = nc_double;
s.Dimension = {'cross_shore'};
s.Attribute = struct('Name', {'long_name', 'units', 'comment', 'axis'}, ...
    'Value', {'cross-shore coordinate', 'm', 'cross-shore coordinate relative to the rsp (rijks strand paal), To be used with "rsp" or "alongshore".', 'Y'});
nc_addvar(NcTransectFile, s);

s.Name      = 'time';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time', 'T', 'days since 1970-01-01 00:00 +1:00', 'measurement date transects Zandmotor area'});
nc_addvar(NcTransectFile, s);

s.Name      = 'time_nemo';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time_nemo', 'T', 'days since 1970-01-01 00:00 +1:00', 'measurement date transects in Nemo area'});
nc_addvar(NcTransectFile, s);

if OPT.vb
s.Name      = 'time_vbnemo';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time_vbnemo', 'T', 'days since 1970-01-01 00:00 +1:00', 'measurement date transects in Vlugtenburg area'});
nc_addvar(NcTransectFile, s);

s.Name      = 'time_vb';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time_vb', 'T', 'days since 1970-01-01 00:00 +1:00', 'measurement date transects in Vlugtenburg area'});
nc_addvar(NcTransectFile, s);
end

s.Name      = 'time_jarkus';
s.Nctype    = nc_double;
s.Dimension = {'time'};
s.Attribute = struct('Name', {'standard_name', 'axis', 'units', 'comment'}, ...
    'Value', {'time_vb', 'T', 'days since 1970-01-01 00:00 +1:00', 'measurement date bathymetry of Jarkus transects'});
nc_addvar(NcTransectFile, s);

s.Name      = 'angle';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'units', 'comment', 'Axis'}, ...
    'Value', {'angle of transect', 'degrees', 'positive clockwise 0 North', 'X'});
nc_addvar(NcTransectFile, s);

s.Name      = 'rsp_x';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'units','axis', 'comment'}, ...
    'Value', {'location for beach pole', 'm', 'X','Location of the beach pole (Rijks strand paal)'});
nc_addvar(NcTransectFile, s);

s.Name      = 'rsp_y';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'units','axis', 'comment'}, ...
    'Value', {'location for beach pole', 'm', 'Y','Location of the beach pole (Rijks strand paal)'});
nc_addvar(NcTransectFile, s);

s.Name      = 'x';
s.Nctype    = nc_double;
s.Dimension = {'alongshore','cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes', 'standard_name','units','axis','comment'}, ...
    'Value', {'alongshore cross_shore ', 'projection_x_coordinate', 'm','X','To be used with "y".'});
nc_addvar(NcTransectFile, s);
        
s.Name      = 'y';
s.Nctype    = nc_double;
s.Dimension = {'alongshore','cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes', 'standard_name','units','axis','comment'}, ...
    'Value', {'alongshore cross_shore ', 'projection_y_coordinate', 'm','Y','To be used with "x".'});
nc_addvar(NcTransectFile, s);

s.Name      = 'lat';
s.Nctype    = nc_double;
s.Dimension = {'alongshore' ,'cross_shore'};
s.Attribute = struct('Name' ,{'standard_name','units'       ,'axis','comment'},...
                     'Value',{'latitude'     ,'degree_north','X','To be used with "lon".'});
nc_addvar(NcTransectFile, s);

s.Name      = 'lon';
s.Nctype    = nc_double;
s.Dimension = {'alongshore' ,'cross_shore'};
s.Attribute = struct('Name' ,{'standard_name','units'      ,'axis','comment'},...
                     'Value',{'longitude'    ,'degree_east','Y','To be used with "lat".'});
nc_addvar(NcTransectFile, s);

s.Name      = 'ls';
s.Nctype    = nc_double;
s.Dimension = {'alongshore','cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes', 'standard_name','comment','units','axis'}, ...
    'Value', {'alongshore cross_shore ', 'projection_x_coordinate', 'Alongshore coordinate, rotated and shifted from RD. To be used with "cs". Conversion from RD: [ls; cs]=[cosd(311.3), -sind(311.3); sind(311.3), cosd(311.3)]*[RD_x-rsp_x(1);RD_y-rsp_y(1)]', 'm','X'});
nc_addvar(NcTransectFile, s);
        
s.Name      = 'cs';
s.Nctype    = nc_double;
s.Dimension = {'alongshore','cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes', 'standard_name','comment','units','axis'}, ...
    'Value', {'alongshore cross_shore ', 'projection_y_coordinate','Cross-shore coordinate, rotated and shifted from RD. To be used with "ls". Conversion from RD: [ls; cs]=[cosd(311.3), -sind(311.3); sind(311.3), cosd(311.3)]*[RD_x-rsp_x(1);RD_y-rsp_y(1)]', 'm','Y'});
nc_addvar(NcTransectFile, s);
   
%%% max_cross_shore_measurement
s.Name      = 'max_cross_shore_measurement';
s.Nctype    = nc_int;
s.Dimension = {'time','alongshore'};
s.Attribute = struct('Name', {'_CoordinateAxes','long_name',  'comment'}, ...
    'Value', {'time alongshore', 'Maximum cross shore measurement index','Index of the cross shore measurement (0 based)'});
nc_addvar(NcTransectFile, s);

%%% min_cross_shore_measurement
s.Name      = 'min_cross_shore_measurement';
s.Nctype    = nc_int;
s.Dimension = {'time','alongshore'};
s.Attribute = struct('Name', {'_CoordinateAxes','long_name',  'comment'}, ...
    'Value', {'time alongshore', 'Minimum cross shore measurement index','Index of the cross shore measurement (0 based)'});
nc_addvar(NcTransectFile, s);

% EPSG
    s.Name      = 'epsg';
    s.Nctype    = nc_int;
    s.Dimension = {};
    s.Attribute = struct('Name', ...
       {'grid_mapping_name', ...
        'projection_name', ...
        'semi_major_axis', ...
        'semi_minor_axis', ...
        'inverse_flattening', ...
        'latitude_of_projection_origin', ...
        'longitude_of_projection_origin', ...
        'false_easting', ...
        'false_northing', ...
        'scale_factor_at_projection_origin',...
        'EPSG_code', ...
        'comment'}, ...
        'Value', ...
        {CClog.proj_conv1.method.name,    ...
        CClog.CS1.name, ...
        CClog.CS1.ellips.semi_major_axis, ...
        CClog.CS1.ellips.semi_minor_axis, ...
        CClog.CS1.ellips.inv_flattening,  ...
        CClog.proj_conv1.param.value(strcmp(CClog.proj_conv1.param.name,'Latitude of natural origin'    )), ...
        CClog.proj_conv1.param.value(strcmp(CClog.proj_conv1.param.name,'Longitude of natural origin'   )),...
        CClog.proj_conv1.param.value(strcmp(CClog.proj_conv1.param.name,'False easting'                 )),...
        CClog.proj_conv1.param.value(strcmp(CClog.proj_conv1.param.name,'False northing'                )),...
        CClog.proj_conv1.param.value(strcmp(CClog.proj_conv1.param.name,'Scale factor at natural origin')),...
        ['EPSG:',num2str(CClog.CS1.code)],...
        'value is equal to EPSG code'});
    nc_addvar(NcTransectFile, s);

    
s.Name      = 'rsp_lat';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name' ,{'long_name'              , 'units'            , 'comment','axis'},...
                     'Value',{'location for beach pole', 'degrees_north'    , 'Location of the beach pole (Rijks strand paal)','X'});
nc_addvar(NcTransectFile, s);

s.Name      = 'rsp_lon';
s.Nctype    = nc_double;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name' ,{'long_name'              , 'units'            , 'comment','axis'},...
                     'Value',{'location for beach pole', 'degrees_east'     , 'Location of the beach pole (Rijks strand paal)','Y'});
nc_addvar(NcTransectFile, s);

% Altitude this is the depth array!
s.Name      = 'altitude'; 
s.Nctype    = nc_double;
s.Dimension = {'time', 'alongshore' ,'cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes','standard_name', 'units', 'comment', 'coordinates', 'survey_type' ,'_FillValue'}, ...
    'Value', {'time alongshore cross_shore','surface_altitude', 'm', 'altitude above geoid (NAP)', 'Dutch Coordinate system RD', 'Jetski or Walking' , FillValue});
nc_addvar(NcTransectFile, s);

s.Name      = 'z_jarkus'; 
s.Nctype    = nc_double;
s.Dimension = {'time', 'alongshore' ,'cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes','standard_name', 'units', 'comment', 'coordinates', 'survey_type' ,'_FillValue'}, ...
    'Value', {'time alongshore cross_shore','surface_altitude', 'm', 'JarKus surveys Delfland, altitude above geoid (NAP)', 'Dutch Coordinate system RD', 'Lidar or Echosounding' , FillValue});
nc_addvar(NcTransectFile, s);

s.Name      = 'z_jnz'; 
s.Nctype    = nc_double;
s.Dimension = {'time', 'alongshore' ,'cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes','standard_name', 'units', 'comment', 'coordinates', 'survey_type' ,'_FillValue'}, ...
    'Value', {'time alongshore cross_shore','surface_altitude', 'm', 'Combined JarKus & Shore surveys (Shore primary), altitude above geoid (NAP)', 'Dutch Coordinate system RD', 'Jetski or Walking' , FillValue});
nc_addvar(NcTransectFile, s);

%%% Still missing fields compared to Jarkus:
% 	double mean_high_water(alongshore), shape = [2178]
% 	double mean_low_water(alongshore), shape = [2178]
% 	double time_topo(time,alongshore), shape = [48 2178]
% 	double time_bathy(time,alongshore), shape = [48 2178]
% 	int16 origin(time,alongshore,cross_shore), shape = [48 2178 1925]


%%%%% Shore additions to the netcdf
%%% NEW!!! JArkus or not?  
s.Name      = 'linetype';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'Comment'}, 'Value', {'Type of survey-line: Jarkus (1) , Jarkus verdicht (2), or Shore (3)'});
nc_addvar(NcTransectFile, s)

%%% Measurement area; ZM or NeMo or VB
s.Name      = 'kind';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
if OPT.vb
    s.Attribute = struct('Name', {'Comment'}, 'Value', {'Origin of data on survey-line: Zandmotor (1) , NeMo (2), NeMo_additional (3), or Vluchtenburg/NeMo (4)'});
else
    s.Attribute = struct('Name', {'Comment'}, 'Value', {'Origin of data on survey-line: Zandmotor (1) , NeMo (2) or NeMo_additional (3)'});
end
nc_addvar(NcTransectFile, s)

% % %%% NEW!!! date of the survey in string format
% % s.Name      = 'timestring';
% % s.Nctype    = nc_char;
% % s.Dimension = {'time','stringsize'};
% % s.Attribute = struct('Name', {'standard_name', 'units', 'comment', 'axis'}, 'Value', {'time', 'year', 'survey date Zandmotor', 'dd-mm-yyyy'});
% % nc_addvar(NcTransectFile, s);

%%% NEW!!! Transect number Shore
s.Name      = 'transect_number';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'comment'}, ...
    'Value', {'transect_index', 'Transect number, starting from the South'});
nc_addvar(NcTransectFile, s);

%%% NEW!!! binwidth / kuberingsfactor
s.Name      = 'binwidth';
s.Nctype    = nc_int;
s.Dimension = {'alongshore'};
s.Attribute = struct('Name', {'long_name', 'comment'}, ...
    'Value', {'volumtric_width', 'Alongshore space associated with the transect, volume multiplier'});
nc_addvar(NcTransectFile, s);

%%% NEW!!! Interpolation mask 
s.Name      = 'interpolation_mask';
s.Nctype    = nc_int;
s.Dimension = {'time', 'alongshore' ,'cross_shore'};
s.Attribute = struct('Name', {'_CoordinateAxes','long_name', 'flag_values', 'comment'}, ...
    'Value', {'time alongshore cross_shore','InterpolationMask', ' 0 1 ', ' 0: if there is survey data within a 15 m perimeter of the schematized point, 1: if the data is interpolated ' });
nc_addvar(NcTransectFile, s);

%%%%%%%%%%%
%%% Possibly in a later stage: Compare old and new file and if user agrees add new info and overwrite.
%%%%%%%%%%%

fprintf('Write data to Netcdf \n')

% write values
nc_varput(NcTransectFile, 'id', data.id); %Jarkus-id
nc_varput(NcTransectFile, 'areacode', data.areacode); %9
nc_varput(NcTransectFile, 'areaname', data.areaname); %'Delfland'
nc_varput(NcTransectFile, 'rsp', data.RSP); %RSP-alongshorecoordinate
nc_varput(NcTransectFile, 'angle', data.angle) %angle of transect
nc_varput(NcTransectFile, 'alongshore', data.alongshore); %alongshore coordinate
nc_varput(NcTransectFile, 'cross_shore', data.dist); %cross-shore coordinate
nc_varput(NcTransectFile, 'time', data.Jtime); % time from 1970 as used in Jarkus
nc_varput(NcTransectFile, 'time_nemo', data.Jtime_nemo); % time of Nemo survey
if OPT.vb
    nc_varput(NcTransectFile, 'time_vb', data.Jtime_vb); % time of VB survey
    nc_varput(NcTransectFile, 'time_vbnemo', data.Jtime_vbnemo); % time of VB/Nemo survey
end
nc_varput(NcTransectFile, 'time_jarkus', data.Jtime_jarkus); % time of Jarkus survey (bathy)
nc_varput(NcTransectFile, 'epsg', CClog.CS1.code);
nc_varput(NcTransectFile, 'x', data.x); %RD_X
nc_varput(NcTransectFile, 'y', data.y); %RD_Y
nc_varput(NcTransectFile, 'ls', data.ls); %Alongshoring
nc_varput(NcTransectFile, 'cs', data.cs); %Cross-shoring
nc_varput(NcTransectFile, 'lat', data.lat); %Northing
nc_varput(NcTransectFile, 'lon', data.lon); %Easting
nc_varput(NcTransectFile, 'min_cross_shore_measurement',data.min_cross_shore_measurement); %first index with data
nc_varput(NcTransectFile, 'max_cross_shore_measurement',data.max_cross_shore_measurement); %last index with data
nc_varput(NcTransectFile, 'rsp_x', data.rsp_x); %RD_X of RSP
nc_varput(NcTransectFile, 'rsp_y', data.rsp_y); %RD_Y of RSP
nc_varput(NcTransectFile, 'rsp_lat', data.rsp_lat); %Northing of RSP
nc_varput(NcTransectFile, 'rsp_lon', data.rsp_lon); %Easting of RSP
nc_varput(NcTransectFile, 'altitude', data.altitude); %altitudes SHORE
nc_varput(NcTransectFile, 'z_jarkus', data.z_jarkus); %altitudes from jarkus
nc_varput(NcTransectFile, 'z_jnz', data.z_jnz); %altitudes combined jarkus and shore
nc_varput(NcTransectFile, 'interpolation_mask', data.interpmask); %[1|0] interpolation|not
nc_varput(NcTransectFile, 'linetype', data.linetype);
nc_varput(NcTransectFile, 'kind', data.kind);
nc_varput(NcTransectFile, 'transect_number', data.transectnr);
nc_varput(NcTransectFile, 'binwidth', data.binwidth); %Volumetric width of transects
% % nc_varput(NcTransectFile, 'timestring', datestr(data.time','dd-mm-yyyy'))


fprintf('"%s"\n netcdf writing process completed\n', fullfile(NcTransectFile))
%EOF