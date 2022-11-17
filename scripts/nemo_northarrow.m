function [x_ds3,y_ds3]=nemo_northarrow(h,w,x0,y0,theta0,c,fs)
%NEMO_NORTHARROW plots a 'North arrow' on a map.
%
% Plots a North arrow on existing axes.
%
% Input:
%   x0: x-coordinate centre
%   y0: y-coordinate centre
%   d: diametre
%   theta0: direction to N
%   c: color (string or triplet)
%   fs: font size
%
%  OR
%   'auto' (default values are used)
%
%  Example:
%   figure;
%   x0=600;      
%   y0=400;
%   theta0 =-48;
%   h=100;
%   w=100;
%   c='k';
%   nemo_northarrow(h,w,x0,y0,theta0,c);
%   nemo_northarrow('auto');
%
%   See also: nemo, northarrow

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

if nargin==1 %'auto' Automatically scale and place.
    h=800;
    w=800;
    xl=get(gca,'XLim');
    yl=get(gca,'YLim');
    x0=xl(2)-0.7*h;
    y0=yl(2)-0.8*w;
    theta0=-48;
    c='k';
    fs=15;
    
else
    % use inputparams.
end
    x_ds=[ 0  1 0 -1  0 0]*(h/5);
    y_ds=[-1 -2 3 -2 -1 3]*(w/5);

    x_ds2 = -(x_ds).*sind(theta0) + (y_ds)*cosd(theta0); 
    y_ds2 = -(x_ds) *cosd(theta0) - (y_ds)*sind(theta0);   

    x_ds3=x_ds2+x0;
    y_ds3=y_ds2+y0;

    patch('XData',x_ds3([1:3,5]),'YData',y_ds3([1:3,5]),'FaceColor','k','EdgeColor',c);
    patch('XData',x_ds3([3:6])  ,'YData',y_ds3([3:6])  ,'FaceColor','w','EdgeColor',c);

    %plot(x_ds3,y_ds3,c,'linewidth',2);
    t1=text(x0,y0-0.5*h,'N');
    set(t1,'Fontsize',fs,'color',c);
end
%EOF