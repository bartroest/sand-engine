function nemo_plot_bathymetry(D,x,y,z,DL,M)
%NEMO_PLOT_BATHYMETRY Plots Jarkus and Shore-based bathymetry per survey.
%
%   Batymetry is updated sequentially, only where new data is.
%   Bottom layer is Jarkus, top layer is Shore (ZM+Nemo). Optionally extended
%   with multibeam.
%   Useful for making an animation.
%
%   Syntax:
%       nemo_plot_bathymetry(D,x,y,z,DL,M);
%
%   Input: 
%       D datastruct shore;
%       x: x-axis coordinates fieldname ['x','L' or 'ls'];
%       y: y-axis coordinates fieldname ['y','C' or 'cs'];
%       z: altitude fieldname ['altitude']
%       DL: Jarkusdata struct
%       M: Multibeam survey struct
%
%   Output:
%   	figures
%
%   See also: nemo, nemo_movie

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

set(gcf,...
'PaperUnits'      ,'centimeters',...
'PaperPosition'   ,[0 0 30 11],...
'PaperOrientation','portrait');
   
colormap(zmcmap);
i=47; %Jarkus 2011;
%[~,index_jarkus,~]=intersect(round(DL.rsp_x),round(D.rsp_x));

for t=-46:1:length(D.time);
    %figure;
    hold on
    
    %% Plot cumulative Jarkus 1965:2010
    if t<=0;
        %for tj=1:46;
        tj=t+47;
            index_jarkus=sum(~isnan(squeeze(DL.alt_int(tj,:,:))),2)>2;
            pcolor(DL.(x)(index_jarkus,:),DL.(y)(index_jarkus,:),squeeze(DL.alt_int(tj,index_jarkus,:)));
            shading flat
            hold on
        %end
        title(['Surveys: Jarkus ',datestr(round(nanmean(DL.time_bathy(tj,:)))+datenum(1970,1,1))],'interpreter','none');
    else
        %% Plot all shore surveys (and jarkus from 2011 onwards).
    if nargin>=6 %OPT.mb
        if t==7;
            pcolor(D.(x),D.(y),squeeze(M.altitude(1,:,:))); 
            shading flat
        elseif t==30;
            pcolor(D.(x),D.(y),squeeze(M.altitude(2,:,:))); 
            shading flat
        end
    end
    
        if D.time_jarkus(t)~=0 || t==1;
            index_jarkus=sum(~isnan(squeeze(DL.alt_int(i,:,:))),2)>2;
            pcolor(DL.(x)(index_jarkus,:),DL.(y)(index_jarkus,:),squeeze(DL.alt_int(i,index_jarkus,:)));
            shading flat
            hold on
            i=i+1;
        end

        pcolor(D.(x),D.(y),squeeze(D.(z)(t,:,:)));
        shading flat;
                
        jj=find(D.time_nemo(1:t)>0,1,'last');
        if ~isempty(jj);
            title(['Surveys: Jarkus ',datestr(round(nanmean(DL.time_bathy(i-1,:)))+datenum(1970,1,1)),' & ZM ',datestr(D.time(t)),' & NEMO ',datestr(D.time_nemo(jj))],'interpreter','none');
        else
            title(['Surveys: Jarkus ',datestr(round(nanmean(DL.time_bathy(i-1,:)))+datenum(1970,1,1)),' & ZM ',datestr(D.time(t))],'interpreter','none');
        end
%         if     D.time_jarkus(t)~=0 && D.time_nemo(t)==0; %JZ
%             title(['Surveys: Jarkus ',datestr(D.time_jarkus(t)),' & ZM ',datestr(D.time(t))],'interpreter','none');
%         elseif D.time_jarkus(t)~=0 && D.time_nemo(t)~=0 %JZN
%             title(['Surveys: Jarkus ',datestr(D.time_jarkus(t)),' & ZM ',datestr(D.time(t)),' & NEMO ',datestr(D.time_nemo(t))],'interpreter','none');
%         elseif D.time_jarkus(t)==0 && D.time_nemo(t)~=0; %ZN
%             title(['Surveys: ZM ',datestr(D.time(t)),' & NEMO ',datestr(D.time_nemo(t))],'interpreter','none');
%         else %Z
%             title(['Survey: ZM ',datestr(D.time(t))],'interpreter','none');    
%         end
    end
        clim([-12 7]);
        cb=colorbar;
        cb.TickLength=0.03;
        cb.Label.String='Altitude [m+NAP]';
        if strcmpi(x,'x'); %RD-xy
            xlabel('x RD [m]');
            ylabel('y RD [m]');
            axis equal;
            [xlims,ylims]=nemo_planbound('dl',1,1);
            xlim(xlims);
            ylim(ylims);
        elseif strcmpi(x,'L'); %Longshore Cross-shore
            xlabel('Alongshore distance from HvH [m]');
            ylabel('Cross-shore distance from RSP [m]');
            axis equal;
            xlim([0 17250]);
            ylim([-600 4000]);
        elseif strcmpi(x,'ls'); %Rotated-shifted RD
            xlabel('Alongshore distance from Hoek van Holland [m]');
            ylabel('Cross-shore distance from Transect origin 1 [m]');
            axis equal;
            xlim([-250 17250]);
            ylim([-500 5000]);
        end


        if 1;%OPT.print
%             if t<=0;
%                 %print2a4(['./figures/bathy/bathy',datestr(DL.time(tj)+datenum(1970,1,1),'yyyy_mm_dd')],'l','n');
%                 %print(['./figures/hr/bathy',datestr(DL.time(tj)+datenum(1970,1,1),'yyyy_mm_dd')],'-dpng','-r400');
%             else
%                 %print2a4(['./figures/bathy/bathy',datestr(D.time(t),'yyyy_mm_dd')],'l','n');
%                 %print(['./figures/bathy/bathy',datestr(D.time(t),'yyyy_mm_dd')],'-dpng','-r400');
%             end
            print2screensizeoverwrite(['./figures/b_mov/frame_',num2str(t+47,'%2d')],[1500 900],160,[0 0]);
           
        end
    %end
end