function [ct, parn]=nemo_corr_table(Q,idx,dvfld,op);
%NEMO_CORR_TABLE Presents a table with correlation coefficients.
%
%   Presents all correlation coefficients calculated between volume change and
%   hydrodynamic conditions.
%
%   Syntax:
%   [ct, parn]=nemo_corr_table(Q,alongshore_index,net/gross,op);
%
%   Input: 
%       Q: Correlations struct
%       idx: alongshore index
%       dvfld: net or gross volume change and window: 'dvn500'
%
%   Output:
%   	parn: correlated parameter
%
%   Example
%   dzdt = nemo_altitude_trend(D,'altitude');
%
%   See also: nemo, nemo_corr_all

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

parn=fieldnames(Q.(dvfld).(op));
ct=nan(length(parn),length(idx));

for n=1:length(parn);
    ct(n,:)=Q.(dvfld).(op).(parn{n}).alongshore.rp(idx);
end