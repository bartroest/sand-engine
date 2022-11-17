function nemo_xcorr_profile(D,z,index,t_index)
%NEMO_XCORR_PROFILE Cross correlates profiles at different timesteps.
%
%   Syntax:
%   trend = nemo_xcorr_profile(D,z,index,t_index)
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%       index: alongshore index (scalar)
%       t_index: time indices to cross-correlate t_index(1) is reference.
%
%   Output:
%   	figures
%
%   Example:
%       nemo_xcorr_profile(D,'altitude',312,1:37);
%
%   See also: nemo, xcorr

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

%% Plot cross correlations
figure; hold on; f=gca;
figure; hold on; g=gca;
figure; hold on; h=gca;
for t=t_index;
    mask=~isnan(squeeze(D.(z)(t_index(1),index,:))) & ~isnan(squeeze(D.(z)(t,index,:))) & D.dist>=600;
    [acorr, lags]=xcorr(squeeze(D.(z)(t_index(1),index,mask)),squeeze(D.(z)(t,index,mask)),'coeff');
    
    
    plot(f,lags, acorr, '.');
    plot(g,D.dist(mask),squeeze(D.(z)(t_index(1),index,mask)),'.-k',D.dist(mask),squeeze(D.(z)(t,index,mask)),'.-r');
    plot(h,squeeze(D.(z)(t_index(1),index,mask)),squeeze(D.(z)(t,index,mask)),'.');
end
