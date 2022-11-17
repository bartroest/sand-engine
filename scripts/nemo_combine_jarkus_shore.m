function [z_jarkus,z_jnz,time_jarkus]=nemo_combine_jarkus_shore(D,DL)
%NEMO_COMBINE_JARKUS_SHORE Combines Jarkus measurements and Shore surveys.
% Combines the data from Shore-surveys with Jarkus data, and puts it in one
% matrix. Shore data is leading when both are available.
%
% Syntax: [z_jarkus,z_jnz,time_jarkus]=...
%         nemo_combine_jarkus_shore(Shore-datastruct,Jarkus-datastruct);
%
% Input:
% D: Shore-data struct
% DL: Jarkus-data struct
%
% Output:
% z_jarkus: Only jarkus data, but mapped to shore-grid.
% z_jnz:    Jarkus-data is overwritten by Shore-data where available.
%           Effectively the Shore-data extended with Jarkus, where
%           available.
% t_jarkus: average of Jarkus' time_bathy.
%
% Time_indices are hard-coded! Please adjust when necessary.
%
% Example
%   [z_jarkus,z_jnz,time_jarkus]=nemo_combine_jarkus_shore(D,DL)
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
fprintf(1,'NOTE: Time_indices are hard-coded! Please adjust when necessary. \n');
tn=[ 1  7 18 23 30 37 41 43 46]; %Combined time_indices of Shore surveys
tj=[47 48 49 50 51 52 53 54 55]; %... and Jarkus.
% [ztime,jtime]=meshgrid(D.time,nanmean(DL.time_bathy(47:end,DL.id>9010159),2));
% [~,tn]=ind2sub(size(tj),find(abs(jtime-ztime)==nanmin(abs(jtime-ztime),2)));

z_jnz=D.altitude; %replicate altitude matrix;
z_jarkus=nan(size(D.altitude));
time_jarkus=zeros(size(D.time));
for i=1:length(tj) % For every jarkus time
    fprintf(1,'Patching Shore survey # %2.0f of %s to Jarkus # %2.0f of %s \n',tn(i),datestr(D.time(tn(i)),'dd-mmm-yyyy'),tj(i),datestr(round(nanmean(DL.time_bathy(tj(i),:))+datenum(1970,1,1)),'dd-mmm-yyyy'));
    index_jarkus=sum(~isnan(squeeze(DL.altitude(tj(i),:,:))),2)>2;
    
    temp=nemo_jarkus2shoregrid(DL,D,tj(i)); %load jarkus to shore transects
    z_jarkus(tn(i),:,:)=temp; %write jarkus to shore transects
    z_jnz(tn(i),:,:)=temp; %overwrite shore with Jarkus (1)
    
    mask=squeeze(~isnan(D.altitude(tn(i),:,:)));
    z_jnz(tn(i),mask)=D.altitude(tn(i),mask); %overwrite Jarkus where Shore is available (2)
    %time_jarkus(tn(i))=DL.time_bathy(tj(i),5)+datenum(1970,1,1);
    time_jarkus(tn(i))=round(nanmean(DL.time_bathy(tj(i),index_jarkus)),0);
end
%EOF