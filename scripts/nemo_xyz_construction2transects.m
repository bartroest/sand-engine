%NEMO_XYZ_CONSTRUCTION2TRANSECTS Attempt to construct a DEM from early surveys.
%
%   Compiles raw survey data from BOKA and construction surveys into a DEM.
%   Older data is overwritten with new at the same location.
%
%   Syntax:
%   trend = nemo_altitude_trend(D,z)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%
%   Output:
%   	trend: bedlevel trend in m/year
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
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
%% Code
fn=dir2(fullfile(OPT.basepath,'..','..','construction\raw\jetski\data survey'),'no_dirs',true,'file_incl','\.txt$');
startrow=7*ones(size(fn));
startrow(7)=10;
startrow(11)=8;
startrow(12)=9;
startrow(13)=8;
for n=1:length(fn); 
    [XYZ(n).X,XYZ(n).Y,XYZ(n).Z,XYZ(n).time,x]=nemo_import_xyz_construction([fn(n).pathname,'\',fn(n).name],startrow(n),Inf);
end

%%
for n=1:length(XYZ);
    %figure;
    nanscatter(XYZ(n).X,XYZ(n).Y,15,XYZ(n).Z,'filled');
    axis equal;
    colormap(zmcmap); clim([-12 7]);
    title(datestr(XYZ(n).time,'dd-mm-yyyy'));
    colorbar;
    xlabel('x_{RD} [m]');
    ylabel('y_{RD} [m]');
    hold on;
    pause;
end

%% BOKA SURVEYS
load('Surveylines_Delfland','S');
fn=dir2(fullfile(OPT.basepath,'..','..','construction\raw\survey\'),'no_dirs',true,'file_incl','\.xyz$')';
delimiterstr={' ',','};
    for n=1:length(fn);
        fprintf(1,'Importing survey %s...\n',fn(n).name);
        if n>=8; 
            delimiter=delimiterstr{2};
        else
            delimiter=delimiterstr{1};
        end
        [XYZ.X,XYZ.Y,XYZ.Z]=nemo_import_xyz_bokasurvey([fn(n).pathname,'\',fn(n).name], delimiter, 1, Inf);
        XYZ.time=datenum(fn(n).name(1:8),'yyyymmdd');
        
        
        fprintf(1,'Interpolating... \n');
        Z=scatteredInterpolant(XYZ.X,XYZ.Y,XYZ.Z,'linear','none');
        XYZ.zi=Z(S.xi,S.yi);
        fprintf(1,'Saving... \n');
        save([fn(n).pathname,'\',datestr(XYZ.time,'yyyymmdd'),'_survey.mat'],'XYZ');
        clear XYZ Z
        fprintf(1,'Done! \n\n');
    end
    
    
%%
nemo_BOKA2transects;

%%
for n=1:length(XYZ);
    %figure;
    nanscatter(XYZ(n).X(1:25:end),XYZ(n).Y(1:25:end),15,XYZ(n).Z(1:25:end),'filled');
    axis equal;
    colormap(zmcmap); clim([-12 7]);
    title(datestr(XYZ(n).time,'dd-mm-yyyy'));
    colorbar;
    xlabel('x_{RD} [m]');
    ylabel('y_{RD} [m]');
    hold on;
    pause;
end