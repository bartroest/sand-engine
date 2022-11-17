function ax=nemo_plot_contours(D,Time,altitude);
%nemo_plot_contours Plot contour lines for subsequent surveys.
%
%   Input: 
%       D: Data struct
%       z: altitude fieldname, 'altitude'
%
%   Output:
%   	figures
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
%%
% figure;
% tlen=length(Time);
% for n=1:tlen;
%     % subplot(tlen,1,n);
%     ax(n)=axes('Position',[0,(0.9/tlen)*(n-1)+0.05,1,0.9/tlen]);
%     hold on;
%     contour(ax(n),D.ls,D.cs,squeeze(D.altitude(Time(n),:,:)),altitude,'-k');
%     pause;
%     hline(910,'-k');
%     axis equal;
%     xlim([7000 13000]);
%     ylim([800 2200]);
%     set(gca,'XTickLabel',' ')
%     set(gca,'YTickLabel',' ')
%     grid on;
%     text(7500,1800,datestr(D.time(Time(n)),'yyyy')); 
% end
% % end


for n=1:length(altitude)
    figure;
    co=jet(length(Time));
    for t=1:length(Time);
        contour(D.ls,D.cs,squeeze(D.altitude(Time(t),:,:)),[altitude(n) altitude(n)],'-','Color',co(t,:));
        hold on;
    end
    title([num2str(altitude(n),'%2.1f'),' m NAP contour'])
    xlabel('Alongshore distance [m]');
    ylabel('Cross-shore distance [m]');
end
% figure;
% subplot(3,2,1);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(1),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
% 
% subplot(3,2,2);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(2),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
% 
% subplot(3,2,3);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(3),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
% 
% subplot(3,2,4);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(4),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
% 
% subplot(3,2,5);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(5),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
% 
% subplot(3,2,6);
% contour(D.ls,D.cs,squeeze(D.altitude(Time.july(6),:,:)),[0 4.5],'-k');
% axis equal;
% xlim([7000 13000]);
% ylim([500 2500]);
% grid on;
