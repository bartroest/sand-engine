function nemo_plot_profile_adjustment(D,sq);
%NEMO_PLOT_PROFILE_ADUSTMENT Plots a figure of three profiles indicative of slope change.
%
%   Syntax:
%       trend = nemo_altitude_trend(D,z)
%
%   Input: 
%       D: Data struct
%
%   Output:
%   	figure
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

n=[316;407;361];
% o=[106;66;87];
%figure('Units','Centimeters','Position',[5 7 18.35 8]);
if nargin<2;
    sq=true;
end

if ~sq;
    figure('Units','Centimeters','Position',[5 3 8 23]);

    for m=1:3;
    ax(m)=subplot(3,1,m);
        hold on;
        %hj=plot(D.dist,squeeze(DL.alt_int(47     ,o(m),:)),'-' ,'Color',[0.7 0.7 0.7]);
        hi=plot(D.dist,squeeze(D.altitude(2:end-1,n(m),:)),'.-','Color',[0.9 0.9 0.9]);
        h1=plot(D.dist,squeeze(D.altitude(1      ,n(m),:)),'.-','Color',[0.5 0.5 0.5]);
        he=plot(D.dist,squeeze(D.altitude(end    ,n(m),:)),'.-','Color',[0   0   0  ]);
        xlim([0 1800]);
        ylim([-12 8]);
        xlabel('Cross-shore distance [m]');
        ylabel('Altitude [m NAP]');
        title(['Transect ',num2str(n(m),'%3.0f'),', \DeltaV_{net}=',num2str(round(nansum(V.comp.dv(:,n(m))),-1),'%+4.0f'),'m^{3}/m']);
        if m==2;
            leg=legend([h1,he,hi(1)],{datestr(D.time(1),'mmm-yyyy'),datestr(D.time(end),'mmm-yyyy'),'Intermediate'},'FontSize',8);
            leg.Position=[0.5711, 0.450, 0.4068, 0.0629];
        end
        box on;
        text(-200,9,alphabet(m),'FontSize',12);

        axipos=ax(m).Position;
        axipos(1)=0.520;
        axipos(2)=axipos(2)+ 0.141;
        axipos(3)=0.375;
        axipos(4)=0.065;
        axi=axes('Position',axipos);
        pcolor(axi,D.L,D.C,squeeze(D.altitude(17,:,:)));
        shading flat;
        colormap(zmcmap);
        clim([-12 7]);
        hold on;
        plot(D.alongshore([n(m),n(m)]),[-200 2200],'-r');
        xlabel('LS-pos [km]');
        ylabel('CS-pos [km]    ');
        axis equal;
        xlim([7000 13000]);
        ylim([-100 2000]);
        if m==3;
            axi.XAxisLocation='top';
            axi.Position=[0.255 ax(m).Position(2) axipos(3:4)];
            ylabel('    CS-pos [km]');
        end
        axi.XTickLabel={8, 10, 12};
        axi.YTickLabel={0, 1,  2};
        axi.FontSize=8;
    end
else
    figure('Units','Centimeters','Position',[5 3 18.35 13],'Renderer','painters');
    legloc={'NE','NE','SW'};
    mask = D.dist>0 & D.dist < 1790;
    for m=1:3;
    ax(m)=subplot(2,2,m);
        hold on;
        %hj=plot(D.dist,squeeze(DL.alt_int(47     ,o(m),:)),'-' ,'Color',[0.7 0.7 0.7]);
        hi=plot(D.dist(mask),squeeze(D.altitude(2:end-1,n(m),mask)),'.-','Color',[0.9 0.9 0.9]);
        h1=plot(D.dist(mask),squeeze(D.altitude(1      ,n(m),mask)),'.-','Color',[0.5 0.5 0.5]);
        he=plot(D.dist(mask),squeeze(D.altitude(end    ,n(m),mask)),'.-','Color',[0   0   0  ]);
        xlim([0 1800]);
        ylim([-12 8]);
        xlabel('Cross-shore distance [m]');
        ylabel('Altitude [m NAP]');
        title(['Transect ',num2str(n(m),'%3.0f'),', \DeltaV_{net}= ',num2str(round(nansum(V.comp.dv(:,n(m))),-1),'%+4.0f'),'m^{3}/m']);
%         if m==3;
             leg=legend([h1,he,hi(1)],{datestr(D.time(1),'mmm-yyyy'),datestr(D.time(end),'mmm-yyyy'),'Intermediate'},'FontSize',8,'Location',legloc{m});
%             leg.Position=[0.5711, 0.450, 0.4068, 0.0629];
%         end
        box on;
%         text(-200,9,alphabet(m),'FontSize',12);
        text(-400,12,alphabet(m),'FontSize',12);
    end

        %axipos=ax(m).Position;
        %axipos(1)=0.520;
        %axipos(2)=axipos(2)+ 0.141;
        %axipos(3)=0.375;
        %axipos(4)=0.065;
        mask = D.alongshore > 7000 & D.alongshore < 12950;
        axi=subplot(2,2,4);%axes('Position',axipos);
        pcolor(axi,D.L(mask,:),D.C(mask,:),squeeze(D.altitude(17,mask,:)));
        shading flat;
        colormap(zmcmap);
        clim([-12 7]);
        hold on;
        plot(D.alongshore([n,n]),[-200, 2600],'-r','LineWidth',1.5);
        text(D.alongshore(n)-100,2300*ones(size(n)),{'a','b','c'},'HorizontalAlignment','right');
        xlabel('Alongshore distance [m]');
        ylabel('Cross-shore distance [m]');
        title('Positions in the survey area')
        axis equal;
        xlim([7000 13000]);
        ylim([-100 2500]);
        axi.Position=[axi.Position(1),ax(3).Position(2),axi.Position(3:4)];
        axi.XAxis.Exponent = 3;
        text(5700,4000,alphabet(4),'FontSize',12);
        nemo_northarrow('auto');
%        axi.XTickLabel={8, 10, 12};
%        axi.YTickLabel={0, 1,  2};
        %axi.FontSize=8;

end

end
%EOF