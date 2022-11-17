function nemo_plot_slopeandmap(D,index,dhdx,t_index)
%nemo_plot_slopeandmap Plots the CS-slope of a certain survey and a contour map.
%
% Input:
%   D: datastruct
%   index: alongshore indices
%   dhdx: 
%   t_index: time index for surveys to plot
%
%
%   See also: nemo, nemo_volumes_h, nemo_build_slope

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
% % dhdx=nan(size(VH.volume,1),size(VH.volume,2),size(VH.volume,3)-1); 
% % for t=t_index; %1:size(VH.volume,1); 
% %     dhdx(t,:,:)=0.25./(diff(squeeze(VH.volume(t,:,:)./0.25),1,2)); 
% % end
%% PRE_PROC DHDX
% Get rid of gibberish
for n=1:size(dhdx,2);
    n1=find(~isnan(dhdx(t_index,n,:)),1,'first'); if ~isempty(n1); dhdx(t_index,n,n1)=nan; end;
    n2=find(~isnan(dhdx(t_index,n,:)),1,'last');  if ~isempty(n1); dhdx(t_index,n,n2)=nan; end;
end


%m=-log10(-(squeeze(dhdx(t_index,:,:))))';
%m=-log10(-(squeeze(atand(dhdx(t_index,:,:)))))';

%% PLOT
figure;
ax1=subplot(4,1,1);  
[~,h(1)]=contour(D.L(index,:),D.C(index,:),squeeze(D.altitude(1,index,:)),[-4,0],'--k');
hold on;
[~,h(2)]=contour(D.L(index,:),D.C(index,:),squeeze(D.altitude(t_index,index,:)),[-4,0],'-k');
grid on;
axis equal;
ylim([0 1500]);
xlabel('Distance from HvH [m]');
ylabel('Distance from RSP [m]');
legend(h,{'Surv 1',['Surv ',num2str(t_index,'%2.0f')]});
title(['Survey ',datestr(D.time(t_index),'dd-mmm-yyyy'),' 0m and -4m+NAP depth contours']);

ax2=subplot(4,1,[2:4]);
%pcolor(D.L,D.C,squeeze(slope(7,:,:))); shading flat; ylim([-200 2000]); colormap(gca,gray);
%pcolor(D.alongshore,VH.heights(2:end-1),-atand(squeeze(dhdx(t_index,:,:)))'); shading flat;
%pcolor(D.alongshore,-12:0.25:6,-atand(squeeze(dhdx(t_index,:,:)))'); shading flat;
pcolor(D.alongshore1(index),-12:0.25:6,atand(squeeze(dhdx(t_index,index,:)))'); shading flat;
%pcolor(D.alongshore,VH.heights(2:end-1),m); shading flat;
%pcolor(D.alongshore,VH.heights(2:end-1),atand(squeeze(dhdx(t_index,:,:)))'-atand(squeeze(dhdx(1,:,:)))'); shading flat;
%clim([-15 0]);
    %clim([0.5 2.5])
ylim([-12 6]);
title('Cross-shore slope')
xlabel('Distance from HvH [m]');
ylabel('Altitude [m+NAP]');

%% COLORBAR TWEAKING
pos=ax2.Position;
cl=clim;
cb=colorbar('Position',[ 1.02*pos(1)+pos(3), pos(2), 0.015, pos(4)]);
cb.Label.String='Cross-shore slope [degrees]';%'1/CS-slope [1/rad]';
%cb.Ticks=linspace(cl(1),cl(2),8);
%cb.TickLabels=cellstr(num2str(10.^(cb.Ticks)','%4.2f'));

end
%EOF