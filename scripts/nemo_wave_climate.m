function [W,waveclimate]=nemo_wave_climate(D,direction,height,period,time,depth,Index,Time);
%NEMO_WAVE_CLIMATE determines averaged wave parameters between surveys.
%
% Generates an off-shore wave climate from wave parameter timeseries.
%
% Input: D: datastruct
%        direction: wave from direction [deg N]
%        height: significant wave height [m]
%        time: wave time vector [datenum]
%        t_index: time indices for climate 
%
% Output: W: struct with wave climate
%           fields: H_rms, H_avg, D_avg, D_weighted, Power_alongshore,
%           Power_cross-shore.
%
% Example:
%   [WC,waveclimate]=nemo_wave_climate(D,W.hdir,W.hm0,W.tp,W.time,W.depth_avg,Index,Time);
%
% See also: nemo, nemo_waves, hcwdRun, hcwdTransform, nemo_load_zmwave, nemo_read_wavetransform, nemo_read_wavedata

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

%% Constants
g=9.81; %gravitational acceleration [m/s^2]
rho=1024; %density of seawater [kg/m^3]
rho_s=2650; %Density of sand
d50=250e-6; %Median grainsize
gamma_b=0.78; %Breaker parameter H/h
%% nans
%Determine nan indices for correct calculation of wave climate.
nnan=isnan(height)|isnan(period)|isnan(direction);

%% Expand wave parameters
W.time=time;  %Wave time
W.hm0=height; %Wave height
W.tp=period;  %Wave period
W.dir=direction; %Wave from direction
W.depthavg=depth; %Depth at wave calculation

% Relative wave angle of incidence, 0=perpendicular.
W.d_rel=W.dir+48.7; %Local coastline angle +(360-311.3) Hoekverdraaiing.
W.d_rel(W.d_rel>180)=W.d_rel(W.d_rel>180)-360;
mask=W.d_rel<=-90 | W.d_rel>=90;
W.d_rel(mask)=180; % Do not allow for 'off-shore directed' waves to contribute to the wave power.

W.k=disper(2*pi./W.tp,W.depthavg,g); %Wave number
W.cp=sqrt(9.81./W.k.*tanh(W.k.*W.depthavg)); %Wave phase velocity
W.cg=1/2.*W.cp.*(1+(2.*W.k.*W.depthavg)./sinh(2.*W.k.*W.depthavg)); %Wave group velocity

%% Wave parameters at wave breaking
[W.hb,W.db,W.dir_b]=Waves2Nearshore(W.depthavg,W.hm0,W.d_rel,W.tp,nan,gamma_b);
 
%% Energy and power
W.energy=1/2*1/8*rho*g*W.hm0.^2; %Wave energy [kg m^2 / s^2]=[J/m^2]
% E=1/2*rho*g*a^2 = 1/2*rho*g*(H_rms/2)^2 = 1/8*rho*g*H_rms^2 = 1/16*rho*g*H_s^2
W.power=W.energy.*W.cg; %Wave power [kg m /s^3]=[W/m]=[J/(sm)] Also wave energy flux.
% P=1/16 * rho * g * H^2 * (g*T/2*pi) [W/m]
%Power [W/m]=[J/s/m] 

% Calculation of alongshore component of wave power, per entry.
W.P_ls=W.power.*sind(W.d_rel);
W.P_cs=W.power.*cosd(W.d_rel);

ws=sqrt((4*(rho_s/rho-1)*g*d50)/(3*4));

% Gourlay number
W.Gourlay=W.hb./(ws.*W.tp); %W.gourlay(isnan(W.gourlay))=0;
% Foude surf number
W.Fr_surf=ws./(sqrt(9.81.*W.hb)); %W.fr_surf(isnan(W.fr_surf))=0;
% Iribarren number at wave breaking
% W.Iribarren=tan(1/80)./(sqrt(W.hb./((9.81.*W.tp.^2)./(2.*pi)))); %iribarren(isnan(iribarren))=0;
W.Iribarren=1./(sqrt(W.hb./((9.81.*W.tp.^2)./(2.*pi)))); %Slope applied locally!!!
[slope,~,~,~]=nemo_build_slope(D,'altitude',0,-5);

%% Wave climate
func={'nanmin','mean','nanmax','rms'};%,'sum'};
for n=1:length(func);
    waveclimate.(func{n})=struct(...
        'Hs',       nan(length(D.time),length(D.alongshore)),...    %Significant wave height
        'Hb',       nan(length(D.time),length(D.alongshore)),...    %Breaking wave height
        'Tp',       nan(length(D.time),length(D.alongshore)),...    %Wave peak period
        'd_rel',    nan(length(D.time),length(D.alongshore)),...    %Relative wave direction
        'E',        nan(length(D.time),length(D.alongshore)),...    %Wave energy
        'P',        nan(length(D.time),length(D.alongshore)),...    %Wave energy
        'P_ls',     nan(length(D.time),length(D.alongshore)),...    %Alongshore wave energy flux
        'P_cs',     nan(length(D.time),length(D.alongshore)),...    %Cross-shore wave energy flux
        'P_lsabs',  nan(length(D.time),length(D.alongshore)),...    %Absolute sum of Alongshore wave energy flux
        'P_fsouth', nan(length(D.time),length(D.alongshore)),... 
        'P_fnorth', nan(length(D.time),length(D.alongshore)),... 
        'Gourlay',  nan(length(D.time),length(D.alongshore)),...    %Gourlay number/dimensionless fall velocity
        'Fr_surf',  nan(length(D.time),length(D.alongshore)),...    %Surfzone Froude number
        'Iribarren',nan(length(D.time),length(D.alongshore)));%,...    %Irribarren number
end      

fnI={'nemo','zm' };
fnT={'nemo','all'};
fnt={'time_nemo','time'};
for loc=1:length(fnI); %Different spatial areas
    t_index=Time.(fnT{loc});
    for t=1:length(t_index)-1; %Every time-interval
        t_mask=time>=D.(fnt{loc})(t_index(t)) & time<D.(fnt{loc})(t_index(t+1));

        if sum(t_mask)>2;
            hh=W.hm0(t_mask & ~isnan(W.hm0));
            hb=W.hm0(t_mask & ~isnan(W.hb));
            pp=W.tp(t_mask & ~isnan(W.tp));
            dr=W.d_rel(t_mask & ~isnan(W.d_rel));
            %tt=time(t_mask & ~isnan(time));
            E=W.energy(t_mask & ~isnan(W.energy));
            P=W.power(t_mask & ~isnan(W.power));
            P_ls=W.P_ls(t_mask & ~isnan(W.P_ls));
            P_ls_fsouth=W.P_ls(t_mask & W.d_rel<0 & W.d_rel>-90 & ~isnan(W.P_ls));
            P_ls_fnorth=W.P_ls(t_mask & W.d_rel>0 & W.d_rel< 90 & ~isnan(W.P_ls));
            P_cs=W.P_cs(t_mask & ~isnan(W.P_cs));
            Gourlay=W.Gourlay(t_mask & ~isnan(W.Gourlay));
            Fr_surf=W.Fr_surf(t_mask & ~isnan(W.Fr_surf));
            Irib=W.Iribarren(t_mask & ~isnan(W.Iribarren))*tan(-slope(t_index(t),:));
%             percnan=sum(nnan(t_mask))/sum(t_mask);
        
            for n=1:length(func);
                waveclimate.(func{n}).Hs(       t_index(t),Index.(fnI{loc}))=feval(func{n},hh,'omitnan');
                waveclimate.(func{n}).Hb(       t_index(t),Index.(fnI{loc}))=feval(func{n},hb,'omitnan');
                waveclimate.(func{n}).Tp(       t_index(t),Index.(fnI{loc}))=feval(func{n},pp,'omitnan');
                waveclimate.(func{n}).d_rel(    t_index(t),Index.(fnI{loc}))=feval(func{n},dr,'omitnan');
                waveclimate.(func{n}).E(        t_index(t),Index.(fnI{loc}))=feval(func{n},E,'omitnan');
                waveclimate.(func{n}).P(        t_index(t),Index.(fnI{loc}))=feval(func{n},P,'omitnan');
                waveclimate.(func{n}).P_ls(     t_index(t),Index.(fnI{loc}))=feval(func{n},P_ls,'omitnan');
                waveclimate.(func{n}).P_cs(     t_index(t),Index.(fnI{loc}))=feval(func{n},P_cs,'omitnan');
                waveclimate.(func{n}).P_lsabs(  t_index(t),Index.(fnI{loc}))=feval(func{n},abs(P_ls),'omitnan');
                waveclimate.(func{n}).P_fsouth( t_index(t),Index.(fnI{loc}))=feval(func{n},P_ls_fsouth,'omitnan');
                waveclimate.(func{n}).P_fnorth( t_index(t),Index.(fnI{loc}))=feval(func{n},P_ls_fnorth,'omitnan');
                waveclimate.(func{n}).Gourlay(  t_index(t),Index.(fnI{loc}))=feval(func{n},Gourlay,'omitnan');
                waveclimate.(func{n}).Fr_surf(  t_index(t),Index.(fnI{loc}))=feval(func{n},Fr_surf,'omitnan');
                waveclimate.(func{n}).Iribarren(t_index(t),Index.(fnI{loc}))=feval(func{n},Irib(:,Index.(fnI{loc})),'omitnan');
            end
            
%             if strcmpi(func{n},'sum');
%                 par=fieldnames(waveclimate.(func{n}));
%                 for m=1:length(par);
%                     waveclimate.(func{n}).(par{m})=waveclimate.(func{n}).(par{m})./(1-percnan);
%                 end
%             end
            
%         drel=repmat(dd,1,644)+48-repmat(CL.ang(t_index(t),:),length(dd),1); %rotate 48deg 
%         drel(drel>180)=drel(drel>180)-360;
%         p_ls(t_mask,:)=repmat(power(t_mask),1,644).*-sind(drel);
%         p_cs(t_mask,:)=repmat(power(t_mask),1,644).*cosd(drel);
%         p   (t_mask,:)=repmat(power(t_mask),1,644);
%         
% % %         W.H_rms(t_index(t),Index.(fnI{loc}))=nanrms(hh);                 W.meta.H_rms={'RMS of significant wave height'};
%          W.HT    (t_index(t),Index.(fnI{f}))=nanrms(hh.*pp);                 W.meta.HT={'H*T, Waveheight*period'};
%          W.HT2   (t_index(t),Index.(fnI{f}))=nanrms(hh.*pp.^2);              W.meta.HT2={'H*T^2, Waveheight*period^2'};
%          W.H_T   (t_index(t),Index.(fnI{f}))=nanrms(hh./pp);                 W.meta.HT={'H/T, Waveheight/period'};
%          W.H_T2  (t_index(t),Index.(fnI{f}))=nanrms(hh./pp.^2);              W.meta.HT={'H/T^2, Waveheight/period^2'};
%  
%          W.hrms  (t_index(t),Index.(fnI{f}))=nanrms(hh);                     W.meta.hrms={'RMS(H), RMS wave height'};%RMS wave height
%          W.hmean  (t_index(t),Index.(fnI{f}))=nanmean(hh);                    W.meta.havg={'mean(H), Mean wave height'}; %AVG wave height
%          W.trms  (t_index(t),Index.(fnI{f}))=nanrms(pp);                     W.meta.trms={'RMS(T), RMS wave period'};%RMS wave period
%          W.tmean  (t_index(t),Index.(fnI{f}))=nanmean(pp);                    W.meta.tavg={'mean(T), Mean wave period'}; %AVG wave period
%         W.davg  (t_index(t),Index.(fnI{f}))=nanmean(drel(:,Index.(fnI{f})));W.meta.davg={'mean relative angle of incidence'}; %AVG wave direction
%         %W.dwei  (t_index(t),Index.(fnI{f}))=nansum(drel.*(repmat(hh,1,644).^2))/nansum(repmat(hh,1,644).^2);  W.meta.dwei={'Weighted relative angle, weighted with H^2'};%Weighted relative angle weighted with H^2.
%         %W.dwei  (t_index(t),Index.(fnI{f}))=nansum(drel(:,Index.(fnI{f}))).*(p(t_mask,Index.(fnI{f}))/nansum(power(t_mask)));%,Index.(fnI{f})),1)); W.meta.dwei={'Weighted relative angle, weighted with H^2'};
%         
%         
%         W.prms  (t_index(t),Index.(fnI{f}))=nanrms(power(t_mask));                  W.meta.prms={'Power of RMS wave height'};    %RMS wave power
%         W.prmsls(t_index(t),Index.(fnI{f}))=nanrms(p_ls(t_mask,Index.(fnI{f})));    W.meta.prmsls={'Power of RMS wave height, alongshore component'}; %RMS LS wave power
%         W.prmscs(t_index(t),Index.(fnI{f}))=nanrms(p_cs(t_mask,Index.(fnI{f})));    W.meta.prmscl={'Power of RMS wave height, cross-shore component'};%RMS CS wave power
%          W.cp    (t_index(t),Index.(fnI{f}))=nansum(power(t_mask));                  W.meta.cp={'Cumulative wave power'}; %Cumulative wave power
%          W.cpls  (t_index(t),Index.(fnI{f}))=nansum(power_alongshore(t_mask));%,Index.(fnI{f})));    W.meta.cpls={'Cumulative wave power, alongshore component'};%Cum Alongshore wave power
%          W.cpcs  (t_index(t),Index.(fnI{f}))=nansum(power_crossshore(t_mask));%,Index.(fnI{f})));    W.meta.cpcs={'Cumulative wave power, cross-shore component'};%Cum Cross-shore wave power
%          W.mpls  (t_index(t),Index.(fnI{f}))=nanmean(p_ls(t_mask,Index.(fnI{f})));   W.meta.mpls={'Mean wave power, alongshore component'};%AVG LS wave power
%          W.mpcs  (t_index(t),Index.(fnI{f}))=nanmean(p_cs(t_mask,Index.(fnI{f})));   W.meta.cpls={'Mean wave power, cross-shore component'};%AVG CS wave power
%          W.capls (t_index(t),Index.(fnI{f}))=nansum(abs(power_alongshore(t_mask)));%,Index.(fnI{f})))); W.meta.capls={'Cumulative wave power, absolute alongshore component'};%Cum Alongshore wave power
%         W.caplsdt(t_index(t),Index.(fnI{f}))=nansum(abs(p_ls(t_mask,Index.(fnI{f}))))./sum(t_mask)*24; W.meta.caplsdt={'Cumulative wave power, absolute alongshore component'};%Cummulative alongshore wave power scaled per unit time

        end
    end
end