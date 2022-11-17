function nemo_plot_bedlch(D,z,index,t_index,climits)
%NEMO_PLOT_BEDLCH Plots the bedlevel change between surveys
%
%
% Input: D datastruct
%        z altitude fieldname
%        index alongshore indices
%        t_index time indices of surveys
%        climits 'auto' or 'fixed'
%
% Output: plots of normalised bedlevel change
%
% Example:
%   nemo_plot_bedlch(D,'altitude',Index.all,Time.july,'auto')
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
%%
blch=diff(D.(z)(t_index,:,:),1);
dt=diff(D.time(t_index));

for t=1:length(t_index)-1;
    figure;
    pcolor(D.L,D.C,squeeze(blch(t,:,:)));%./dt(t)));
    shading flat;
    xlabel('Distance from HvH [m]');
    ylabel('Distance form RSP [m]');
    title(['Bedlevel change from ',datestr(D.time(t_index(t)),'dd-mmm-yyyy'),' to ',datestr(D.time(t_index(t+1)),'dd-mmm-yyyy'),' \Deltat= ',num2str(dt(t),'%d'),' days']);
    %colormap(cbrewer('div','RdYlBu',10));
    colormap(jwb(100,0.01));
    switch climits
        case 'auto'
            csym;
        case 'fixed'
            clim([-3 3])
    end
    colorbarwithtitle('Bedlevel change [m]','SouthOutside');

    axis equal;
    xlim([-500 17500]);
    %ylim([-200 2000]);
    ylim([-300 2500]);
    
    %print2a4(['./figures/bedlch/Bedlch_',datestr(D.time(t_index(t)),'yyyymmdd'),'_',datestr(D.time(t_index(t+1)),'yyyymmdd')],...
    %    'l','n','-r300','o');
    %close(gcf);
end