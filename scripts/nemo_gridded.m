function G=nemo_gridded(D,P,coordswitch,gridsize);
%NEMO_GRIDDED Makes a gridded surface from surveypath with no extrapolation.
%
% Interpolates raw survey data (survey path) to grid with uniform size.
%
% Input:
%   D: data struct or Surveylines
%   P: Surveypath struct
%   coordswitch: coordinate system ['xy','lscs']
%   gridsize: grid spacing [m], scalar or 1x2 vector.
%   
% Output:
%   G: struct with gridded altitude data, fields:
%       time: time vector
%       x: x-coordinates
%       y: y-coordinates
%       ls: alongshore coordinates
%       cs: cross-shore coordinates
%       z: altitude
%       
%
% Example:
%   G=nemo_gridded(D,P,'lscs',[10 10]);
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

%% Input
if nargin<3
    coordswitch='lscs';
    gridsize=5;
end

if isscalar(gridsize)
    xgridsize=gridsize;
    ygridsize=gridsize;
elseif length(gridsize)==2
    xgridsize=gridsize(1);
    ygridsize=gridsize(2);
else
    error('Gridsize must be scalar or 2x1 vector: [xgridsize ygridsize]');
end

%% Generate grid
switch coordswitch
    case {'lc','lscs'}
        ls=-200:xgridsize:17200; %alongshore
        cs=450:ygridsize:2800;   %cross-shore
        [xg,yg]=meshgrid(ls,cs);
        G.ls=xg;
        G.cs=yg;
        
    case {'xy'}
        mask=sum(~isnan(D.altitude),1)>2;
        xmin=floor(min(D.x(mask)),-1);
        xmax=ceil( max(D.x(mask)),-1);
        ymin=floor(min(D.y(mask)),-1);
        ymax=ceil( max(D.y(mask)),-1);
        
        x=xmin:xgridsize:xmax; %RD-x
        y=ymin:ygridsize:ymax; %RD-y
        [xg,yg]=meshgrid(x,y);
        G.x=xg;
        G.y=yg;
        
    otherwise
        fprintf(1,'Unknown coordinate option, use ''lscs'' or ''xy'' instead.');
        return
end
G.z=nan([length(P.time), size(xg)]);
G.time=P.time;

%% Interpolation

for t=1:size(P.path_RD,1);
    fprintf(1,'Generating grid for survey %2.0f of %2.0f \n',t,length(P.time));
    mask=squeeze(~isnan(P.path_RD(t,:,3)));
    xp=squeeze(P.path_RD(t,mask,1)); %x_path
    yp=squeeze(P.path_RD(t,mask,2)); %y_path
    zp=squeeze(P.path_RD(t,mask,3)); %z_path
    
    switch coordswitch
        case {'lc','lscs'}
            [xp,yp]=nemo_build_shorenormalcoordinates(D,xp,yp); %alongshore/cross-shore_path
            pmask= xp >= min(ls) & xp <= max(ls) & yp >= min(cs) & yp <= max(cs); % Remove points outside the interpolation area.
            xp=xp(pmask);
            yp=yp(pmask);
            zp=zp(pmask);
        case 'xy'
            pmask= xp >= xmin & xp <= xmax & yp >= ymin & yp <= ymax; % Remove points outside the interpolation area.
            xp=xp(pmask);
            yp=yp(pmask);
            zp=zp(pmask);
        otherwise
            %Nothing
    end
    F=scatteredInterpolant(xp(:),yp(:),zp(:),'linear','none');
    zi=F(xg,yg); % Interpolated values
    
% %     inr=inradius(xp,yp,xg(mask),yg(mask),50); % points close to path
% %     mask(mask)=~inr;
% %         
% %     xtemp=xg(mask); 
% %     ytemp=yg(mask);
% %     idx_b=boundary(xtemp,ytemp,0.70);
% %     inp=inpolygon(xg,yg,xtemp(idx_b),ytemp(idx_b)); % points within boundary.
    
    idx_b=boundary(xp(:),yp(:),0.95);
    inp=inpolygon(xg,yg,xp(idx_b),yp(idx_b)); % points within boundary.
    zi(~inp)=nan;
        
    % Output
    G.z(t,:,:)=zi;
    
end