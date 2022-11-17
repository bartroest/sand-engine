function nemo_plot_bathysedero(D,t1,t2,index)
%nemo_plot_bathysedero Simple script to visualise Sed/Erosion between surveys.
%
% Input:
%   D: datastruct
%   t1: time index
%   t2: time index
%   index: alongshore index
%
% Output:
%   Three panel pcolor plot
%
% Example:
%   nemo_plot_bathysedero(D,7,37,Index.all)
%
% See also: nemo

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
%%
figure; 
%AX1
ax1=subplot(2,2,1); 
    pcolor(D.ls(index,:),D.cs(index,:),squeeze(D.altitude(t1,index,:)));
    shading flat;
    xlim(D.alongshore(index([1 end])));
    ylim([0 2500]);
    colormap(ax1,zmcmap);
    clim([-12 7]);
    
    colorbar('peer',ax1,'Position',[0.57 0.57 0.015 0.34]);
    
%AX2
ax2=subplot(2,2,3);
    pcolor(D.ls(index,:),D.cs(index,:),squeeze(D.altitude(t2,index,:))); 
    shading flat;
    xlim(D.alongshore(index([1 end])));
    ylim([0 2500]);
    colormap(ax2,zmcmap);
    clim([-12 7]);
    colorbar('horizontal')

%AX3
ax3=subplot(2,2,4); 
    pcolor(D.ls(index,:),D.cs(index,:),squeeze(D.altitude(t2,index,:))-squeeze(D.altitude(t1,index,:))); 
    shading flat; 
    xlim(D.alongshore(index([1 end])));
    ylim([0 2500]);
    colormap(ax3,jwb(100,0.02));
    %clim([-10 5]);
    csym;
    
    colorbar('peer',ax3,'Position',[0.67 0.57 0.015 0.34]);
end
%EOF