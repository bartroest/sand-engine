%NEMO_CORR_ALL Correlates all predefined timeseries
%
%   Correlates volume changes to hydrodynamic conditions.
%
%   Syntax:
%   trend = nemo_altitude_trend(D,z)
%
%   Input: 
%       D: Data struct
%       W: wave data
%
%   Output:
%   	Q: Correlation data
%
%   See also: nemo, nemo_correlator

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
if ~isfield(D,'binwidth');
    D.binwidth=nemo_binwidth(D);
end
dv=V.comp.dv.*repmat(D.binwidth',size(V.comp.dv,1),1);
ae=(V.comp.accretion+V.comp.erosion).*repmat(D.binwidth',size(V.comp.dv,1),1);
% % dv100=nan(size(V.comp.dv));
% % ae100=nan(size(V.comp.dv));
% % dv200=nan(size(V.comp.dv));
% % ae200=nan(size(V.comp.dv));
dv500=nan(size(V.comp.dv));
ae500=nan(size(V.comp.dv));
% % dv1000=nan(size(V.comp.dv));
% % ae1000=nan(size(V.comp.dv));

for n=1:size(dv,2);
% %     i_mask=D.alongshore>=(D.alongshore(n)-50) & D.alongshore<=(D.alongshore(n)+50);
% %     t_mask=all(~isnan(dv(:,i_mask)),2);
% %     dv100(t_mask,n)=sum(dv(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
% %     ae100(t_mask,n)=sum(ae(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
% %     
% %     i_mask=D.alongshore>=(D.alongshore(n)-100) & D.alongshore<=(D.alongshore(n)+100);
% %     t_mask=all(~isnan(dv(:,i_mask)),2);
% %     dv200(t_mask,n)=sum(dv(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
% %     ae200(t_mask,n)=sum(ae(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
    
    i_mask=D.alongshore>=(D.alongshore(n)-200) & D.alongshore<=(D.alongshore(n)+200);
    t_mask=all(~isnan(dv(:,i_mask)),2);
    dv500(t_mask,n)=sum(dv(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
    ae500(t_mask,n)=sum(ae(t_mask,i_mask),2)./sum(D.binwidth(i_mask));

% %     i_mask=D.alongshore>=(D.alongshore(n)-500) & D.alongshore<=(D.alongshore(n)+500);
% %     t_mask=all(~isnan(dv(:,i_mask)),2);
% %     dv1000(t_mask,n)=sum(dv(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
% %     ae1000(t_mask,n)=sum(ae(t_mask,i_mask),2)./sum(D.binwidth(i_mask));
end

fn1=fieldnames(WZM);
for m=1:length(fn1);
    fn2=fieldnames(WZM.(fn1{m}));
        for n=1:length(fn2);
%             Q.dvn1.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),V.comp.dv,[1:length(D.time)]>8);
%             Q.dvg1.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),V.comp.accretion+V.comp.erosion,[1:length(D.time)]>8);
            
% %             Q.dvn100.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),dv100);
% %             Q.dvg100.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),ae100);
% %             
% %             Q.dvn200.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),dv200);
% %             Q.dvg200.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),ae200);
% 
            Q.dvn500.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),dv500,[1:length(D.time)]>8);
            Q.dvg500.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),ae500,[1:length(D.time)]>8);
%             
% %             Q.dvn1000.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),dv1000);
% %             Q.dvg1000.(fn1{m}).(fn2{n})=nemo_correlator(WZM.(fn1{m}).(fn2{n}),ae1000);
        end
end
% % % % %%
% % fn0={'dvn1','dvg1'};%,'dvn500','dvg500'};%,'dvn1000','dvg1000'};%fieldnames(Q);
% % gn={'n','g'};%,'n','g'};
% % for k=1:length(fn0);
% %     fn1=fieldnames(Q.(fn0{k}));
% %     for m=1:length(fn1);
% %         fn2=fieldnames(Q.(fn0{k}).(fn1{m}));
% %             for n=1:length(fn2);
% %                 nemo_plot_corr2(D,Q,gn{k},(fn1{m}),(fn2{n}),['corr_',fn0{k},'__',fn1{m},'_',fn2{n},'_6m']);
% % %                 nemo_plot_correlation(D,Q.(fn0{k}).(fn1{m}).(fn2{n}),1:38,1:644,fn0{k},[fn1{m},'_',fn2{n}],['corr_',fn0{k},'__',fn1{m},'_',fn2{n}]);
% %                 close;
% %             end
% %     end
% % end

%% Table
% func=fieldnames(Q.dvn500); 
% for n=1:length(func); 
%     param=fieldnames(Q.dvn500.(func{n})); 
%     for m=1:length(param);
%         rtable_gross(m,n)=Q.dvg500.(func{n}).(param{m}).alongshore.rp(365);
%         rtable_net(m,n)=Q.dvn500.(func{n}).(param{m}).alongshore.rp(365); 
%         ptable_gross(m,n)=Q.dvg500.(func{n}).(param{m}).alongshore.pp(365);
%         ptable_net(m,n)=Q.dvn500.(func{n}).(param{m}).alongshore.pp(365); 
%     end; 
% end;