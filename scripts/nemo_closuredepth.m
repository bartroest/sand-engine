function [closuredepth,closuredist,c,d,l,cdtype]=nemo_closuredepth(D,z,threshold,index,t_index,plotswitch,set_type);%WE,Time)
%NEMO_CLOSUREDEPTH Finds the depth of closure based on variance of the altitude.
% Tries to find the treshold on bedlevel variance per transect, with
% matching depth and cross-shore distance.
%
% Syntax: [closuredepth,closuredist,c,d]=nemo_closuredepth(...
%    Data,'altitude',thresh_val,index,t_index)
%
% Input:
%       D: datastruct
%       z: altitude field
%       threshold: threshold value for the variance
%       index: alongshore indices
%       t_index: survey indices
%       plotswitch: plot figures for inspection [true|false]
%       set_type: manually categorise type of closure [true|false].
%
% Output: 
%       closuredepth: depth of closure of the profile [m+NAP]
%       closuredist: cross-shore distance to closuredepth [m+RSP]
%       c:
%       d:
%       l:
%       cdtype: manually attributed type of closure that was detected.
%       
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

%nnan = sum(~isnan(squeeze(D.(z)(t_index,:,:))),1);
closuredepth=nan(size(D.(z),1),size(D.(z),2));
closuredist=nan(size(D.(z),1),size(D.(z),2));
c=nan(size(D.alongshore));
d=c;
l=c;
% tt=1;
cdtype=ones(size(D.alongshore));
ltype={'*k','xr','vb','+g'};

%% Calculation per timestep
% THIS DOES NOT WORK!
% % for t=t_index(1:end-1);
% %     for i=index;
% %         temp = find(var([squeeze(D.(z)(t,i,:)) squeeze(D.(z)(t_index(tt+1),i,:))],0,2) >= threshold,1,'last');
% %         if ~isempty(temp);
% %         closuredepth(t,i)=D.(z)(t,i,temp);
% %         closuredist(t,i)=D.dist(temp);
% %         end
% %         
% %     end
% %     tt=tt+1;
% % end

%% Calculation for all t_index at once.
for i=index;
    %nnan = sum(~isnan(squeeze(D.(z)(t_index,i,:))),1);
% % %     temp = find(std(squeeze(D.(z)(t_index,i,:)),0,1,'omitnan') >= threshold ...
% % %         & nnan>=4 ,1,'last');
% % % 
% % %     if ~isempty(temp);
% % %     c(i)=D.(z)(t_index(end),i,temp);
% % %     d(i)=D.dist(temp);
% % %     end
    zz=squeeze(D.(z)(t_index,i,:)); %pick sub-set of altitude matrix [time cross-shore]
    mask=sum(~isnan(zz),1)<5;       %mask points with too little data
    zz(:,mask)=nan;                   
    
    stdz=smooth1_nan(std(zz,0,1,'omitnan'),1)';
    
    [xcr, ~]=findCrossings(D.cs(i,:)',stdz,D.cs(i,[1 end])',[threshold; threshold]); % find crossings between std(zz) and threshold.
    if ~isempty(xcr);
        zcr=nan(size(xcr));                 %preallocate
        %zz=squeeze(D.(z)(t_index,i,:));    
        %zz(:,sum(~isnan(zz))<5)=nan;        
        zmean=nanmean(zz,1);                %Calculate mean bed-level at points
        for n=1:length(xcr);                %Fot all crossings...
            zcr(n)=jarkus_depthatX(xcr(end),zmean,D.cs(i,:)); %Determine the mean depth at location
        end
        
        xcr=xcr(zcr<-2);                    %Crossing must be below -2m NAP
        zcr=zcr(zcr<-2);                    %Crossing must be below -2m NAP
        if ~isempty(xcr);                   %If there are still crossings...
            c(i)=xcr(end);                  %Assume last position is the DOC location
            d(i)=zcr(end);
            l(i)=D.ls(i,abs(D.cs(i,:)-c(i))==min(abs(D.cs(i,:)-c(i))));
        end
       
    if plotswitch || set_type;
    subplot(2,2,[1,3]);
    cla;
    h3=plot(D.cs(i,:),10.*stdz,'.-r');                                          %Scale std with 10
    hold on;
    h1=plot(D.cs(i,:),squeeze(D.(z)(t_index,i,:)),'.','Color',[0.7 0.7 0.7]);   %Plot all bathymetries
    h2=plot(D.cs(i,:),zmean,'.-k');                                             %Plot mean bathymetry
    plot(D.cs(i,:),sum(~isnan(squeeze(D.(z)(t_index,i,:))),1)<5,'.-b');
    hline(10*threshold,'-k')
    plot([c(i) c(i)],[10 -12],'--r');
    plot([0 3000],[d(i) d(i)],'--r');
    title(['DoC Jarkus 2012-2016, transect ',num2str(i)]);
    xlim([0 max([D.cs(i,sum(~isnan(squeeze(D.(z)(t_index,i,:))),1)>=5) 2500])]);
    xlabel('Cross-shore distance [m]');
    ylabel({'Altitude [m NAP]';'std(z) [dm]'});
    
    legend([h1(1),h2(1),h3(1)],{'Profiles','Mean profile','10*std(z)'},'Location','NE');
    
    if set_type
        tmp=input('Type of closuredepth? 1: normal, 2: too early, 3: too late, 4: no closure ');
        if isempty(tmp)
            tmp =1;
        end
        cdtype(i) = tmp;
    end
       
    subplot(2,2,2);
    plot(D.alongshore(i),d(i),ltype{cdtype(i)});
    xlabel('Alongshore distance [m]');
    ylabel('Altitude [m NAP]');
    title('Depth of closure');
    hold on;
    
    subplot(2,2,4);
    plot(D.alongshore(i),c(i),ltype{cdtype(i)});
    xlabel('Alongshore distance [m]');
    ylabel('Cross-shore distance [m]');
    title('Position of DoC');
    hold on;
%     if set_type
%         pause;
%     end
    %print2a4(['./figures/doc/DoC_jarkus_tr_',num2str(i)],'h','n','-r200','o');
    end
    end
    
end

%% Calculation based on wave-data
%%%dc=nan;
% % % % %Overall
% % % % MLW=-0.68; %nanmean(DL.mean_low_water);
% % % % dt=D.time(end)-D.time(1);
% % % % mask=WE.time>=D.time(1) & WE.time<=D.time(end);
% % % % H=WE.h(mask)./100; %Wave height in m
% % % % T=WE.p(mask); % Wave period in s
% % % % theta=WE.d(mask); %Wave direction in degN
% % % % 
% % % % nn=sum(~isnan(H)); %number of non-nan values
% % % % perc=12/24/dt;
% % % % idx=round((1-perc).*nn);
% % % % 
% % % % WS=sortrows([H,T,theta]);
% % % % dc.all.DoC=nan;
% % % % dc.all.He=WS(idx,1);
% % % % dc.all.Hm=WS(nn,1);
% % % % dc.all.Te=nanmean(WS(idx-1:idx+1,2));
% % % % dc.all.theta=nanmean(WS(idx-1:idx+1,3));
% % % % dc.all.dt=dt;
% % % % dc.all.nobs=nn;
% % % % 
% % % % dc.all.DoC=MLW-(2.28.*dc.all.He-(68.5.*(dc.all.He.^2./(9.81.*dc.all.Te.^2))));
% % % % 
% % % % %Annual
% % % % for t=1:length(Time.july)-1;
% % % %     dt=D.time(Time.july(t+1))-D.time(Time.july(t));
% % % %     mask= WE.time>=D.time(Time.july(t)) & WE.time<=D.time(Time.july(t+1)); %All values between timestamps
% % % %     H=WE.h(mask)./100; %Wave height in m
% % % %     T=WE.p(mask); % Wave period in s
% % % %     theta=WE.d(mask); %Wave direction in degN
% % % % 
% % % %     nn=sum(~isnan(H)); %number of non-nan values
% % % %     perc=(12/24)./dt; %percentage of exceedance
% % % %     idx=round((1-perc).*nn); %associated index
% % % %     
% % % %     WS=sortrows([H,T,theta]);
% % % %     dc.annual.DoC=nan;
% % % %     dc.annual.He(t)=WS(idx,1);
% % % %     dc.annual.Hm(t)=WS(nn,1);
% % % %     dc.annual.Te(t)=WS(idx,2);
% % % %     dc.annual.theta(t)=WS(idx,3);
% % % %     dc.annual.dt(t)=dt;
% % % %     dc.annual.nobs(t)=nn;
% % % % end
% % % % dc.annual.DoC=MLW-(2.28.*dc.annual.He-(68.5.*(dc.annual.He.^2./(9.81.*dc.annual.Te.^2))));
% % % % 
end
%EOF