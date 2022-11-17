function [L,C,alongshore,cross_shore,ls,cs,RSP]=nemo_build_shorenormalgrid(D,OPT)
%nemo_build_shorenormalgrid - Creates a RSP-based grid. (0,0)=southern most transect origin.
%
% Longshore coordinates increasing along the RSP-line North, metres.
% Cross-shore coordinates increasing off-shore, metres.
% Base-line is RSP-line.
%
% Output:
% L=alongshore coordinates along RSP (from HvH)
% C=cross-shore coordinates perp from RSP
% alongshore=alongshore coordinates along RSP (from HvH)
% ls=alongshore coordinates rotated from RD
% cs=cross-shore coordinates rotated from RD
% RSP=alongshore RSP coordinate (DenHelder)
%
% Valid combinations:
% [L,C]
% [RSP,C]
% [ls,cs]
% [alongshore,dist]
%
%Bart Roest, 2016

load([OPT.basepath,'scripts\matlab\Surveylines_Delfland.mat'],'S');
alongshore=sqrt((D.rsp_x-D.rsp_x(1)).^2+(D.rsp_y-D.rsp_y(1)).^2);
cross_shore=S.dist(:,1);

%% Shore normal rectangular grid (every transect locally shore-normal, angles distorted)
[L,C]=meshgrid(alongshore,cross_shore);
L=L';
C=C';

%% Shore normal rectangular grid, based on Jarkus-RSP km. (Distance from Den Helder).
if ~isfield(D,'cross_shore'); D.cross_shore=D.dist; end
RSP=repmat(double(D.id-D.areacode.*1e6)./100,1,length(D.cross_shore));
%RSP=RSP';

%% Shore normal grid with true angles, rotated from RD(x,y) grid.
%Global orientation=311.3 degree w.r.t N;
temp=[cosd(311.3), -sind(311.3); sind(311.3), cosd(311.3)]*[D.x(:)'-S.x_origin(1);D.y(:)'-S.y_origin(1)];
ls=reshape(temp(1,:),size(D.x));
cs=reshape(temp(2,:),size(D.y));
end
%EOF