function l_out=nemo_get_data_line(X,Y,Z,spacing,dist_perp,varargin)
%NEMO_GET_DATA_LINE Gets data from surveypath for arbitrary line.
%
% Extract data from a point cloud and interpolate to an arbitrary line.
%
% Input: 
%   X: x-coordinates
%   Y: y-coordinates
%   Z: altitude
%   spacing: spacing spacing along the line in m. (eg 5)
%   dist_perp: search distance perpendicular to the line in m. (eg 20)
%   varargin:
%       x0: line origin x-coordinate
%       y0: line origin y-coordinate
%       x1: line end x-coordinate
%       y1: line end y-coordinate
%
% Output: line_data (raw and interpolated)
%
% Syntax: l_out=nemo_get_data_line(D,t,spacing,dist_perp,varargin)
%
% Call script with input arguments, then select begin and end of the
% desired line.
%
% See also: nemo, nemo_extract_line_Shore
%
% Bart Roest 2016

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

%t=input('Survey number: ');
%spacing=input('Spacing between points: ');
if ~isempty(varargin) && length(varargin)==4;
    x(1)=varargin{1};%x1
    y(1)=varargin{2};%y1;
    x(2)=varargin{3};%x2;
    y(2)=varargin{4};%y2;

else
    scrsz = get(groot,'ScreenSize');
    figure('Position',[50 scrsz(4)*0.1 scrsz(3)*0.8 scrsz(4)*0.8])
    hold on;
    % %plot(D.x,D.y,'.','Color',[0.8 0.8 0.8]);
    % %pcolor(D.x,D.y,squeeze(D.altitude(t,:,:)));
    pcolor_force_regular_grid(X,Y,Z,20,20,'pcolor','flat');
    shading flat;
    axis equal;
    % %[xl, yl]=nemo_planbound('dl',1,1);
    % %xlim(xl);
    % %ylim(yl);


    [x, y]=ginput(2);

    close(gcf);
end

xy=sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
l_in.dist=0:spacing:xy;
l_in.x_origin=x(1);
l_in.y_origin=y(1);
l_in.xi=linspace(x(1),x(2),length(l_in.dist));
l_in.yi=linspace(y(1),y(2),length(l_in.dist));
l_in.angle=atand((x(2)-x(1))/(y(2)-y(1)));
if     x(2)-x(1)<0 && y(2)-y(1)>0; l_in.angle=l_in.angle+360;
elseif                y(2)-y(1)<0; l_in.angle=l_in.angle+180;
end
%x>0 y>0; 0;
%x<0 y>0; +360;
%x<0 y<0; +180;
%x>0 y<0; +180;

% % P=load('DL_path','path_RD'); %LOAD surveypath data; not so generic...
% % 
% % XYZ.X=P.path_RD(t,:,1);
% % XYZ.Y=P.path_RD(t,:,2);
% % XYZ.Z=P.path_RD(t,:,3);
XYZ.X=X;
XYZ.Y=Y;
XYZ.Z=Z;

l_out=extract_line_Shore(XYZ,l_in,dist_perp);
l_out.dist=l_in.dist;
l_out.angle=l_in.angle;
l_out.z=interp1(l_out.data.dist,l_out.data.Z,l_in.dist);
end
%EOF