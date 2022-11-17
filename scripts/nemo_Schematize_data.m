function Surveydata = nemo_Schematize_data(Surveylines,XYZ,spacing,maxgap,survno,altswitch)
%nemo_Schematize_data Script to schematise XYZ along a track to predefined survey lines
% Used in main file ZMdataShore2NetCDF.m
% 
% Uses:
% extract_line_Shore.m
%  
% Input: 
%       Surveylines: surveylines-struct
%       XYZ: surveypath-struct with X,Y,Z-coordinate fields.
%       spacing: distance perpendicular to line in which points must be.
%                (1-sided distance! Total width is 2x spacing)
%       maxgap: Threshold distance along line within which a point is not
%               considered to be interpolated.
%       survno: Index of Sand Engine survey.
%       altswitch: [true|false] Get rid of alternating transect lengths in
%                  ZM area, interpolate short transects to long ones.
%
% Output: 
%       Surveydata: interpolated data-struct.
%
% Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
%
%
% Shore Monitoring & Reseach, Jan 2014
% Bart Roest, Dec 2016, Okt 2017
%   - Direct interpolation using ScatteredInterpolant > major speed improvement.
%   - Improved interpolation check, skipping areas without any data.
% info@shoremonitoring.nl
%
%   See also: nemo, nemo_raw2transects, nemo_extract_line_Shore.

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
%%% Here we extract the XYZ data in the vicinity of the predefined survey lines. 
disp('Extract surveylines.')
for i_l=1:length(Surveylines.CS)
    Surveydata.line.CS(i_l) = nemo_extract_line_Shore(XYZ,Surveylines.CS(i_l),spacing,'figs',false);
end

%%% Determine max & min CS-extent of data on every transect.
dist_max=nan(1,length(Surveylines.CS));
dist_min=nan(1,length(Surveylines.CS));
for i_l=1:length(Surveylines.CS)
    dist_max(i_l)=max(Surveydata.line.CS(i_l).data.dist);
    dist_min(i_l)=min(Surveydata.line.CS(i_l).data.dist);
end

%%% Get rid of short/alternating transects in ZM-area.
if altswitch
    if survno>=39; %Exception for last surveys due to larger ZM-domain!!!
        %From Zandmotor survey #39 (January 2017) the survey domain is
        %extended alongshore with ca. 1000m to the North and South. In this
        %extension the same short/long transects are surveyed.
        if any(isnan(dist_max(266:473))); %Check for nan-values in ZM-area
            dm=dist_max(266:473);
            dm(isnan(dm))=-1000;
            dist_max(266:473)=dm;
            dm=dist_min(266:473);
            dm(isnan(dm))=5000;
            dist_min(266:473)=dm;
        end
        dist_max(266:473)=running_max_filter(dist_max(266:473),3); %Apply filter for dist_max, to get rid of short transects.
        dist_max(dist_max<=-1000)=nan;
        dist_min(266:473)=running_min_filter(dist_min(266:473),3);
        dist_min(dist_min>=5000)=nan;
    else %For earlier surveys (1:38)
        if any(isnan(dist_max(305:428))); %Check for nan-values in ZM-area
            dm=dist_max(305:428);
            dm(isnan(dm))=-1000;
            dist_max(305:428)=dm;
        end
        dist_max(305:428)=running_max_filter(dist_max(305:428),1); %Apply filter for dist_max, to get rid of short transects.
        dist_max(dist_max<=-1000)=nan;
    end
end
    
    %%%

%%% first we make an interpolant using the all XYZ points in the survey.
disp(['Make interpolant for topo survey ',num2str(survno),'.']);
warning off
Z=scatteredInterpolant(XYZ.X(:),XYZ.Y(:),XYZ.Z(:),'linear','none');
warning on

%%% Interpolation check for elevation.
for i_l=1:length(Surveylines.CS)
    if ~isnan(Surveydata.line.CS(i_l).data.X) %Test whether there is data on the line.
        %%% Query interpolant at survey line.
        Surveydata.line.CS(i_l).z_gridded= Z(Surveydata.line.CS(i_l).xi,Surveydata.line.CS(i_l).yi);

        %%% remove interpolated points near the edge of the transect (areas beyond where raw data is found).
        mask=Surveydata.line.CS(i_l).dist < dist_min(i_l) | Surveydata.line.CS(i_l).dist > dist_max(i_l);
        Surveydata.line.CS(i_l).z_gridded(mask)=NaN;

        %%% Now we are going to look if there is any data near an interpolated point. 
        %%% For every point we check if there is data close-by (between 'maxgap' meter onshore and offshore).
        iserdata=ones(size(Surveydata.line.CS(i_l).dist)); %true is interpolated, false not-interpolated; first assume everything interpolated.
        d_ind=1:length(Surveydata.line.CS(i_l).dist);
        for i_dist=d_ind(~mask);  %check for every interpolated position (omitting positions already set to NaN).
            iserdata(i_dist)=~any(Surveydata.line.CS(i_l).data.dist >= Surveydata.line.CS(i_l).dist(i_dist) -maxgap & Surveydata.line.CS(i_l).data.dist <= Surveydata.line.CS(i_l).dist(i_dist) +maxgap);
        end
        % Now make a mask for interpolated transect data where there is no XYZ survey data in the vicinity 
        Surveydata.line.CS(i_l).InterpolationMask=double(iserdata);
    else %If there is no data on the transect; fill with nan.
        Surveydata.line.CS(i_l).z_gridded=nan(size(Surveydata.line.CS(i_l).dist));
        Surveydata.line.CS(i_l).InterpolationMask=ones(size(Surveydata.line.CS(i_l).z_gridded));
    end
end
disp('Data separated to individual lines.');
end
%EOF