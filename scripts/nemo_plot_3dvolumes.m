function nemo_plot_3dvolumes(D,volumes,printswitch)
%NEMO_PLOT_3DVOLUMES plots a 3d timestack of volume changes.
%
%   3D visualisation of net volume change alongshore vs time.
%
%   Syntax:
%   	nemo_plot_3dvolumes(D,volumes,printswitch)
%
%   Input: 
%       D: Data struct
%       volumes: volume change matrix [time alongshore]
%       printswitch: print? [true|false]
%
%   Example:
%       nemo_plot_3dvolumes(D,V.comp.dv,0);
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

vv=nancumsum(volumes,1); vv(vv==0)=nan;

figure;
ss=surf(D.alongshore,D.time,vv,repmat(D.time,1,644));
ss.EdgeAlpha=0.5;

xlim([0 17250]);
zlim([-3500 2500]);
xlabel('Distance from HvH [m]'); ylabel('Time'); datetickzoom('y','mm-''yy');
view(-180,0);

cb=colorbar;
cb.Ticks=D.time;
cb.TickLabels=datestr(D.time,'mm-yyyy');

if printswitch
    print2a4(['./figures/Volume_change_timecolor1'],'l','n','-r200','o');
end
%%
figure;
ss=surf(D.alongshore,D.time,vv,vv);
ss.EdgeAlpha=0.5;

xlim([0 17250]);
zlim([-3500 2500]);
xlabel('Distance from HvH [m]'); ylabel('Time'); datetickzoom('y','mm-''yy');
%view(-180,0);

cb=colorbar;
clim([-3000 2000]);

if printswitch
    print2a4(['./figures/Volume_change_timecolor1'],'l','n','-r200','o');
end