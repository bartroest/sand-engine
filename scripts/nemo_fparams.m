function [fparams,ls,cs]=nemo_fparams(D,depths);
%NEMO_FPARAMS Determines and plots the fitting parameters for a gaussian on a depth contour.
%   
%   Determines the fitting parameters of a Gaussian curve to an isobath of the
%   Sand Engine.
%
%   Syntax:
%   [fparams,ls,cs]=nemo_fparams(D,depths);
%
%   Input: 
%       D: Data struct
%       depths: vector of isobaths (altitudes).
%
%   Output:
%   	fparams: struct of fitting parameters
%
%   Example
%   fparams = nemo_fparams(D,[0:-2:-8]);
%
%   See also: nemo, nemo_gaus_fit

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

% depths=(-10:2:0);
%depths=[-1:1:3];
%depths=[-0.5:0.5:0.5];
%binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
ls=nan(length(depths),length(D.time),length(D.alongshore));
cs=ls;
for d=1:length(depths);
    for t=1:length(D.time); 
        %[~,~,CL.ls(d,t,:),CL.cs(d,t,:),~,~]=nemo_coastline_orientation(D,'altitude',depths(d),t,6,false); 
        [ls(d,t,:),cs(d,t,:)]=nemo_depth_contour_lc(D,'altitude',depths(d),t);
    end
    q(d)=nemo_gaus_fit(D,squeeze(ls(d,:,:)),squeeze(cs(d,:,:)),250:500,Time.all,0);
end

fn=fieldnames(q); for f=1:length(fn); for d=1:length(depths); fparams.(fn{f})(:,d)=q(d).(fn{f});end;end;
%%
legdep=cell(length(depths),1);
for n=1:length(depths);
    legdep{n}=[num2str(depths(n),'%5.1f'),'m NAP'];
end
%legdep=[{'-5m'} {'-4m'} {'-3m'} {'-2m'} {'-1m'} {'+0m'} {'+1m'} {'+2m'} {'+3m'} {'+4m'}];
%legdep=[{'-4m'} {'-2m'} {'+0m'} {'+2m'} {'+4m'}];
%legdep=[{'-10m NAP'} {'-8m NAP'} {'-6m NAP'} {'-4m NAP'}  {'-2m NAP'} {' 0m NAP'}];
%legdep=[{'-1m'} {'0m'} {'+1m'} {'+2m'} {'+3m'}];
figure;
ax1=subplot(3,2,1); 
    ax1.ColorOrder=jet(length(depths));
    hold on
    plot(ax1,D.time,fparams.a,'.-'); 
    grid on; box on;
    title('Amplitude of fit'); 
    ylabel('Cross-shore amplitude [m]');
    datetick('x','mm-''yy');
    legend(legdep,'Location','Best');
    
ax2=subplot(3,2,2);     
    ax2.ColorOrder=jet(length(depths));
    hold on
    plot(ax2,D.time,fparams.b,'.-'); 
    grid on; box on;
    title('Mean of fit'); 
    ylabel('Alongshore mean position [m]')
    datetick('x','mm-''yy','keeplimits');
    
ax3=subplot(3,2,3); 
    ax3.ColorOrder=jet(length(depths));
    hold on
    plot(ax3,D.time,fparams.c,'.-'); 
    grid on; box on;
    title('Standard deviation of fit'); 
    ylabel('Standard deviation [m]');
    datetick('x','mm-''yy');
    
ax4=subplot(3,2,4); 
    ax4.ColorOrder=jet(length(depths));
    hold on
    plot(ax4,D.time,fparams.e,'.-'); 
    grid on; box on;
    title('CS-offset of fit'); 
    ylabel('CS-offset w.r.t. RSP [m]')
    datetick('x','mm-''yy');
    
ax5=subplot(3,2,5); 
    ax5.ColorOrder=jet(length(depths));
    hold on
    plot(ax5,D.time,fparams.rsq,'.-'); 
    grid on; box on;
    title('R^2 of fit'); 
    ylabel('R^2')
    datetick('x','mm-''yy');
    
ax6=subplot(3,2,6); 
    ax6.ColorOrder=jet(length(depths));
    hold on
    plot(ax6,D.time,fparams.rmse,'.-'); 
    grid on; box on;
    title('Root-mean-squared error of fit'); 
    ylabel('RMSE')
    datetick('x','mm-''yy');
%% Real world params

figure; 
ax10=subplot(3,1,[1]);
    ax10.ColorOrder=jet(length(depths));
    hold on;
    plot(ax10,D.time,fparams.a+fparams.e-902,'.-');
    box on;
    title('Cross-shore extent w.r.t RSP')
    legend(legdep,'Location','Best');
    datetick('x','mm-''yy');
    xlim([D.time(1)-10 D.time(end)+10])
    ylabel('Cross-shore extent [m]')
    xlabel('Time')
    
ax12=subplot(3,1,[2]);
    ax12.ColorOrder=jet(length(depths));
    hold on;
    plot(ax12,D.time,4.*fparams.c,'.-');
    box on;
    title('Alongshore extent');
    legend(legdep,'Location','NW');
    datetick('x','mm-''yy');
    xlim([D.time(1)-20 D.time(end)+20])
    ylabel('Alongshore extent [m]')
    xlabel('Time')
% %     
% % ax14=subplot(3,2,[2]);
% %     ax14.ColorOrder=jet(length(depths));
% %     hold on;
% %     plot(ax14,D.time,fparams.b+2*fparams.c,'.-');
    
ax11=subplot(3,1,[3]);     
    ax11.ColorOrder=jet(length(depths));
    hold on
    plot(ax11,D.time,fparams.b,'.-'); 
    grid on; box on;
    title('Mean of fit'); 
    ylabel('Alongshore mean position [m]')
    xlim([D.time(1)-20 D.time(end)+20]);
    legend(legdep,'Location','NW');
    datetick('x','mm-''yy','keeplimits');
    xlabel('Time')
%     
% ax13=subplot(3,2,[6]);
%     ax13.ColorOrder=jet(length(depths));
%     hold on;
%     plot(ax13,D.time,fparams.b-2*fparams.c,'.-');
    
    
    %%
    
    figure;
    ax20=gca;
    
    ax20.ColorOrder=jet(length(depths));
    hold on;
    plot(ax20,fparams.b-2*fparams.c,D.time,'.-');
    plot(ax20,fparams.b,            D.time,'.-');
    plot(ax20,fparams.b+2*fparams.c,D.time,'.-');