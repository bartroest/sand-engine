%NEMO_PLOT_DOC Plots depth of closure.
%
%   See also: nemo, nemo_closuredepth

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
[~,~,c,d]=nemo_closuredepth(D,'z_jnz',0.210,Index.all,Time.all,W,Time);
[~,~,c_j,d_j]=nemo_closuredepth(D,'z_jnz',0.210,Index.jarkus,Time.jarkus,W,Time);

% % figure('Units','centimeters','Position',[5 5 18 10]);
% % subplot(2,1,1); 
% %     plot(D.alongshore,c-930,'.k'); 
% %     hold on; 
% %     plot(D.alongshore(Index.jarkus),c(Index.jarkus)-930,'*k');
% %     ylim([0 2000])
% %     title('Cross-shore distance to DOC');
% %     legend('SE+Nemo','Jarkus','Location','NW');
% %     xlabel('Alongshore distance [m]');
% %     ylabel('Cross-shore distance [m]');
% %     text(-3000,2500,'a');
% % subplot(2,1,2); 

figure('Units','centimeters','Position',[5 5 18 6]);
    plot(D.alongshore(Index.zm),d(Index.zm),'.k'); 
    hold on; 
    plot(D.alongshore(Index.jarkus),d(Index.jarkus),'*k');
    plot(D.alongshore(Index.jarkus),smooth1_nan(d(Index.jarkus)),'-r')
    ylim([-12 -2])
    title('Depth of closure')
    %legend('SE+Nemo','Jarkus','Location','SW');
    xlabel('Alongshore distance [m]');
    ylabel('Depth of closure [m NAP]');
    text(-3000,0,'b');