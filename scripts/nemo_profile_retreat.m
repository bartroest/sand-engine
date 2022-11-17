function Y=nemo_profile_retreat(D,z,d,index,t_index,figswitch)
%NEMO_PROFILE_RETREAT Calculates the horizontal displacement of depth contours.
%
% For every depth d; the position w.r.t RSP is calculated for transects
% index at time t_index.
% This results in a vertical projection of the coatal cell onto the
% (RSP,depth)-plane.
%
% Syntax:
%   Y = nemo_profile_retreat(D,z,depths,index,t_index,figswitch)
%
% Input:
%   D: datastruct,
%   z: altitude fieldname
%   d: depths vector
%   index: alongshore indices
%   t_index: time indices
%   figswitch: plot figure / only useful for single transects!
%
% Output:
%   Y: projected disctance to RSP struct with fields:
%        altitude: depths;
%        ymax: maximum cross-shore distance;
%        ymean: mean cross-shore distance;
%   
% Example:
%   Y = nemo_profile_retreat(D,'altitude',[-12:0.5:8],1:644,1:37,1)
%
%   See also: nemo, nemo_volumes_h

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

if length(index)>1;
    ymax=nan(length(D.time),length(D.alongshore),length(d));
    %lmax=ymax;
    ymean=ymax;
    ymin=ymax;
    %y=nan(38,length(d),644);

    for t=t_index;
        for i=index;
            for n=1:length(d);
                dtz=jarkus_distancetoZ(d(n),squeeze(D.(z)(t,i,:)),D.dist); 
                ymin(t,i,n)=dtz(1); 
                ymean(t,i,n)=mean(dtz);
                ymax(t,i,n)=dtz(end); 
            end
            %[~,~,y]=nemo_depth_contour_accurate(D,z,d(n),t); 
            %ymax(t,n)=squeeze(max(y(t,n,index),[],3)); 
            %lmax(t,n)=D.alongshore(y==ymax(t,n));
            %ymean(t,n)=squeeze(nanmean(y(t,n,index),3));
        end
    end
else
    for t=t_index;
        for n=1:length(d);
            dtz=jarkus_distancetoZ(d(n),squeeze(D.(z)(t,index,:)),D.dist); 
            ymin(t,n)=dtz(1); 
            ymean(t,n)=mean(dtz);
            ymax(t,n)=dtz(end); 
        end
    end
end

Y=struct('altitude',d,...
         'ymax',ymax,...
         'ymean',ymean,...
         'ymin',ymin...
         );

if figswitch
    figure;
    subplot(1,2,1);
    plot(D.dist,squeeze(nanmean(D.(z)(t_index(1),index,:),2)),'^-k');
    hold on
    plot(D.dist,squeeze(nanmean(D.(z)(t_index(end),index,:),2)),'.-r');
    xlabel('Distance from RSP [m]')
    ylabel('Altitude [m+NAP]');
    legend('first profile','last profile','Location','Best');
    title(['Mean profiles for transects ',num2str(index(1)),' to ',num2str(index(end))]);
    yl=ylim;
        
    subplot(1,2,2);
    plot(ymean(t_index(end),:)-ymean(t_index(1),:),d,'.-k');
    hold on;
    plot(ymax(t_index(end),:)-ymax(t_index(1),:),d,'x-r');
    ylim(yl);
    vline(0,'-k');
    xlabel('progradation [m]');
    ylabel('Altitude [m+NAP]');
    title('Progradation over depth')
    legend('change of means','change of maxima','Location','Best');
    

end
end
%EOF