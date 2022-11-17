%NEMO_TRACKER Tracks different marco features of the Sand Engine
%
%   Early attempt to track the macro-morphological features of the Sand Engine
%   peninsula, such as cross-shore and alongshore extent, centre of mass etc.
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

%% Cross-shore extent
% for t=1:length(D.time); [~,~,C(t,:)]=nemo_depth_contour_accurate(D,'z_jnz',0,t); end
% 
% extent=nanmax(C(:,Index.zm),2); %maximum cs-extent
% for t=1:length(D.time);
%     idx(t)=find(C(t,Index.zm)==extent(t));
% end
% %cmax1=nanmax(C(1,Index.zm));
% %idx=find(C(1,:)==cmax1);
% extent1=C(:,Index.zm(idx(1))); %extent of the profile of t=1

%% Position of maximum CS-extent
%%%lspos=D.alongshore(Index.zm(idx)); %alongshore position of the point of maximum extent.
ym=nan(size(D.time,1),3);
lm=ym;
%d=[-8,-5,-2,0,2,3];
d=-10:2:0;
for t=Time.all;
    for n=1:length(d);
    [~,l,y]=nemo_depth_contour_accurate(D,'altitude',d(n),t); 
    ym(t,n)=max(y(Index.zm)); 
    lm(t,n)=D.alongshore(y==ym(t,n));
    ymean(t,n)=nanmean(y(362:375));
    yyy=smooth1_nan(y);
    lmean(t,n)=D.alongshore(yyy==max(yyy(Index.zm)));
%         if n==6;
%             cs(t,:)=y;
%         end
    end
end
%%
figure; 
subplot(1,2,1);
    plot(D.time(Time.all),ymean(Time.all,:),'x-');
    %figure; plot(D.time(Time.all),ym(Time.all,:),'x-');
    xlim([D.time(1)-30 D.time(end)+30])
    datetick('x','mmm-''yy','keeplimits');
    xlabel('Time')
    ylabel('Distance from RSP [m]');
    title('Maximum cross-shore extent of the Sand Engine');
%    legend(num2str(d'),'Location','Best');

subplot(1,2,2);
    plot(D.time(Time.all),lmean(Time.all,:),'x-');
    xlim([D.time(1)-30 D.time(end)+30])
    datetick('x','mmm-''yy','keeplimits');
    xlabel('Time')
    ylabel('Alongshore position of max amplitude [m]');
    title('Alongshore position of max CS-extent of the Sand Engine');
    legend(num2str(d'),'Location','NW');

%% Alongshore extent

for t=1:length(D.time); [CL.ang(t,:),CL.ang_g(t),CL.ls(t,:),CL.cs(t,:),CL.curv(t,:),CL.dist(t,:)]=nemo_coastline_orientation(D,'altitude',1,t,6,false); end
for t=1:length(D.time); stc(t,:)=std(CL.dist(1:t,:),0,1,'omitnan'); end;
for t=1:length(D.time); varc(t,:)=var(CL.dist(1:t,:),0,1,'omitnan'); end;
threshval=1000;
%LEFT BOUND
mask=D.alongshore>7000 & D.alongshore<8700;
for t=1:length(D.time);
    crossing=findCrossings(D.alongshore(mask),varc(t,mask)',[7000 8700],[threshval threshval]);
    cr=      findCrossings(D.alongshore(mask),CL.dist(t,mask)',[7000 14000],[240 240]);
    %Crossings(t).x=crossing;
    try; x1(t,1)=crossing(end); catch; x1(t,1)=nan; end;
    try; x1(t,2)=cr(end);       catch; x1(t,2)=nan; end;
end
%RIGHT BOUND
mask=D.alongshore>10500 & D.alongshore<13500;
for t=1:length(D.time);
    crossing=findCrossings(D.alongshore(mask),varc(t,mask)',[7000 14000],[threshval threshval]);
    cr=      findCrossings(D.alongshore(mask),CL.dist(t,mask)',[10500 14000],[250 125]);
    %Crossings(t).x=crossing;
    try; x2(t,1)=crossing(end); catch; x2(t,1)=nan; end;
    try; x2(t,2)=cr(end);       catch; x2(t,2)=nan; end;
end

%% ZWAARTEPUNT X
    for t=1:length(D.time); [CL.ang(t,:),CL.ang_g(t),CL.ls(t,:),CL.cs(t,:),CL.curv(t,:),CL.dist(t,:)]=nemo_coastline_orientation(D,'altitude',0,t,6,false); end
    binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
    q=nemo_gaus_fit(D,CL.ls,CL.cs,250:500,Time.all,0);

for t=1:length(D.time);
    mx(t)=nansum(((CL.cs(t,250:500)-q.e(t)).*binwidth(250:500)').*D.alongshore(250:500)')/nansum((CL.cs(t,250:500)-q.e(1)).*binwidth(250:500)');
    my(t)=nansum(((CL.cs(t,250:500)-q.e(t)).*binwidth(250:500)').^2)/(2*nansum((CL.cs(t,250:500)-q.e(t)).*binwidth(250:500)'));
end



% %% Figures
% figure;
% plot(D.time(Time.all),extent1(Time.all),'.-k');
% hold on
% plot(D.time(Time.all),extent(Time.all),'.-r');
% 
% figure;
% plot(D.time(Time.all),lspos(Time.all),'.-k');