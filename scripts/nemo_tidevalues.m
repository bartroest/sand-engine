function [mhw, mlw, msl]=nemo_tidevalues(D)
%NEMO_TIDEVALUES Interpolates mean tidal values between HVH and SCH.
% Gemiddelde getijstanden volgens RWS2013.
% Lineaire interpolatie tussen HVH en SCH.
%
%   Syntax:
%       [mhw, mlw, msl]=nemo_tidevalues(D)
%
%   Input: 
%       D: Data struct
%
%   Output:
%   	mhw: mean high water level [m NAP]
%   	mlw: mean low water level [m NAP]
%   	msl: mean sea level [m NAP]
%
%   Example:
%       [mhw, mlw, msl]=nemo_tidevalues(D);
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
% Hoek van Holland
hvh.mhw=1.15;
hvh.mlw=-0.60;
hvh.msl=0.09;
hvh.x=67932;
hvh.y=444000;

% Scheveningen
sch.mhw=1.07;
sch.mlw=-0.69;
sch.msl=0.02;
sch.x=78006;
sch.y=457360;

% IJmuiden
ijm.mhw=1.01;
ijm.mlw=-0.68;
ijm.msl=0.04;
ijm.x=98507;
ijm.y=497450;
ijm.pos=sqrt((ijm.x-D.rsp_x(1))^2+(ijm.y-D.rsp_y(1))^2);

x(1)=D.alongshore(1); %HVH
x(2)=D.alongshore(618); %SCH
x(3)=ijm.pos; %IJM

mhw=interp1(x,[hvh.mhw sch.mhw ijm.mhw],D.alongshore);
mlw=interp1(x,[hvh.mlw sch.mlw ijm.mlw],D.alongshore);
msl=interp1(x,[hvh.msl sch.msl ijm.msl],D.alongshore);
end