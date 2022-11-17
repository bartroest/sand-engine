function nemo_print2paper(filename,size,printformat,fig)
%NEMO_PRINT2PAPER Prints figures in multiple formats for in my research paper
%
%   Prints high-resolution and vector figures for use in publications.
%   Parameters are adjusted to journal requirements.
%   Prints a png-file (raster) and eps- and pdf-file (vector).
%
%   Syntax:
%   	nemo_print2paper(filename,size,printformat,fig)
%
%   Input: 
%       filename: name or path of figure
%       size: size of printed figure in cm [width height]
%       printformat: type of figure
%       fig: figure number or handle to print
%
%   Output:
%   	figures.
%
%   Example:
%       nemo_print2paper('test.png');
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

if nargin<2;
    size=[18.35 24]; %default size
end
if nargin<3;
    printformat='-depsc'; %default printer
end
if nargin<4;
    fig=gcf; %default figure to print
end

set(fig,'PaperUnits','centimeters','PaperSize',size,'PaperPosition',[0 0 size],'PaperOrientation','portrait');
print(['./figures/paper/',filename],printformat,'-loose','-r600');
if ~strcmpi(printformat,'-dpng'); %Plot a png regardsless, for easy access!
    print(['./figures/paper/',filename],'-dpng','-loose','-r600');
end

%maybe use polygone? > Nope does not result in smaller eps figures.
%!polygone.exe ./figures/paper/map.eps

if strncmpi('-deps',printformat,5);
    eps2pdf(fullfile(pwd,'figures','paper',filename,'.eps'),...
            fullfile(pwd,'figures','paper',filename,'.pdf'));
end
end