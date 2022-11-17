function Vcomp=nemo_composite_volume(V,Index)
%NEMO_COMPOSITE_VOLUME Builds a composite matrix for volumes, based on alongshore position.
% As the different areas of the Delfland coast are surveyed at different
% moments, volumes must be determined over the appropriate intervals. This
% script combines the different intervals from the different survey areas.
%
% Based on <Nemo|Zandmotor|Vlugtenburg> area.
% VB=94:160;
% ZM=305:428;
% Nemo=1:304,429:644 || 1:93,161:304,429:644;
%
%   Syntax:
%   Vcomp=nemo_composite_volume(V,Index)
%
%   Input: 
%       V: Volume struct
%       Index: alongshore indices struct
%
%   Output:
%   	Vcomp: combined volumes.
%
%   Example
%       V.comp=nemo_composite_volume(V,Index);
%
%   See also: nemo, nemo_volumes

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
fn=fieldnames(V);
if ~any(strcmp(fn,'zm')) || ~any(strcmp(fn,'vb')) || ~any(strcmp(fn,'nemo'));% || ~any(strcmp(fn,'all'));
    fprintf(1,'Please first construct V.zm V.vb, V.nemo and V.all\n');
    return
elseif ~any(strcmp(fn,'zmplus')) && size(V.all.volume,1)>38;
    fprintf(1,'Please first construct V.zmplus\n');
    return
end

fn=fieldnames(V.all);

for f=1:length(fn);
    try
        Vcomp.(fn{f})=                 V.nemo.(fn{f});               %Start with NeMo
%         Vcomp.(fn{f})(:,Index.vb)    = V.vb.(fn{f})(:,Index.vb);     %Overwrite VB area
        if size(V.all.volume,1)>38
        Vcomp.(fn{f})(:,Index.zmplus)= V.zmplus.(fn{f})(:,Index.zmplus); %Overwrite ZM-plus area
        end
        Vcomp.(fn{f})(:,Index.zm)    = V.zm.(fn{f})(:,Index.zm);    %Overwrite ZM area
    catch
%         Vcomp.(fn{f})=V.all.(fn{f});
        fprintf(1,'field %s did not match \n',fn{f});
    end
end
end
%EOF