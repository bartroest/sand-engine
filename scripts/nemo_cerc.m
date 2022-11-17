function [S,CERC,phi]=nemo_lst_cerc(wtime,H,phi,index,t_index,D,CL)
%NEMO_CERC Determines the sediment transport rate according to the CERC formula.
%
% Early attempt to calculate alongshore transport rates from wave timeseries via
% the CERC formula.
%
% Syntax:
%   [S,CERC,phi]=nemo_lst_cerc(wtime,H,phi,index,t_index,D,CL)
%
% Input: 
%   wtime: datenums of the wave timeseries
%   H: timeseries of waveheights (m).
%   phi: timeseries of wave direction (deg N).
%   index: index of alongshore location
%   D: datastruct
%   CL: coastline orientation struct.
%
% Example
%   [S,CERC,phi]=nemo_lst_cerc(W.time,W.hm0,W.hdir,index,t_index,D,CL)
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

%% parameter settings
rhow=1024;      %[1]
rhos=2650;      %[1]
g=9.81;         %[1]
s=rhos/rhow;    %[1]
p=0.40;         %[1]
gamma=0.78;     %[1]
K=0.40;         %[1]

S=nan(length(D.time),length(D.alongshore));
%H=1.5;
%phi=-90:1:90;
%E=1/8*rhow*g*H^2;
%n=
%% Intermediate
% % % H=golfdata(D.time([t_index(1) t_index(end)])); %[1]
% % % theta_waves=golfdata(D.time([t_index(1) t_index(end)]));
% % % 
% % % theta_coast=CL.ang(t_index(1),index);
% % % phi=theta_coast-theta_waves;
for t=1:length(t_index)-1;
    mask=wtime>=D.time(t_index(t)) & wtime<=D.time(t_index(t+1));
    H_mask=H(mask);
    for n=index;
        phi_rel=phi(mask)-(311.2-CL.ang(t_index(t),n));
        phi_rel=20.15*sind(1.378*phi_rel);
%% formula
%S=K/(rho*g(s-1)*(1-p))*(E*n*c)*cos(phi)*sin(phi);
%S=K./(16.*(s-1).*(1-p)).*sqrt(g/gamma).*sind(2.*phi).*H.^2.5;
        CERC=K/(16*(s-1)*(1-p))*sqrt(g/gamma).*sind(2.*phi_rel).*H_mask.^2.5; %[m^3/m/s]
        S(t_index(t),n)=nansum(CERC*3600);%/(D.time(t_index(t+1))-D.time(t_index(t)));
    end
end

phi=phi-311.2;
CERC=K./(16.*(s-1).*(1-p)).*sqrt(g/gamma).*sind(2.*(phi)).*H.^2.5;