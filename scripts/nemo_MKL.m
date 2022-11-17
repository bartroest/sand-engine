function [xMKL, vMKL]=nemo_MKL(D,z,index,t_index,varargin)
%NEMO_MKL calculates the MKL position for given transects.
% Calculate Momentary Coast Line (MKL) positions for arbitrary transects in the
% Delfland coastal cell. Outputs timestacks of MKL positions and optionally
% representative coastal volumes.
%
% Input:
%   D: datastruct
%   z: altitude fieldname
%   index: alongshore indices
%   t_index: time indices
%   propertyname,propertyvalue pairs:
%       upperB: Upper boundary (MLW+h) (scalar or [alongshore 1])
%       lowerB: Lower boundary (MLW-h) (scalar or [alongshore 1])
%       plot: Obtains plot from jarkus_getVolume(Fast).m
%
% Output:
%   xMKL: cross-shore position of the MKL
%   vMKL: volume of the MKL area
%
% Example:
%   [xMKL, vMKL]=nemo_MKL(D,'altitude',1:612,1:37);
%
% See also: nemo, jarkus_getMKL, jarkus_getVolume, jarkus_getVolumeFast.

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

xMKL=nan(length(D.time),length(D.alongshore));
vMKL=xMKL;

OPT.upper=  3*ones(size(D.alongshore'));
OPT.lower=-4.4*ones(size(D.alongshore'));
OPT.plot=false;

setproperty(OPT,varargin)

if isscalar(OPT.upper)
    OPT.upper=repmat(OPT.upper,length(D.alongshore),1);
end
if isscalar(OPT.lower)
    OPT.lower=repmat(OPT.lower,length(D.alongshore),1);
end

%mlw=D.mean_low_water;
%mask=~isnan(D.mean_low_water);
%mlw=interp1(D.alongshore1(mask),D.mean_low_water(mask),D.alongshore1);
%OPT.lower=OPT.upper-2*(OPT.upper-mlw);


%% Calculate MKLs
%warning off
for t=t_index;
    for i=index;
        if sum(~isnan(squeeze(D.(z)(t,i,:))))>10 && max(squeeze(D.(z)(t,i,:)))>=OPT.upper(i) && max(squeeze(D.(z)(t,i,:)))>=OPT.lower(i);
            mask=~isnan(squeeze(D.(z)(t,i,:)));
            if nargout>1;
                [xMKL(t,i), vMKL(t,i)]=jarkus_getMKL(D.dist(mask),squeeze(D.(z)(t,i,mask)),OPT.upper(i),OPT.lower(i));
            else
                xMKL(t,i)=jarkus_getMKL(D.dist(mask),squeeze(D.(z)(t,i,mask)),OPT.upper(i),OPT.lower(i));
            end
        %else
        %    fprintf(1,'No data on line %3.0f for t=%2.0f \n',i,t);
        end
    end
end
%warning on
end
%EOF