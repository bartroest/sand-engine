function [angle, angle_g, x, y, curvature, dist]=nemo_coastline_orientation(D,z,depth,t,window,figswitch)
%nemo_coastline_orientation - Calculates the orientation of a depth contour
%
% [angle,angle_g,x,y,curv,dist]=nemo_coastline_orientation(Data,'altitude',depth_contour,time_index,window,figswitch);
%
% Input:    D: Datastruct
%           z: altitude fieldname
%           depth_contour: height-line to base orientation on (+1m NAP is a good choice)
%           t: time_index of survey
%           window: one-sided window for fit (2-5 is good)
%           figswitch: 0 or 1; plot animation of the fit.
%
% Output:   angle: relative coastline orientation; to get angle w.r.t. N; add 311.3
%           angle_g: global coastline orientation (approx 311.3);
%           x: longshore position of depth-contour.
%           y: cross-shore position of depth-contour.
%           curv: curvature of the depth-contour.
%
%   Example
%   [angle, angle_g, x, y, curvature, dist]=nemo_coastline_orientation(D,'altitude',0,7,2,1)
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

slope=nan(1,size(D.(z),2));

%[x, y]=nemo_depth_contour_xy(D,z,depth,t); %Works on actual RD-xy data ->
%Problems occur when the orientation is N-S directed due to atan asymptote.

%[x, y]=nemo_depth_contour_lc(D,z,depth,t); %Works on rotated grid (RD-xy rotated to be globally shore normal)

% use globally shore normal coordinates in combination with volumetric
% distance.
x=nan(644,1);
y=nan(644,1);
warning('off');
for n=1:length(D.alongshore);
    cs=D.cs(n,:); cs=cs(:);
    ls=D.ls(n,:); ls=ls(:);
    zz=squeeze(D.(z)(t,n,:)); zz=zz(:);
    if sum(~isnan(zz))>3;
        y(n)=jarkus_getMKL(cs,zz,1,-4);
        x(n)=jarkus_getMKL(ls,zz,1,-4);
        if isnan(x(n));
            x(n)=jarkus_getMKL(-ls,zz,1,-4);
            x(n)=-x(n);
        end
    end
end
warning('on');

[~,~,dist]=nemo_depth_contour_accurate(D,z,depth,t);
%y=smooth1_nan(y,10);
if figswitch
    figure;
    plot(x,y,'.k');
    hold on;
end

[x_g, y_g]=nemo_depth_contour_xy(D,z,depth,t);
slope_g=polyfit(x_g(~isnan(x_g)),y_g(~isnan(y_g)),1);
if slope_g(1)<0
    angle_g=180-atand(slope_g(1));
else
    angle_g=360-atand(slope_g(1));
end
%angle_g(angle_g>=360)=angle_g(angle_g>=360)-360;

for i=1:length(slope);%1+window:length(x)-window;
    lower_bound=max(1            ,i-window);
    upper_bound=min(length(slope),i+window);
    x_fit=x(lower_bound:upper_bound); x_fit=x_fit(~isnan(x_fit));
    y_fit=y(lower_bound:upper_bound); y_fit=y_fit(~isnan(y_fit));
    if length(x_fit)>=3;%~isempty(x_fit);
        a=polyfit(x_fit,y_fit,1);
        slope(i)=a(1);
        
        if figswitch %Plots an animation of all fits, handy for debugging
            h1=plot(x_fit,y_fit,'.r');
            h2=plot([x_fit(1)-200:1:x_fit(end)+200],a(1).*[x_fit(1)-200:1:x_fit(end)+200]+a(2),'-r');
            pause(0.1);
            delete(h1);
            delete(h2);
        end
    end
end

% % % for i=1:length(slope);%1+window:length(x)-window;
% % %     mask= x >= x(i)-200 & x <= x(i)+200;
% % %     x_fit=x(mask); x_fit=x_fit(~isnan(x_fit));
% % %     y_fit=y(mask); y_fit=y_fit(~isnan(y_fit));
% % %     if length(x_fit)>3;%~isempty(x_fit);
% % %         a=polyfit(x_fit,y_fit,1);
% % %         slope(i)=a(1);
% % %         
% % %         if figswitch %Plots an animation of all fits, handy for debugging
% % %             h1=plot(x_fit,y_fit,'.r');
% % %             h2=plot([x_fit(1)-200:1:x_fit(end)+200],a(1).*[x_fit(1)-200:1:x_fit(end)+200]+a(2),'-r');
% % %             pause(0.05);
% % %             delete(h1);
% % %             delete(h2);
% % %         end
% % %     end
% % % end
angle=-atand(slope)'; %Angle with respect to global orientation.

%% CURVATURE

curvature=atand(diff(tand(angle),1)./diff(D.alongshore));

%angle(angle>=360)=angle(angle>=360)-360;

%EOF