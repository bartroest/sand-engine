function x=nemo_erosive_extent(D,V)% ,Time) %,Index)
%NEMO_EROSIVE_EXTENT UNFINISHED! Determines the alongshore extent of the erosive area.
%
%   Input: 
%       D: Data struct
%       V: Volume struct
%
%   Output:
%   	x: alongshore limits of erosion.
%
%   Example
%   dzdt = nemo_altitude_trend(D,'altitude');
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
mask=D.alongshore>8500 & D.alongshore<11500;
% % for t=1:length(Time.july)-1;
% %     dv(t,:)=smooth1_nan(nansum(V.comp.dv(Time.july(t):Time.july(t+1),:)));
% %     xcr=findCrossings(D.alongshore(mask),dv(t,mask)',D.alongshore(mask),zeros(size(D.alongshore(mask))));
% %     x(t,:)=xcr(1:2);
% % end

%glijdende schaal
for t=1:length(D.time);
    t1=t;
    t2=find(abs(D.time-(D.time(t)+365))==min(abs(D.time-(D.time(t)+365))));
    tt1(t)=t1;
    tt2(t)=t2;
    dv(t,:)=smooth1_nan(nansum(V.comp.dv(t1:t2,:)));
    xcr=findCrossings(D.alongshore(mask),dv(t,mask)',D.alongshore(mask),zeros(size(D.alongshore(mask))));
    xx(t,:)=xcr(1:2);
end

mask=D.alongshore>7000 & D.alongshore<8500;
for t=1:length(D.time);
    t1=t;
    t2=find(abs(D.time-(D.time(t)+365))==min(abs(D.time-(D.time(t)+365))));
    tt1(t)=t1;
    tt2(t)=t2;
    dv(t,:)=(nansum(V.comp.dv(t1:t2,:)));
    xcr=findCrossings(D.alongshore(mask),dv(t,mask)',D.alongshore(mask),zeros(size(D.alongshore(mask))));
    xa1(t,1:5)=nan;
    try 
        xa1(t,1:min([5,length(xcr)]))=xcr(1:min([5,length(xcr)]));
    catch 
    end
end

figure; 
pcolor(D.alongshore,mean([D.time(tt1) D.time(tt2)],2),dv);
shading flat
colormap(jwb(100,0.01)); csym;
xlim([0 17500]);
clim([-200 200]);
colorbar;   
datetick('y','mmm-''yy');
xlabel('Distance from HvH [m]');
ylabel('Mean time [mm-''yy]');
title('Annual cummulative net volume change [m^3/m^1], moving window')

