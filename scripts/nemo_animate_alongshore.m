function nemo_animate_alongshore(D,z,t_idx);
%%NEMO_ANIMATE_ALONGSHORE Shows 5 consecutive CS-profiles, cycling through.
%Shows an animation of 5 cross-shore profiles while walking trough them 
%in alongshore direction.
%
%   Input:
%       D: datastruct
%       z: altitude fieldname
%       t_dix: time index, scalar.
%
%   Output:
%   	figure.
%
%   Example
%   nemo_animate_alongshore(D,'altitude',7);
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
corder=[0.5 0.5 0.5; 0.3 0.3 0.3; 0 0 0; 0.3 0.3 0.3; 0.5 0.5 0.5]; 

figure;
xlim([-100 2000]);
ylim([-8 8]);
hold on;
set(gca,'ColorOrder',corder);
xlabel('Cross shore distance [m]');
ylabel('Altitude w.r.t. NAP [m]');

for i=3:length(D.alongshore)-2;
    set(gca,'ColorOrderIndex',1);
    %h=plot(D.dist,squeeze(D.(z)(t_idx,[i:i+4],:)),'.-'); 
    h(1)=plot(D.cs(i-2,:),squeeze(D.(z)(t_idx,i-2,:)),'.-');
    h(2)=plot(D.cs(i-1,:),squeeze(D.(z)(t_idx,i-1,:)),'.-');
    h(3)=plot(D.cs(i  ,:),squeeze(D.(z)(t_idx,i  ,:)),'.-');
    h(4)=plot(D.cs(i+1,:),squeeze(D.(z)(t_idx,i+1,:)),'.-');
    h(5)=plot(D.cs(i+2,:),squeeze(D.(z)(t_idx,i+2,:)),'.-');
    title(['Profile ',num2str(i-2,'%3.0f'),' through ',num2str(i+2,'%3.0f')]);
    pause(0.2); 
    delete(h);
end