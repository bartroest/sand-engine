function corvars=nemo_correlator(D,E,tidx)
%NEMO_CORRELATOR Detemines R^2 and corrcoefs of the columns of two matrices.
%
%Insert two equally shaped 2D-matrices.
%Correlations are calculated over the first dimension of D, transpose
%matrices if necessary.
%
% Input: D: matrix 1 [m n]
%        E: matrix 2 [m n]
%
% Output: Struct with fields:
%           rsq: R^2 [m 1]
%           rp: r-pearson [m 1]
%           rs: r-spearman [m 1]
%           slope: slope of linear fit [m 1]
%           interc: intercept of linear fit [m 1]
%
% Example:
%   corvars=nemo_correlator(WZM.rms.H,V.comp.dv)
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
%% TIME domain

% % % %% TIME --> Does not make any sense
% % % rsq=nan(size(D,1),1);
% % % rp=nan(size(D,1),1);
% % % pp=nan(size(D,1),1);
% % % rs=nan(size(D,1),1);
% % % ps=nan(size(D,1),1);
% % % slope=nan(size(D,1),1);
% % % interc=nan(size(D,1),1);
% % % 
% % % for k=1:size(D,1);
% % %     mask=~isnan(D(k,:)) & ~isnan(E(k,:)); %Only non-nan values
% % % % %     %[FO,G]=fit(D(k,mask),E(k,mask),'poly1');
% % % % %     [P,R]=polyfit(D(k,mask),E(k,mask),1);
% % % % %     slope(k)=P(1);
% % % % %     rf(k)=R.R(1,1);
% % % % %     
% % % % %     [R]=corr(D(k,mask)',E(k,mask)');
% % % % %     r(k)=R;
% % % 
% % %     if sum(mask)>2;
% % %         q=fitlm(D(k,mask),E(k,mask)); %Make linear fit: E=aD+b
% % %         rsq(k)=q.Rsquared.Ordinary; % R^2
% % %         slope(k)=q.Coefficients.Estimate(2); %a
% % %         
% % %         [rp(k), pp(k)]=corr(D(k,mask)',E(k,mask)','type','pearson');
% % %         [rs(k), ps(k)]=corr(D(k,mask)',E(k,mask)','type','spearman');
% % %     else
% % %         rsq(k)=nan;
% % %         slope(k)=nan;
% % %         
% % %         rp(k)=nan;
% % %         rs(k)=nan;
% % %         pp(k)=nan;
% % %         ps(k)=nan;
% % %     end
% % % end
% % % 
% % % corvars.time.rsq=rsq; %R^2
% % % %garbage.time.r=sqrt(rsq).*sign(slope); %r
% % % corvars.time.rp=rp; %r-pearson
% % % corvars.time.pp=pp;
% % % corvars.time.rs=rs; %r-spearman
% % % corvars.time.ps=ps;
% % % corvars.time.slope=slope; %a slope of linear fit
% % % corvars.time.interc=interc; %b intercept of linear fit

%% ALONGSHORE domain
if nargin < 3;
    tidx=true(size(D,1),1);
end
D=D'; %Transpose matrices to act along other dimension
E=E';

% rsq=nan(size(D,1),1);
rp=nan(size(D,1),1);
pp=nan(size(D,1),1);
rs=nan(size(D,1),1);
ps=nan(size(D,1),1);
% slope=nan(size(D,1),1);
% interc=nan(size(D,1),1);

for k=1:size(D,1);
    mask=~isnan(D(k,:)) & ~isnan(E(k,:)) & tidx;
    if sum(mask)>3;
%         q=fitlm(D(k,mask),E(k,mask));
%         rsq(k)=q.Rsquared.Ordinary;
%         slope(k)=q.Coefficients.Estimate(2);
%         interc(k)=q.Coefficients.Estimate(1);
        [rp(k), pp(k)]=corr(D(k,mask)',E(k,mask)','type','Pearson');
        [rs(k), ps(k)]=corr(D(k,mask)',E(k,mask)','type','Spearman');
    else
%         rsq(k)=nan;
%         slope(k)=nan;
        rp(k)=nan;
        rs(k)=nan;
        pp(k)=nan;
        ps(k)=nan;
    end
end

corvars.alongshore.rsq=rp.^2;
corvars.alongshore.rp=rp; %r-pearson
corvars.alongshore.pp=pp; %r-pearson
corvars.alongshore.rs=rs; %r-spearman
corvars.alongshore.ps=ps; %r-spearman
% corvars.alongshore.slope=slope;
% corvars.alongshore.interc=interc;
corvars.D=D';
corvars.E=E';
end
%EOF