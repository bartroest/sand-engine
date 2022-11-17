function [V,PC,R,M,mask]=nemo_EOF(D,z,index,t_index)
%nemo_EOF - Performs Empirical Orthagonal Function analysis on transects.
% This script is very preliminary, and outcomes are most certainly
% incorrect.
%
% Bart Roest 2016
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
mask=~isnan(squeeze(D.(z)(t_index,index,:)));
summask=sum(mask,1);
mask=summask==length(t_index); %Only points for which data is available for every t.

M=squeeze(D.(z)(t_index,index,mask))';
%F=detrend(M,0);
%R=F'*F;
F=M;
R=(1/length(t_index)).*F'*F;
[C,L]=eig(R);

for i=1:length(t_index); 
    PC(:,i)=F*C(:,i); 
end
V=diag(L)/trace(L);
