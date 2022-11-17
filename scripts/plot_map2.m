%PLOT_MAP2 Plot a North Sea Map
%   Syntax:
%   PLOT_MAP2(CoorType)
%   PLOT_MAP2(CoorType,linespec,...);
%
%   Arguments:
%   <CoorType> The type of coordinates for the map to be ploted,
%   which can take the following values:
%           'par'    Paris coordinates
%           'rd'     Rijksdriehoek (same as 'par')
%           'lonlat' Longitude and Latitude coordinates (WGS84)
%           'utm'    Universal
%
%   NOTE : If <CoorType> is not given then CoorType = 'par'
%   See also: plot_log10, plot_value, plot_value

%   Copyright: Deltares, the Netherlands
%        http://www.delftsoftware.com
%        Date: 05.06.2009
%      Author: S. Gaytan Aguilar

%--------------------------------------------------------------------------
function plot_map2(varargin)

if nargin ==0
    coordin = 'par';
elseif nargin>1
    coordin = varargin{1};
    extraSpec = {varargin{2:end}};
else
    coordin = varargin{1};
end

%set(gcf,'Color','w');
objaxes = gca;

% Load data for map
load([oetroot,'applications\Rijkswaterstaat\donar_dia_toolbox_BETA\private\shoreline_euro.mat'],'shoreline');

% Selecting type of coordinates
switch coordin
    case {'par','rd','xy'}
        x = shoreline.xpar;
        y = shoreline.ypar;
        axesLimit = [-0.36 0.430 0.165 1.01]*1.0e+006;
        tmap  = 'tickmap(''xy'')';
    case {'lonlat','ll'}
        x = shoreline.lon;
        y = shoreline.lat;
        axesLimit = [-1.9576 9.9379 49.1936 57.2572];
        tmap  = 'tickmap(''ll'')';
    case 'utm'
        x = shoreline.xutm;
        y = shoreline.yutm;
        axesLimit = [1.4 9.2 54.6 63.9]*1.0e+005; 
        tmap  = 'tickmap(''xy'')';
end
clear shoreline

% Axis limits
ibound = x>axesLimit(2) | x<axesLimit(1) | y>axesLimit(4) | y<axesLimit(3);
x(ibound) = nan;
y(ibound) = nan;

% Plot shoreline
if nargin>1
    plot(x, y, 'Parent',objaxes,extraSpec{:});
else
    plot(x, y, 'Parent',objaxes,'color','k');
end
axis square
axis(axesLimit)
%set(gca,'xticklabel',{})
%set(gca,'yticklabel',{})
eval(tmap)

