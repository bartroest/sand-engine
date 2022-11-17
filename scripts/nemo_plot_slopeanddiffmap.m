function nemo_plot_slopeanddiffmap(D,VH,dhdx,t_1,t_2)
%nemo_plot_slopeandmap Plots the CS-slope of a certain survey and a contour map.
%
% Input:
%   D: datastruct
%   VH: Horizontal volume struct
%   dhdx: beach slope
%   t_1: time index 1
%   t_2: time index 2
%
%   See also: nemo, nemo_volumes_h

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

%dang=atan(squeeze(dhdx(t_2,:,:)))'-atan(squeeze(dhdx(t_1,:,:)))';
%sgn=sign(dang);
%absdang=sgn.*dang;
%
%m=-log10(absdang);
%n=m.*sgn;
%% PRE_PROC DHDX
% Get rid of gibberish
for n=1:644;
    n1=find(~isnan(dhdx(t_1,n,:)),1,'first'); if ~isempty(n1); dhdx(t_1,n,n1)=nan; end;
    n2=find(~isnan(dhdx(t_1,n,:)),1,'last');  if ~isempty(n1); dhdx(t_1,n,n2)=nan; end;
    
    n1=find(~isnan(dhdx(t_2,n,:)),1,'first'); if ~isempty(n1); dhdx(t_2,n,n1)=nan; end;
    n2=find(~isnan(dhdx(t_2,n,:)),1,'last');  if ~isempty(n1); dhdx(t_2,n,n2)=nan; end;
end

%% PLOT
figure;
ax1=subplot(4,1,1);  
[~,h(1)]=contour(D.L,D.C,squeeze(D.altitude(1,:,:)),[-4,0],'--k');
hold on;
[~,h(2)]=contour(D.L,D.C,squeeze(D.altitude(t_2,:,:)),[-4,0],'-k');
grid on;
axis equal;
ylim([0 1500]);
xlabel('Distance from HvH [m]');
ylabel('Distance from RSP [m]');
legend(h,{['Surv ',num2str(t_1,'%2.0f')],['Surv ',num2str(t_2,'%2.0f')]});
title(['Surveys ',datestr(D.time(t_1),'dd-mmm-yyyy'),' and ',datestr(D.time(t_2),'dd-mmm-yyyy'),' 0m and -4m+NAP depth contours']);

ax2=subplot(4,1,[2:4]);
%pcolor(D.L,D.C,squeeze(slope(7,:,:))); shading flat; ylim([-200 2000]); colormap(gca,gray);
%pcolor(D.alongshore,VH.heights(2:end-1),atan(squeeze(dhdx(t_index,:,:)))'); shading flat;
%pcolor(D.alongshore,VH.heights(2:end-1),n); shading flat;
pcolor(D.alongshore,VH.heights(2:end-1),atand(squeeze(dhdx(t_1,:,:)))'-atand(squeeze(dhdx(t_2,:,:)))'); shading flat;

clim([-5 5]);
%clim([0.5 2.5])
ylim([-12 6]);
title('Change in cross-shore slope')
xlabel('Distance from HvH [m]');
ylabel('Altitude [m+NAP]');

%% COLORBAR TWEAKING
pos=ax2.Position;
cl=clim;
cb=colorbar('Position',[ 1.02*pos(1)+pos(3), pos(2), 0.015, pos(4)]);
cb.Label.String='\leftarrow Milder | \Delta\alpha [degrees] | Steeper \rightarrow';%'1/CS-slope [1/rad]';
%cb.Ticks=linspace(cl(1),cl(2),8);
%cb.TickLabels=cellstr(num2str(10.^(cb.Ticks)','%4.2f'));

end
%EOF