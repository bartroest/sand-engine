function [ID,IS,Z,jtime]=nemo_initize_jarkus(t1,t2,DL,S)
%nemo_initize_jarkus Returns indices and values of NeMo/ZM transects for which jarkus data exists.
%
%  Returns alongshore indices of the Delfland-transect-matrix for which
%  Jarkus is available.
%
%  For building the bathymetry:
%   1:load grid with NaNs
%   2:put in Jarkus
%   3:put in Zandmotor/Nemo (overwriting Jarkus);
%
%   Syntax: [index_jarkus,index_shore,altitude,time_topo]=...
%       nemo_initize_jarkus(t_index_start,t_index_end,Jarkus_data_struct,Shore_surveylines);
%
%   Input: 
%       t1: 1st jarkus time index (2011)
%       t2: last jarkus time index (now?)
%       DL: Jarkus Delfland data struct
%       S: Survey lines or Data struct
%
%   Output:
%   	ID: time index Jarkus
%       IS: time index Zandmotor
%       Z: merged altitude matrix
%       jtime: jarkus survey dates
%
%   Example:
%       dzdt = nemo_altitude_trend(D,'altitude');
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

t=t1:t2;
jtime=DL.time_topo(t)+datenum(1970,1,1);

[~,ID,IS]=intersect(round(DL.rsp_x),round(S.x_origin));
Z=nan([length(t), size(S.xi)]);
for i=1:length(t);
    for n=1:length(ID);
    Z(:,IS(n))=squeeze(DL.altitude(t1,ID(n),:));
    %Z(i,:,IS(n))=permute(DL.altitude(t(i),ID(n),:),[1 3 2]);
    end
end
