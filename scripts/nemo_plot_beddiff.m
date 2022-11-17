%NEMO_PLOT_BEDDIFF Plots net bedlevel change, cumulative eroision and acrretion and ratio
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
%% NEMO
mask=squeeze(sum(~isnan(D.altitude),1)>7);
dz=diff(D.altitude(Time.nemo,:,:),1,1);
dza=nan(size(dz));
dza(dz>0)=dz(dz>0);
dze=nan(size(dz));
dze(dz<0)=dz(dz<0);

B.nemo.n=squeeze(nansum(dz,1));
B.nemo.a=squeeze(nansum(dza,1));
B.nemo.e=squeeze(nansum(dze,1));
B.nemo.r=B.nemo.n./(abs(B.nemo.a)+abs(B.nemo.e));

%% ZM
dz=diff(D.altitude(Time.all,:,:),1,1);
dza=nan(size(dz));
dza(dz>0)=dz(dz>0);
dze=nan(size(dz));
dze(dz<0)=dz(dz<0);

B.zm.n=squeeze(nansum(dz,1));
B.zm.a=squeeze(nansum(dza,1));
B.zm.e=squeeze(nansum(dze,1));
B.zm.r=B.zm.n./(abs(B.zm.a)+abs(B.zm.e));

%% VB
dz=diff(D.altitude(Time.vbnemo,:,:),1,1);
dza=nan(size(dz));
dza(dz>0)=dz(dz>0);
dze=nan(size(dz));
dze(dz<0)=dz(dz<0);

B.vb.n=squeeze(nansum(dz,1));
B.vb.a=squeeze(nansum(dza,1));
B.vb.e=squeeze(nansum(dze,1));
B.vb.r=B.vb.n./(abs(B.vb.a)+abs(B.vb.e));

%% COMPILATION
B.comp.n=B.nemo.n; B.comp.n(Index.vb,:)=B.vb.n(Index.vb,:); B.comp.n(Index.zm,:)=B.zm.n(Index.zm,:);
B.comp.a=B.nemo.a; B.comp.a(Index.vb,:)=B.vb.a(Index.vb,:); B.comp.a(Index.zm,:)=B.zm.a(Index.zm,:);
B.comp.e=B.nemo.e; B.comp.e(Index.vb,:)=B.vb.e(Index.vb,:); B.comp.e(Index.zm,:)=B.zm.e(Index.zm,:);
B.comp.r=B.nemo.r; B.comp.r(Index.vb,:)=B.vb.r(Index.vb,:); B.comp.r(Index.zm,:)=B.zm.r(Index.zm,:);


%% PLOT
figure;
ax=subplot_meshgrid(1,4,nan,nan,0.98,0.18);
fn=fieldnames(B.comp); 
for n=1:4;
    axes(ax(n));
    pcolor(D.L,D.C,B.comp.(fn{n}).*mask); 
    shading flat; 
    axis equal;
    hold on;
    contour(D.L,D.C,squeeze(D.altitude(1,:,:)),[0 0],'-k')
    contour(D.L,D.C,squeeze(D.altitude(38,:,:)),[0 0],'--k')
    csym; 
    colormap(jwb(100,0)); 
    colorbar;
    xlim([0 17500]);
    ylim([-200 2000]);
end; 
%EOF