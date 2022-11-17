function [x1, x2, lst]=nemo_regime_indicator(D,dv,Index,Time);
%NEMO_REGIME_INDICATOR Determines the extent of erosion along the Sand Engine peninsula.
%
%   Determines the alongshore coordinates where ersion has occured along the
%   Sand Engine peninsula. This zone shifts with the wave climate.
%   !!!Script needs improvement!!!
%
%   Syntax:
%       [x1, x2, lst]=nemo_regime_indicator(D,V,Index,Time);
%
%   Input: 
%       D: Data struct
%       dv: matrix with volume changes with size [time alongshore]
%       Index: struct with alongshore indices
%       Time: struct with time indices
%
%   Output:
%   	x1: lower limit of erosion
%       x2: upper limit of erosion
%       lst: distance
%
%   Example:
%       [x1, x2, lst]=nemo_regime_indicator(D,V.all.dv,Index,Time);
%
%   See also: nemo, nemo_indices, nemo_volumes

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
x1=nan(size(dv,1),1);
x2=nan(size(dv,1),1);
binwidth=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]'./2;

lst=nancumsum(dv.*repmat(binwidth,size(dv,1),1),2);

for t=Time.all;
    if lst(t,end)~=0;

        x1(t)=find(lst(t,:)==max(lst(t,Index.zm)),1,'last');
        %x2(t)=find(lst(t,:)==min(lst(t,Index.zm)),1);
        if x1(t)>=425;
            x1(t)=find(lst(t,:)==max(lst(t,304:365)),1,'last');
            %x2(t)=find(lst(t,:)==min(lst(t,x1(t):428)),1);
        end
        if x1(t)>=365;
            x2(t)=find(lst(t,:)==min(lst(t,300:x1(t))),1,'last');
        else 
            x2(t)=find(lst(t,:)==min(lst(t,x1(t):428)),1,'last');

        %5if x2(t)>=425;
           %x1(t)=find(lst(t,:)==max(lst(t,Index.zm)),1);
         %   x2(t)=find(lst(t,:)==min(lst(t,304:x1(t))),1);
            %x2(t)=find(lst(t,:)==min(lst(t,x1(t):428)),1);
        end
    end
end

t1=D.time(~isnan(x1)); t1=t1+[diff(t1)./2;50];
t2=D.time(~isnan(x2)); t2=t2+[diff(t2)./2;50];
figure; pcolor(D.alongshore,D.time,dv); shading flat;
csym; colormap(jwb(100,0.02))
hold on
plot(D.alongshore(x1(~isnan(x1))),t1,'+-r',D.alongshore(x2(~isnan(x2))),t2,'x-m');

figure;
plot(D.time(~isnan(x1)),D.alongshore(x1(~isnan(x1))),'x-',D.time(~isnan(x2)),D.alongshore(x2(~isnan(x2))),'x-');
grid on
xlabel('Time');
ylabel('Alongshore distance from HvH [m]');
title('Indication of the eroding parts of the Sand Engine');
legend('Start of eroding part','End of eroding part');