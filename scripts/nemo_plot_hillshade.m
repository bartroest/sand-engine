function nemo_plot_hillshade(D,z,lscs,t_index)
%nemo_plot_hillshade Plots 'hilshade' of the bathymetry based on given coordinates
%
%   Plots hillshade (bed-level gradient) figures of a survey. Gradients
%   calculated along specified coordinates.
%
%   Syntax:
%       nemo_plot_hillshade(D,z,lscs,t_index)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       lscs: coordinate system, 'xy', 'RSP', 'lscs'
%       t_index: time indices to plot
%
%   Output:
%   	figures
%
%   Example:
%       nemo_plot_hillshade(D,'altitude','lscs',1:37);
%
%   See also: nemo, nemo_gradients

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
switch lscs
    case {'LC','RSP'}
        ls='L';
        cs='C';
    case {'RD','xy'}
        ls='x';
        cs='y';
    case 'lscs'
        ls='ls';
        cs='cs';
    otherwise
        ls=input('x: ');
        cs=input('y: ');
end

for t=t_index; 
    hillshade(squeeze(D.(z)(t,:,:))',D.(ls)(:),D.(cs)(:),'plotit'); 
    axis equal; 
    switch lscs
        case {'lscs'}
            xlim([0 17500]); 
            ylim([0 2500]); 
            xlabel('Distance from HvH [m]');
            ylabel('Distance from RSP [m]');
        case {'RD','xy'}
            xlim([min(D.(ls)(:)), max(D.(ls)(:))]);
            ylim([min(D.(cs)(:)), max(D.(cs)(:))]);
            xlabel('Easting [m]');
            ylabel('Northing [m]');
        otherwise
            xlim([min(D.(ls)(:)), max(D.(ls)(:))]);
            ylim([min(D.(cs)(:)), max(D.(cs)(:))]);
    end
    clim([75 250]);

    title(['Hillshade of altitude ',datestr(D.time(t),'dd-mmm-yyyy')]);
    
    print2a4(['./figures/bathymetry/hillshade_',datestr(D.time(t),'yyyymmdd')],'l','n','-r300','o');
end
end
%EOF