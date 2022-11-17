function nemo_plot_jarkbathymetry(DL,x,y)
%NEMO_PLOT_JARKBATHYMETRY Plots Jarkus-based bathymetry per survey.
%
% Plots the bathymetry of Delfland jarkus survyes.
% Only updates the parts where new data is.
%
% Input: DL Jarkus datastruct;
%        x x-axis coordinates ['x','L' or 'ls'];
%        y y-axis coordinates ['y','C' or 'cs'];
%
% Example:
%   nemo_plot_jarkbathymetry(DL,'ls','cs');
%
%   See also: nemo, nemo_jarkus, nemo_jarkus_interp_CS

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
if ~isfield(DL,'alt_int');
    DL.alt_int=nemo_jarkus_interp_cs(DL);
end
%i=47; %Jarkus 2011;
%[~,index_jarkus,~]=intersect(round(DL.rsp_x),round(D.rsp_x));
figure;
for t=1:length(DL.time);
    %figure;
    hold on
    index_jarkus=sum(~isnan(squeeze(DL.alt_int(t,:,:))),2)>2;
    %%
    pcolor(DL.(x)(index_jarkus,:),DL.(y)(index_jarkus,:),squeeze(DL.alt_int(t,index_jarkus,:)));
    shading flat
    hold on
    clim([-10 5]);
    colorbar;
    title(['Surveys: Jarkus ',datestr(DL.time(t)+datenum(1970,1,1),'dd-mmm-yyyy')],'interpreter','none');
        
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
        xlim([0 17500]);
        ylim([-400 3000]);
    elseif strcmpi(x,'ls'); %Rotated-shifted RD
        xlabel('Alongshore distance from Transect origin 1 [m]');
        ylabel('Cross-shore distance from Transect origin 1 [m]');
        axis equal;
        xlim([-200 17500]);
        ylim([0 3000]);
    end

    if 1;%OPT.print
       % print2a4(['./figures/bathymetry/bathy',datestr(D.time(t),'yyyy_mm_dd')],'l','n');
       print2screensizeoverwrite(['./figures/bathymetry/jarkframe_',num2str(t,'%2d')],[1920 1080],120,[0 0]);
    end
end