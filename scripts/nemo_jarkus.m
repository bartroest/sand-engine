function D=nemo_jarkus(jarkus_nc,areacode,dist)
%NEMO_JARKUS Retreives Jarkus data for Jarkus-area from Jarkus NetCDF.
%   This is a not so sophisticated script to retreive data for a single
%   Jarkus-area out of the Jarkus NetCDF.
%   [a b] denotes dimensions (size).
%
%   Syntax: 
%       Data=nemo_jarkus('jarkus_nc_file',areacode);
%
%   Input: 
%       jarkus_nc: url or path of transect.nc file.
%       area_code: area to select (kustvak, Delfland = 9)
%       dist: D.cross_shore, to match jarkus and zandmotor grid.
%
%   Output:
%   	D: jarkus data for Delfland.
%
%   Example:
%       DL=nemo_jarkus('transect.nc',9,D.dist);
%
%   See also: nemo, jarkus

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

fprintf(1,'Retreiving "transect.nc" from %s \n',jarkus_nc);
Jarkus=nc2struct(jarkus_nc);

areamask=Jarkus.areacode==areacode;

if nargin>2;
    [~,~,ics]=intersect(dist,Jarkus.cross_shore);
else
    ics=1:length(Jarkus.cross_shore);
end
% % NCinfo=nc_info(jarkus_nc);
% % fn={NCinfo.Dataset.Name}';
% % nfields=length(fn);
% % % % % 
% % 
% % areacodes=nc_varget(jarkus_nc,'areacode');
% % ntrans=length(areacodes);
% % idx=areacodes==areacode;
% % 
% % for f=1:nfields;
% %     temp=nc_varget(jarkus_nc,(fn{f}));
% %     sz= NCinfo.Dataset(f).Size;
% %     szidx=sz==ntrans;
% %     
% %     D.(fn{f})=temp();
% %     
% %     if size(temp,1)==ntrans; %Alongshore variables
% %         D.(fn{f})=temp(mask,:);
% % %         fprintf(1,'1 fieldname %30s, size [%4.0f %4.0f]\n',fn{f},size(Jarkus.(fn{f}),1),size(Jarkus.(fn{f}),2));
% %     elseif size(temp,2)==ntrans && length(size(Jarkus.(fn{f})))<3; %Alongshore variables with time component
% %         D.(fn{f})=temp(:,mask);
% % %         fprintf(1,'2 fieldname %30s, size [%4.0f %4.0f]\n',fn{f},size(Jarkus.(fn{f}),1),size(Jarkus.(fn{f}),2));
% %     elseif size(temp,2)==ntrans && length(size(Jarkus.(fn{f})))==3; %3D variables
% %         D.(fn{f})=temp(:,mask,:);
% % %         fprintf(1,'3 fieldname %30s, size [%4.0f %4.0f]\n',fn{f},size(Jarkus.(fn{f}),1),size(Jarkus.(fn{f}),2));
% %     else %Variables withour alongshore component
% % %         fprintf(1,'4 fieldname %30s, size [%4.0f %4.0f]\n',fn{f},size(Jarkus.(fn{f}),1),size(Jarkus.(fn{f}),2));
% %         D.(fn{f})=temp;
% %         if size(temp,1)<size(temp,2)
% %            D.(fn{f})=Jarkus.(fn{f})';
% %         end
% %     end
% %     
% %     if strncmpi(fn{f},'time',4)
% %         D.(fn{f})=D.(fn{f})+datenum(1970,1,1);
% %     end
% % end


D.id=Jarkus.id(areamask); %[raaien 1]
D.areacode=Jarkus.areacode(areamask); %[raaien 1] 
D.areaname=Jarkus.areaname(areamask); %[raaien 1]
D.alongshore=Jarkus.alongshore(areamask); %[raaien 1]

D.cross_shore=Jarkus.cross_shore(ics); %[cross-shore_points 1]
D.time=Jarkus.datenum; %[surveys 1]
D.time_bounds=Jarkus.datenum_bounds; %[surveys 2]
D.epsg=Jarkus.epsg; %[1 1]

D.x=Jarkus.x(areamask,ics); %[raaien cross-shore_points]
D.y=Jarkus.y(areamask,ics); %[raaien cross-shore_points]
D.lat=Jarkus.lat(areamask,ics); %[raaien cross-shore_points]
D.lon=Jarkus.lon(areamask,ics); %[raaien cross-shore_points]

D.angle=Jarkus.angle(areamask); %[raaien 1]
D.mean_high_water=Jarkus.mean_high_water(areamask); %[raaien 1]
D.mean_low_water=Jarkus.mean_low_water(areamask); %[raaien 1]

D.max_cross_shore_measurement=Jarkus.max_cross_shore_measurement(:,areamask); %[surveys raaien]
D.min_cross_shore_measurement=Jarkus.min_cross_shore_measurement(:,areamask); %[surveys raaien]
D.nsources=Jarkus.nsources(:,areamask); %[surveys raaien]
D.max_altitude_measurement=Jarkus.max_altitude_measurement(:,areamask); %[surveys raaien]
D.min_altitude_measurement=Jarkus.min_altitude_measurement(:,areamask); %[surveys raaien]

D.rsp_x=Jarkus.rsp_x(areamask); %[raaien 1]
D.rsp_y=Jarkus.rsp_y(areamask); %[raaien 1]
D.rsp_lat=Jarkus.rsp_lat(areamask); %[raaien 1]
D.rsp_lon=Jarkus.rsp_lon(areamask); %[raaien 1]

D.time_topo=Jarkus.datenum_topo(:,areamask); %[surveys raaien]
D.time_bathy=Jarkus.datenum_bathy(:,areamask); %[surveys raaien]

D.origin=Jarkus.origin(:,areamask,ics); %[surveys raaien cross-shore_points]
D.altitude=Jarkus.altitude(:,areamask,ics); %[surveys raaien cross-shore_points]
%D.z=D.altitude;
end
%EOF