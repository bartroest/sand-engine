function MB=nemo_mb2trans(D)
%NEMO_MB2TRANS reads MB path and interpolates to transects.
%
%   Loads Multibeam data of Delfland area and interpolates to transects. Two
%   multibeam surveys were performed: in 2012 and 2015. Raw data can be found in
%   the zandmotor svn repository.
%
%   Input:
%       D: data struct
%
%   Example:
%       MB=nemo_mb2trans(D);
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
M1=load('Morfologische data\Path_multibeam_20120211.mat');
P=load('Morfologische data\DL_path_vb.mat');
XYZ(1).X=[M1.x; squeeze(P.path_RD(7,:,1))'];
XYZ(1).Y=[M1.y; squeeze(P.path_RD(7,:,2))'];
XYZ(1).Z=[M1.z; squeeze(P.path_RD(7,:,3))'];

mask=~isnan(XYZ(1).Z);
XYZ(1).X=XYZ(1).X(mask);
XYZ(1).Y=XYZ(1).Y(mask);
XYZ(1).Z=XYZ(1).Z(mask);

M2=load('Morfologische data\Path_multibeam_20150624.mat');

XYZ(2).X=[M2.x; squeeze(P.path_RD(31,:,1))'];
XYZ(2).Y=[M2.y; squeeze(P.path_RD(31,:,2))'];
XYZ(2).Z=[M2.z; squeeze(P.path_RD(31,:,3))'];

mask=~isnan(XYZ(2).Z);
XYZ(2).X=XYZ(2).X(mask);
XYZ(2).Y=XYZ(2).Y(mask);
XYZ(2).Z=XYZ(2).Z(mask);


load('Morfologische data\Surveylines_Delfland','Surveylines');
MB(1)=nemo_Schematize_data(Surveylines,XYZ(1),15,10);
MB(2)=nemo_Schematize_data(Surveylines,XYZ(2),15,10);

%% Transect struct
%load('Nemo_data.mat','D');
for n=1:644; M.altitude(1,n,:)=MB(1).line.CS(n).z_gridded; end
for n=1:644; M.altitude(2,n,:)=MB(2).line.CS(n).z_gridded; end
M.dist=D.dist;
M.alongshore=D.alongshore;
M.x=D.x;
M.y=D.y;
M.L=D.L;
M.C=D.C;
M.ls=D.ls;
M.cs=D.cs;
M.time=[datenum(2012,02,11); datenum(2015,06,24)];

save('./Morfologische data/MB_raw.mat','MB');
save('./Morfologische data/MB_trans.mat','M');
end