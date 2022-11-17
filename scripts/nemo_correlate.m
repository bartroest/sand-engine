function [x, y, X, Y, xhat, yhat, R]=nemo_correlate(Xin,Yin)
%NEMO_CORRELATE Correlates two properties, both scaled and unscaled
%
% Xin and Yin must be of equal size
% Scaled means X=(Xin-mean(Xin))/std(Xin)
%
% Returns x,y scaled properties without nans
%         X,Y unscaled properties without nans
%         R correlation coefficients
%         plots
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

mask=~isnan(Xin) & ~isnan(Yin);
X=Xin(mask);
Y=Yin(mask);
xm=mean(X);
ym=mean(Y);
xstd=std(X);
ystd=std(Y);

x=(X-xm)./xstd;
y=(Y-ym)./ystd;

xhat=strd_norm_trans(X);
yhat=strd_norm_trans(Y);

%[a, b]=polyfit(x,y,1);

r=corrcoef([X Y]);
R(1)=r(1,2);
r=corrcoef([x y]);
R(2)=r(1,2);
r=corrcoef([xhat yhat]);
R(3)=r(1,2);

figure; plot(x,y,'.k'); axis equal;
title(['R^2=',num2str(R(2))])
figure; plot(X,Y,'.r');
title(['R^2=',num2str(R(1))])
figure; plot(xhat,yhat,'.r');
title(['R^2=',num2str(R(3))])