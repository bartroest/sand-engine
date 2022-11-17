function [slope, slope_ls]=nemo_get_slope(D,z,t_index)
%NEMO_GET_SLOPE Calculates the pointwise cross-shore slope of transects.
%
% Syntax: slope_matrix=nemo_get_slope(Datastruct,'altitude',time_indices)
%
% Example:
%   slope = nemo_get_slope(Datastruct,'altitude',time_indices)
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

slope=nan(size(D.(z)));
%dx=nanmean(diff(D.dist));
if nargout>1; slope_ls=slope; end
for t=t_index;
    %mask=squeeze(~isnan(D.(z)(t,:,:)));
    %slope(t,:,:)=diff(D.(z)(t,mask),[],3)./dx;
    slope(t,:,2:end)=squeeze(diff(D.(z)(t,:,:),1,3))./diff(D.dist)'; %dx=5m;
    if nargout>1
        slope_ls(t,2:end,:)=squeeze(diff(D.(z)(t,:,:),1,2))./diff(D.ls,1,1);
    end
end