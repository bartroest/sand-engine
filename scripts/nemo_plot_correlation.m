function nemo_plot_correlation(D,Q,t,idx,p1,p2,s)
%nemo_plot_correlation - plots the R^2 versus one dimension of D.
%
% Uses the output of NEMO_CORRELATOR
% See also: nemo_perform_all_correlations nemo_correlator

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
if nargin<4;
    t=1:size(Q.D,1);
    idx=1:size(Q.D,2);
    p1='Property1';
    p2='Property2';
end
figure;

axx=subplot_meshgrid(2,2,[0.05 0.1 0.05],[0.05 0.07 0.07],[0.54 0.26],[0.4 0.4]);

%% R-Alongshore
%subplot(2,3,[1,2]);
axes(axx(1))
hh(1)=plot(D.alongshore(1:length(Q.alongshore.rp)),Q.alongshore.rp,'.k'); %Plots r-p
hold on
%hh(2)=plot(D.alongshore(1:length(Q.alongshore.rp)),Q.alongshore.rs,'.k'); %Plots r-s
%plot(D.(dimension),Q.rs,'.k'); %Plots R^2
hold on
grid on
if min(Q.alongshore.rp)<0
    ylim([-1 1]);
else
    ylim([0 1]);
end
xlim([0 17500]);
title(['Correlation of ',p1,' and ',p2]);
xlabel('Alongshore distance from HvH [m]');
ylabel('Coefficient of correlation: r');
%legend(hh,'r-pearson','r-spearman','Location','Best');
%legend(hh,'r-pearson','Location','Best');

%% R-Time
%subplot(2,3,3);
axes(axx(2))
hh(1)=plot(D.time(1:length(Q.time.rp)),Q.time.rp,'.k'); %Plots r-p
hold on
%hh(2)=plot(D.time(1:length(Q.time.rs)),Q.time.rs,'xk'); %Plots r-s
%plot(D.(dimension),Q.rs,'.k'); %Plots R^2
hold on
grid on
if min(Q.time.rp)<0
    ylim([-1 1]);
else
    ylim([0 1]);
end
datetickzoom('x','yy');
xlim([D.time(1) D.time(end)]);
xlabel('Time [yr]');
ylabel('Coefficient of correlation: r');
%legend(hh,'r-pearson','r-spearman','Location','Best');


%% DE-Alongshore
%subplot(2,3,[4,5]);
axes(axx(3))
hold on
ax1=gca; %Primary axes
h1=plot(D.alongshore,Q.D(t,:),'+k');
xlabel('Alongshore distance from HvH [m]');
ylabel(p1);
xlim([0 17500]);
grid on
hold on

%Secondary axes
ax2=axes('Position',get(ax1,'Position'),'YAxisLocation','right','Color','none','YColor','k');
linkaxes([ax1 ax2],'x');
hold on
h2=plot(D.alongshore,Q.E(t,:),'xk');
ylabel(p2);
hold on

l=legend(ax2,[h1(1),h2(1)],'left','right','Location','Best');
l.Color=[1 1 1];

%% DE-Time
%subplot(2,3,6);
axes(axx(4))
hold on
ax3=gca; %Primary axes
g1=plot(ax3,D.time,Q.D(:,idx),'+k');
%g1=boxplot(ax3,Q.D(:,idx));
datetick('x','yy');
xlim([D.time(1) D.time(end)]);
xlabel('Time [yr]')
ylabel(p1);
grid on
%hold on

%Secondary axes
ax4=axes('Position',get(ax3,'Position'),'YAxisLocation','right','Color','none','YColor','k');
linkaxes([ax3 ax4],'x');
hold on
ylabel(p2);
g2=plot(D.time,Q.E(:,idx),'xk');
datetick('x','yy');
xlim([D.time(1) D.time(end)]);
hold on

%xlim([D.time(1) D.time(end)]);
hold on
%ax4.YAxislocation='right';
%ax4.XAxislocation='top';
l=legend(ax4,[g1(1),g2(1)],'left','right','Location','Best');
l.Color=[1 1 1];


%% PRINT
if nargin<7;
s=input('Title: ','s');
end
%suptitle(['Correlation of ',p1,' and ',p2]);
%print2a4(['./figures/corrs/',dimension,'/',s,'.png'],'l','n','-r200','o');
print2a4(['./figures/newcorrs/',s,'.png'],'l','n','-r200','o');
end