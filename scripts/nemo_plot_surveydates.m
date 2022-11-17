function nemo_plot_surveydates(D);
%nemo_plot_surveydates Plots an overview of the different survey dates.
%
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
figure;
%figure('Units','centimeters','Position',[5 5 20 8]);
hold on;
ax=gca;
g1=plot(ax,D.time,1,'d','Color',[0 0.35 0.75],'MarkerFaceColor',[0 0.4 0.9]); %ZM
g2=plot(ax,D.time_nemo(D.time_nemo>1),1.1,'s','Color',[0.8 0.8 0],'MarkerFaceColor',[1 1 0]); %NEMO
g4=plot(ax,D.time_jarkus(D.time_jarkus>1),1.2,'v','Color',[0.8 0 0],'MarkerFaceColor',[1 0 0]); %Jarkus
%g3=plot(D.time_vb(D.time_vb>1),1.3,'^b','MarkerFaceColor','b'); %VB
%g5=plot(M.time,1.4,'*m','MarkerFaceColor','m'); %MB

% text(D.time(1),1.04,'Sand Engine');
% text(D.time(1),1.14,'Nemo');
% %text(D.time(1),1.34,'Vlugtenburg');
% text(D.time(1),1.24,'Jarkus');
%text(D.time(1),1.44,'Mulitbeam');

set(gca,'XTick',[datenum(2011,07,07):365/2:datenum(2017,02,01)]);
xlim([D.time(1)-40,D.time(end)+40]);
%set(gca,'XTickLabelRotation',90);
xlabel('Time')

ylim([0.95 1.25])
%set(gca,'YTickLabel','');
ax.YTick = [1, 1.1, 1.2];
ax.YTickLabel = {'Sand Engine','Nemo','Jarkus'};
ylabel('Surveyed area');

box on;

datetickzoom('x','mmm-''yy','keepticks');
%ff=gcf;
%ff.PaperPosition=[1 5 20 8];

%print('./figures/surveys','-r200','-dpng')