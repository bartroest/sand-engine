function [dt,vertices,faces,cdata]=nemo_voronoi(P,coordsys,t_index,plotswitch)
%NEMO_VORONOI Determines and plots the Voronoi diagram of a survey
%
%   Calculates the voronoi diagram for a survey from the raw survey data, based
%   on delaunay triangulation of the surveypoints.
%
%   Syntax:
%   	[dt,vertices,faces,cdata]=nemo_voronoi(P,coordsys,t_index,plotswitch)
%
%   Input: 
%       P: Survey path struct
%       coordsys: coordinate system ('path_RD' or 'path')
%       t_index: time index (scalar!)
%       plotswitch: plot a figure or not (true|false)
%
%   Output:
%   	dt: delaunay triangulation object
%       vertices: vertices of the voronoi
%       faces: faces of the voronoi
%       cdata: colordata
%
%   Example:
%       [dt,vertices,faces,cdata]=nemo_voronoi(P,'path_RD',7,true);
%
%   See also: nemo, delaunay, voronoin,

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

%%
[~,idx,~]=unique(squeeze(P.(coordsys)(t_index,:,[1,2])),'rows'); %Search unique XY-coordinates
un=squeeze(P.(coordsys)(t_index,idx,:)); %Squeeze to 2D matrix
mask=~isnan(un(:,1)); %Mask all nan's
un=un(mask,:); %Matrix with unique XY-coordinates (and corresponding Altitudes).

%dt = delaunayTriangulation(un(:,1),un(:,2)); %Make Delaunay Triangulation.
dt=[];
%[vertices,faces] = voronoiDiagram(dt); %Make voronoi diagram.

%[~, ~, pathmask]=intersect(dt.Points,squeeze(P.(coordsys)(t_index,:,[1 2])),'rows');
%cdata=un(:,3);

%% Plot stuff
% if plotswitch
%     plotswitch=input('Plotting this takes very long, continue? [1 0]: ');
% end

[vertices,faces]=voronoin([un(:,1),un(:,2)]);
cdata=un(:,3);
%pHandle = nan(1, numel(faces));
if plotswitch
    ff=figure;
%Plotting this is INEFFICIENT and SLOW and CPU-INTENSIVE!
    for i = 1:numel(faces)
        if all(faces{i}~=1) 
        % If at least one of the indices is 1, then it is an open region
        % and we can't patch that.
            %pHandle(i)=
            patch(vertices(faces{i},1),vertices(faces{i},2),cdata(i)); % use color i.
        end
    end
    
    
% % for n=1:length(faces); mask(n)=all(faces{n}~=1); end    
% % for m=mask;
% %      patch('Faces',faces(m),'Vertices',vertices,'FaceVertexCData',cdata(m));
% % %     patch('Faces',cc{mask},'Vertices',vv);
% % end
    
    xlabel('X_{RD} [m]');
    ylabel('Y_{RD} [m]');
    title(['Voronoi diagram of the Sand Engine (survey ',num2str(t_index,'%i'),')']);
%     colorbar('north');
    
    nemo_planbound('ZM',1,1);
    axis equal
%     xlim([0 17500])
%     ylim([0 3000])
    %view([48,90]);
    
end
%pp.EdgeColor='none';