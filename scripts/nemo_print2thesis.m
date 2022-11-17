function nemo_print2thesis(fname,pl,nr,resolution)
%nemo_print2thesis Prints figures in pre-defined format to fit nicely in my MSc-thesis :)
%                  +--------+
%                  |    p,r |
%                  |        |
%  +-------------+ |Portrait|
%  | ^up   l,n   | |Rotated |
%  | Landscape   | |        |
%  | Normal      | |< up    |
%  +-------------+ +--------+
%
%                  +--------+
%                  |^ up    |
%                  |        |
%  +-------------+ |Portrait|
%  |Landscape    | |Normal  |
%  |Rotated      | |        |
%  |< up    l,r  | |    p,n |
%  +-------------+ +--------+
%
%   Syntax:
%       nemo_print2thesis(fname,portrait/landscape,normal/rotated,resolution)
%
%   Input: 
%       fname: filename or full path
%       pl: portrait 'p' or landscape 'l'
%       nr: normal 'n' or rotated 'r'
%       resolution: dpi, scalar.
%
%   Output:
%   	png figure
%
%   Example:
%       nemo_print2thesis('test.png','l','n',300);
%
%   See also: nemo, print

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


%print met heeel veel wazige inputs.

%PO = 'portrait';
%LR = 10.5000;
%UD = 14.8500;
switch pl
    case {'portrait','p'}
        switch nr
            case {'n'}
                PO='portrait';
                LR=10.5000;
                UD=14.8500;
            case {'r'}
                PO='landscape';
                UD=10.5000;
                LR=14.8500;
        end
    case {'landscape','l'}
        switch nr
            case {'n'}
                PO='portrait';
                UD=10.5000;
                LR=14.8500;
            case {'r'}
                PO='landscape';
                LR=10.5000;
                UD=14.8500;
        end
end

set(gcf,...
    'PaperSize',[LR UD],...
    ...'PaperType'       ,'a6',...
    'PaperUnits'      ,'centimeters',...
    'PaperPosition'   ,[0 0 LR UD],...
    'PaperOrientation',PO);

%[fileexist,action]=filecheck(fullfile(filepathstr(fname),[filename(fname),fext]),overwrite_append);
%if strcmpi(action,'o')
%    if ~exist(filepathstr(fname),'dir')
%    mkdir(filepathstr(fname))
%    end
print('-dpng'  ,['./figures/',fname,'.png'],resolution);
print('-depsc2',['./eps/'   ,fname,'.eps' ],resolution);
%end
end