function [C,Cstd]=nemo_plot_std_contour(D,z,depth)
%NEMO_PLOT_STD_CONTOUR Plot standard deviation of Cross-shore contour postion.
%
%   Syntax:
%       [C,Cstd]=nemo_plot_std_contour(D,z,depth)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       depth: depth contours to plot, vector
%
%   Output:
%   	C: contour positions w.r.t. RSP
%       Cstd: contour standard deviation
%
%   Example:
%       [C,Cstd]=nemo_plot_std_contour(D,'altitude',[0:-1:-8]);
%
%   See also: nemo, nemo_depth_contour, nemo_depth_contour_accurate

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
C=nan(length(depth),length(D.time),length(D.alongshore));
Cstd=nan(length(depth),length(D.alongshore));
for d=1:length(depth);
    for t=1:37; 
        [~,~,C(d,t,:)]=nemo_depth_contour_accurate(D,z,depth(d),t); 
    end
    Cstd(d,:)=std(squeeze(C(d,:,:)),0,1,'omitnan');
end

figure;
subplot(2,1,1); 
    h=plot(D.alongshore,Cstd);  
    xlabel('Distance from HvH [m]');
    ylabel('Standard deviation of depth contour in cross-shore direction [m]');
    legend(h,{num2str(depth,'%d')});
    
subplot(2,1,2); 
    plot(D.alongshore,squeeze(C(:,[7],:)));
    xlabel('Distance from HvH [m]');
    ylabel('Cross-shore position of depth contour w.r.t. RSP [m]');