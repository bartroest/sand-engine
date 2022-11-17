function [slope,d_on,d_off,intmask]=nemo_build_slope(D,z,h_on,h_off)
%NEMO_BUILD_SLOPE Calculates the average bed slope between two bed levels;
%
% Method: Find depths and fit linear function through points in between
%         i=slope of the linear function.
%
% The linear fit is more robust and less sensitive to errors in the altitude
% measurements, as opposed to the direct calculation of dh/dx.
%
% Syntax: [slope,dist_onsh,dist_offsh]=nemo_build_slope(...
%       Datastruct,'altitude_field',altitude_onsh,altitude_offsh);
%
% Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       h_on: onshore altitude limit
%       h_off: offshore altitude limit
%
% Output:
%   	slope: linear trend of slope between h_on and h_off [m/m]
%       d_on: cross-shore location of h_on
%       d_off: cross-shore location of h_off
%       intmask: mask for fallback calculation of dh/dx.
%
% Example
%   [slope,d_on,d_off,intmask]=nemo_build_slope(D,'altitude',0,-4);
%
%   See also: nemo, nemo_depth_contour_accurate, polyfit.

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
slope=nan(size(D.(z),1),size(D.(z),2));
d_on=slope;
d_off=slope;
intmask=false(size(slope));

for t=1:size(D.(z),1);
    [c1,~,cs_dist_on]= nemo_depth_contour_accurate(D,z,h_on, t);
    [~ ,~,cs_dist_off]=nemo_depth_contour_accurate(D,z,h_off,t);

    d_on(t,:)=cs_dist_on;
    d_off(t,:)=cs_dist_off;
    
    for n=1:size(D.(z),2);
        if ~isnan(c1(n))
%             mask=squeeze(D.altitude(t,n,:)<=h_on & D.altitude(t,n,:)>=h_off); %Height based masking
%             mask(1:floor(c1(n)))=0;
              mask= D.dist >= cs_dist_on(n)  &  D.dist <= cs_dist_off(n); %Distance based masking
            if sum(mask)>4;
                F=polyfit(D.dist(mask),squeeze(D.(z)(t,n,mask)),1);
                slope(t,n)=F(1); % This is the linear fit through all points between heights.
            else
                %For very steep slopes, not enough data points might be
                %available for a good fit. Therefore this fallback is used.
                slope(t,n)=(h_on-h_off)/(cs_dist_on(n)-cs_dist_off(n));
                intmask(t,n)=true;
            
            end
        end
    end
end
end