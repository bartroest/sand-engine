function h=nemo_plot_volume_stack(D,V,volume,index,t_index,caseing)
%NEMO_PLOT_VOLUME_STACK Plots a timestack of volume changes per transect of the whole survey area.
%
% Syntax: nemo_plot_volume_stack(Datastruct,Volume_changes,alongshore_index,t_index);
%
% Input: 
%   D: Data struct
%   V: Volume change struct
%   volume: volume fieldname ['dv','volume','accretion','erosion','dvdt']
%   index: alongshore indices
%   t_index: time indices or Time index struct
%   caseing: ['cumulative','anticumulative','difference','paper']
%
% Output:
% 	h: plot handles
%
% Example:
%   h=nemo_plot_volume_stack(D,V,'dv',1:644,Time,'dv');
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
figure;
switch caseing
    case {'cumulative','cum','c'}
        vv=nancumsum(V.(volume)(t_index,index),1);
        vv(vv==0)=nan;
        h(1)=pcolor(D.alongshore(index),D.time(t_index),vv);
        shading flat;
        tlim=D.time(t_index([1 end]));
    case {'anticumulative','anti','a'}
        h(1)=pcolor(D.alongshore(index),D.time(t_index),flipud(nancumsum(flipud(V.(volume)(t_index,index)),1)));
        shading flat;
        tlim=D.time(t_index([1 end]));
    case {'difference','diff','dv'}
%             t_index.all=   [1 2 3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38];
%             t_index.nemo=  [            7                       17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38];
%             t_index.vbnemo=[1 2 3 4 5 6 7 8 9 11 13 14 15    16 17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38];
        h(1)=pcolor(D.alongshore(index.nemo) ,D.time_nemo(t_index.nemo),V.nemo.(volume)(t_index.nemo,index.nemo));
        hold on
        shading flat
        h(2)=pcolor(D.alongshore(index.zm)   ,D.time(t_index.all)      ,V.all.(volume)(t_index.all ,index.zm)); 
        shading flat
        h(3)=pcolor(D.alongshore(index.vb)   ,D.time_vbnemo(t_index.vbnemo),V.vb.(volume)(t_index.vbnemo,index.vb));
        shading flat
        h(4)=pcolor(D.alongshore(index.zmplus),D.time_vbnemo(t_index.zmplus),V.vb.(volume)(t_index.zmplus,index.zmplus));
        shading flat
        tlim=D.time([1 end]);
    case {'paper'}
%             t_index.all=   [1 2 3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38];
%             t_index.nemo=  [            7                       17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38];
%             %t_index.vbnemo=[1 2 3 4 5 6 7 8 9 11 13 14 15    16 17 18 19 20    22 23 24 25 26 27 28    30 31 32 33 34 35 36 37 38];
        vn=nancumsum(V.nemo.(volume)(t_index.nemo ,index.nemo),1); vn(vn==0)=nan;
        h(1)=pcolor(D.alongshore(index.nemo) ,D.time_nemo(t_index.nemo),vn);
        hold on
        shading flat
        vz=nancumsum(V.zm.(volume)(t_index.all  ,index.zm),1); vz(vz==0)=nan;
        h(2)=pcolor(D.alongshore(index.zm)   ,D.time(t_index.all)      ,vz); 
        shading flat
        h(4)=pcolor(D.alongshore(index.zmplus),D.time_vbnemo(t_index.zmplus),V.vb.(volume)(t_index.zmplus,index.zmplus));
        shading flat
        pcolor(D.alongshore(index.vb)   ,D.time_vbnemo(t_index.vbnemo),V.vb.(volume)(t_index.vbnemo,index.vb));
        shading flat
        tlim=D.time([1 end]);
    otherwise
        h(1)=pcolor(D.alongshore(index),D.time(t_index),V.(volume)(t_index,index));
        tlim=D.time(t_index([1 end]));
end

csym; colormap(jwb(100,0.01));
%colormap(gca,jet);
shading flat; 
cb=colorbar;% colorbarwithtitle('Net volume change [m^3/m^1_{alongshore}]');
cb.Label.String='Net volume change [m^3/m_{alongshore}]';
xlabel('Alongshore distance from Hoek van Holland [m]');
ylabel('Time'); 
title('Timestack of net volume changes'); 
%title('Redistribution parameter \DeltaV_{net}/\DeltaV_{gross}');
datetickzoom('y','mmm-yy');
%axis tight;
box on;
ylim([tlim(1)-10 tlim(2)+10]);
xlim([-10 17250]);
end
%EOF