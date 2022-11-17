function [binwidth, bw]=nemo_binwidth(D)
%NEMO_BINWIDTH Defines the representative alongshore distance associated with a transect.
%
% The binwidth is equal to the sum of half the distance to both
% neighbouring transects. 
% e.g. 0.5*delta_left+0.5*delta_right.
%
% This script determine the average alongshore spacing between transects at
% places where data is present. This is important since not all transects
% have the same orientation and the alongshore spacing at the RSP-line
% might deviate considerably from the average area where the data is
% present.
%
%   Syntax:
%   binwidth=nemo_binwidth(D);
%
%   Input: 
%       D: Data struct
%
%   Output:
%   	binwidth: representative alongshore distance associated to transect
%       bw: distance between transects at RSP lin (old definition).
%
%   Example
%   binwidth=nemo_binwidth(D);
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
if ~strcmpi(fieldnames(D),'ls');
    [~,~,~,~,ls,cs,~]=nemo_build_shorenormalgrid(D);
else
    ls=D.ls; %Alongshore coordinates rotated from RD.    
end

%mask=squeeze(sum(~isnan(D.altitude([7,17:38],:,:)),1)>5); %Determine where sufficient surveys are present
alti=D.altitude; alti(alti<-100)=nan;
mask=squeeze(sum(~isnan(alti([7,17:38],:,:)),1)>5); %Determine where sufficient (>5) surveys are present
ls(~mask)=nan;

bw=nan(length(D.alongshore)-1,1); %pre-allocate
for n=2:length(D.alongshore)-1; 
    bw(n)=nanmean(nanmean(diff(ls(n-1:n+1,:),1,1),1),2);
end
%Determine the average alongshore spacing between transects at places where data is present.
%This is important since not all transects have the same orientation and
%the spacing at the RSP-line might deviate considerably from the average
%area where the data is present.
binwidth=bw;  binwidth(end+1)=nan;

% In principle the next line does the trick, but less accurate. Now used to
% fill some gaps for lines with less/no data.
% Takes spacing at RSP-line, but is not always representative for data on
% these transects.
bw=[2*diff(D.alongshore(1:2)) ; diff(D.alongshore(1:end-1))+diff(D.alongshore(2:end)) ; 2*diff(D.alongshore(end-1:end))]./2;
binwidth(isnan(binwidth))=bw(isnan(binwidth));
end