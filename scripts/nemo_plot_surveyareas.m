function nemo_plot_surveyareas(D,DL,Index)
%nemo_plot_surveyareas Plots an indication of the different survey domains
%
%   See also: nemo, plot_map2

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
plot_map2;
hold on;
%axis equal;

%Jarkus
mask=squeeze(sum(~isnan(DL.altitude))>5);
h1=plot(DL.x(mask),DL.y(mask),'.r');

%Nemo
mask=squeeze(sum(~isnan(D.altitude))>5);
h2=plot(D.x(mask),D.y(mask),'.y');

%VB
mask=squeeze(sum(~isnan(D.altitude))>5) & D.L>D.alongshore(Index.vb(1)) & D.L<D.alongshore(Index.vb(end));
h3=plot(D.x(mask),D.y(mask),'.g');

%ZM
mask=squeeze(sum(~isnan(D.altitude))>5) & D.L>D.alongshore(Index.zm(1)) & D.L<D.alongshore(Index.zm(end));
h4=plot(D.x(mask),D.y(mask),'.b');

legend([h1,h2,h3,h4],{'Jarkus','Nemo','Vlugtenburg','Zandmotor'});