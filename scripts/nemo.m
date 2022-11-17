%nemo - Master script of the thesis research of Bart Roest, and calls the desired ones.
%
% Set OPT switches to run certain scripts (or not).
%
% nemo_help contains an overview of all siblings.
% These scriipts use Open Earth Tools.
%
% See also: nemo, nemo_help, jarkus
%
%-------------------------------------------------------------------------
% VARIABLE DEFINITIONS
%
% Topography/Bathymetry data
% S:     Shore survey lines/grid
% D:     Shore Transect data 2011-20XX
% DL:    Jarkus data Delfland 1965-20XX
% E:     Combined Jarkus and Shore data 1965-2011+2011-20XX
% MB:    Multibeam data Delfland 2012+2015
% P:     Shore Survey path data 2011-20XX
%
% Derived data:
% V:     Volume parameters
% VJ:    Volume parameters Jarkus
% CL:    Coastline parameters
% Y:     Advance/Retreat
% Slope: Cross-shore slopes
% Stats: Altitude statistics
% N:     Nourishment data
% WE:    Wave parameters Europlatform
% WZM:   Wave parameters local
% Time:  Time indices
% Index: Alongshore indices
% OPT:   Options or switches
%
%-------------------------------------------------------------------------
%
% L.W.M. Roest, TUDelft, 2016-2017,2019,2020
% l.w.m.roest@tudelft.nl
% 

% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% $Id: $
% $Date: $
% $Author: $
% $Revision: $
% $HeadURL: $
% $Keywords: $

%% OPT
% Here options are defines which are used in the child scripts.
% Save options
OPT.basepath=     'D:\Users\Bart\zandmotor\morphology\JETSKI\raw\'; %Path to raw data.
OPT.vbbasepath=   'D:\Users\Bart\openearthrawdata\tudelft\vlugtenburg\'; %Path to Vlugtenburg raw data.
OPT.jrawbasepath= 'D:\Users\Bart\zandmotor\morphology\jarkus\'; %Path to raw jarkus data.
OPT.outputfolder= ['D:\Users\Bart\Documents\Civiel\CIE5060-09 Thesis\Zandmotor_Nemo\r',datestr(now,'yyyymmdd'),'\']; %Path to output folder for structs and netCDF's.
OPT.surveylines=  1; %rebuild surveylines/transect defintions.
OPT.raw2trans=    1; %redo interpolation from raw data.
OPT.vb=           1; %include data from 'Vlugtenburg'.
OPT.mb=           0; %include data from 'Mutibeam soundings'.
OPT.jraw=         0; %include the raw jarkus data (only 2012).
OPT.keepraw=      0; %save raw transect data.
OPT.save=         1; %save .mat files.
OPT.write_nc=     1; %write and save new NetCDF files.
%-------------------------------------------------------------------------
% Load options
OPT.loadmaster=   1; %master switch for load.
OPT.l_trans=      1; %load transect .mat
OPT.l_path=       1; %load path .mat
OPT.l_jark=       1; %load jarkus_delfland .mat
OPT.l_surv=       0; %load surveylines .mat
OPT.l_time=       1; %load time_indices .mat
OPT.l_alongs=     1; %load alongshore_indices .mat
OPT.l_raw=        0; %load raw transect data .mat
%OPT.l_adcp=       0; %load ZM adcp data .mat0
OPT.l_vol=        1; %load volumes .mat
%-------------------------------------------------------------------------
% Build options
OPT.buildmaster=  1; %master switch for build.
OPT.b_jark=       1; %create jarkus struct for Delfland.
OPT.b_indices=    1; %create time and alongshore indices structs for pre-defined subsets.
OPT.b_combineJ=   1; %create depth arrays with Jarkus & Shore combined.
OPT.b_interpj=    1; %interpolate Jarkus to grid-resolution (instead of 10m at bathymetry).
OPT.b_shngrid=    1; %create shore normal grid coordinates.
OPT.b_stats=      1; %create statistics for D.altitude.
OPT.b_slope=      1; %create cross-shore slope matrix.
OPT.b_grad=       1; %create gradient matrices (cross-shore and longshore).
OPT.b_volume=     1; %create volume matrices.
OPT.b_waves=      1; %create wave climates.
OPT.b_coastline=  1; %create coastline parameters.
% OPT.b_adcp=       0; %EMPTY
OPT.b_combi=      1; %Combine Jarkus and Shore data from 1965-now.
OPT.b_nourishm=   1; %create nourished volume matrices
%-------------------------------------------------------------------------
% Plot options
OPT.plotmaster=   1; %master switch for plotting.
OPT.pvoltransp=   1; %plot volume changes and LST.
OPT.pvoltimeser=  1; %plot transect volume timeseries.
OPT.pvolstack=    1; %plot volume change timestack.
OPT.pstats=       1; %plot altitude statistics.
OPT.pwave=        1; %plot wave roses.
OPT.pbedlch=      1; %plot bedlevel change.
OPT.pbathystack=  1; %plot stack of bathymetries.
OPT.pbathymetries=1;
OPT.pextrafigs=   1; %plot extra figures for thesis.
OPT.ppaperfigs=   1; %plot all figures for paper.

OPT.print=        1; %print/save images %Used in scripts internally.
OPT.save_ws=      0; %Save all structs in the workspace.

%-------------------------------------------------------------------------
%% Start-tests
% Check if data folder exists; should be a "zandmotordata" svn-checkout.
if ~exist(OPT.basepath,'dir')
    warning('The data folder "%s" does not exist!',OPT.basepath);
    return
end
% Make sure outputfolder exists!
if ~exist(OPT.outputfolder,'dir')
    mkdir(OPT.outputfolder);
end

%% Rebuild interpolated data from raw data

%Rebuild surveylines/transect definitions from initial data when requested.
if OPT.surveylines 
    fprintf(1,'Rebuild the surveylines/transect definitions \n');
    nemo_build_surveylines(OPT);
end

% Rebuild structs of subset indices. (e.g. partial areas or annual data.)
if OPT.b_indices 
    fprintf(1,'Building Time and Alongshore index structs \n');
    nemo_build_indices;
end
%%
if OPT.raw2trans %Rebuild NetCDF's and .mat-files from raw data
    fprintf(1,'Interpolating raw data to transects\n');
    fprintf(1,'This will take a while, go get a cup of coffee... \n');
    tic;
    nemo_raw2transects;
    toc;
    clearvars -EXCEPT OP*; %Clear all the garbage from nemo_raw2transects
end
%%
if OPT.b_jark
    load([OPT.outputfolder,'/Surveylines_Delfland.mat'],'S');
    try
        fprintf(1,'Retreiving Jarkus transect.nc from OpenDAP sever... \n');
        DL=nemo_jarkus('http://opendap.deltares.nl/thredds/dodsC/opendap/rijkswaterstaat/jarkus/profiles/transect.nc',9,S.dist);
        %DL=nemo_jarkus('D:\Users\Bart\openearthrawdata\rijkswaterstaat\jarkus\transect.nc',9,D.dist);
    catch
        %TOOO: Replace by belco_subset!
        DL=nemo_jarkus('D:\Users\Bart\Documents\Civiel\CIE5060-09 Thesis\Zandmotor_Nemo\jarkus\transect_r20190731.nc',9,S.dist);
    end
    save([OPT.outputfolder,'jarkus_delfland.mat'],'-struct','DL');
end

fprintf(1,'Building new structs complete\n');

%% Load
if OPT.loadmaster
    fprintf(1,'Loading all selected mat-files... \n');
    if OPT.l_trans %&& ~OPT.raw2trans;
        D=load([OPT.outputfolder,'transects_combined.mat']); %Shore transects
    end
    if OPT.l_path
        P=load([OPT.outputfolder,'surveypath_combined.mat']); %Shore surveypaths
    end
    if OPT.l_jark
        DL=load([OPT.outputfolder,'jarkus_delfland.mat']); %Jarkus Delfland
    end
    if OPT.l_surv
        load([OPT.basepath,'..\scripts\matlab\Surveylines_Delfland.mat'],'S'); % Shore Surveylines
    end
    if OPT.l_time
        load([OPT.outputfolder,'time_indices.mat']); %Time indices
    end
    if OPT.l_alongs
        load([OPT.outputfolder,'alongshore_indices.mat']); %Alongshore indices
    end
    if OPT.l_raw
        load([OPT.outputfolder,'raw_data_combined.mat']); %Raw transect data (>2.2GB)
        %load('./Morfologische data/Raw_n.mat'); %Raw transect data (>2.2GB)
        R=Raw;
        clear Raw;
    end
    if OPT.l_adcp
        try
        C.E=nemo_load_adcp('savefile',1,'adcp','E',...
            'basepath',[OPT.basepath,'..\..\..\meteohydro\hydrodynamics\adcp\data\'],...
            'outputdir',OPT.outputfolder);
        C.F=nemo_load_adcp('savefile',1,'adcp','F',...
            'basepath',[OPT.basepath,'..\..\..\meteohydro\hydrodynamics\adcp\data\'],...
            'outputdir',OPT.outputfolder);
        catch
            fprintf(1,'directories not found');
        end
    end

    if OPT.l_vol
        try
            load([OPT.basepath,'..\NCdata\volumes.mat']);
        catch
            fprintf(1,'Volumes.mat not found.\n');
        end
        try 
            load([OPT.basepath,'..\NCdata\volumes_jarkus.mat']);
        catch
            fprintf(1,'Volumes_jarkus.mat not found.\n');
        end
    end
end
%% Build
if OPT.buildmaster
    fprintf(1,'Building/calculating new properties. \n');

    
    if OPT.b_combineJ
        fprintf(1,'Combine Jarkus and Shore data. \n');
        [D.z_jarkus, D.z_jnz, D.time_jarkus]=nemo_combine_jarkus_shore(D, DL);
    end
    
    if OPT.b_interpj && (OPT.l_jark || OPT.b_jark)
        fprintf(1,'Interpolate off-shore Jarkus data to grid-spacing. \n');
        DL.alt_int=nemo_jarkus_interp_cs(DL);
    end
    
    if OPT.b_shngrid
        fprintf(1,'Create shore-normal grids or alternative coordinate schemes. \n');
        [D.L, D.C, D.alongshore,  D.dist, D.ls, D.cs, D.RSP] =nemo_build_shorenormalgrid(D);
        D.binwidth=nemo_binwidth(D);
        if OPT.l_jark || OPT.b_jark
        [DL.L,DL.C,DL.alongshore1,DL.dist,DL.ls,DL.cs,DL.RSP]=nemo_build_shorenormalgridjarkus(DL,OPT);
        end
    end
    
    if OPT.b_stats
        fprintf(1,'Calculate statistics of ''D.altitude''. \n');
        Stats.altitude=nemo_stats(D,'altitude',5,Index.all,Time.all); 
        
        fprintf(1,'Calculate statistics of ''D.z_jnz''. \n');
        Stats.z_jnz=nemo_stats(D,'z_jnz',5,Index.all,Time.all); 
        
         if OPT.l_jark && OPT.b_interpj
         fprintf(1,'Calculate statistics of ''DL.altitude''. \n');
         Stats.jark=nemo_stats(DL,'alt_int',5,1:length(DL.alongshore),48:length(DL.time)); 
         end
    end

    if OPT.b_slope
        fprintf(1,'Calculate slopes. \n');
        %REPLACE WITH BETTER SCRIPT.
%         %Slope.dh=nemo_get_slope(D,'altitude',Time.all);
%         [Slope.h20.s,Slope.h20.d_on,Slope.h20.d_off]=nemo_build_slope(D,'altitude',2.5,0.8);
%         [Slope.h04.s,Slope.h04.d_on,Slope.h04.d_off]=nemo_build_slope(D,'altitude',0,-4);
%         [Slope.h13.s,Slope.h13.d_on,Slope.h13.d_off]=nemo_build_slope(D,'altitude',1,-3);
        [Slope.intertidal.s,Slope.intertidal.d_on,Slope.intertidal.d_off]=nemo_build_slope(D,'altitude', 1.5,-1.5);
        [Slope.subaq.s,     Slope.subaq.d_on,     Slope.subaq.d_off     ]=nemo_build_slope(D,'altitude',-2  ,-6  );
        [Slope.subaer.s,    Slope.subaer.d_on,    Slope.subaer.d_off    ]=nemo_build_slope(D,'altitude', 6  , 2  );
    end
    
    if OPT.b_grad
        fprintf(1,'Calculate local gradients. \n');
        [Slope.gls,Slope.gcs]=nemo_gradients(D,'altitude','lscs',Index.all,Time.all);
    end
    
    if OPT.b_volume
        fprintf(1,'Calculate volumes and -changes of transects. \n');
        fprintf(1,'Volumes of all surveys. \n');
        [V.all,~,~]= nemo_volumes(D,'altitude',Index.all,Time.all,   'other');
        fprintf(1,'Volumes of ZM surveys. \n');
        [V.zm,~,~]= nemo_volumes(D,'altitude',Index.zm,Time.all,     'other');
        fprintf(1,'Volumes of NeMo surveys. \n');
        [V.nemo,~,~]=nemo_volumes(D,'altitude',Index.all,Time.nemo,  'other');
        fprintf(1,'Volumes of Vlugtenburg survyes. \n');
        [V.vb,~,~]=  nemo_volumes(D,'altitude',Index.vb, Time.vbnemo,'other');
        fprintf(1,'Volumes of Vlugtenburg survyes. \n');
        [V.zmplus,~,~]=  nemo_volumes(D,'altitude',Index.zmplus, Time.zmplus,'other');
        V.comp=nemo_composite_volume(V,Index);
        
        fprintf(1,'Volumes including lakes etc. \n');
        [V.area,~,~]=nemo_volumes(D,'altitude',Index.all,Time.all,'all');
    end
    
    if OPT.b_VH
        fprintf(1,'Calculate volumes & volume changes for horizontal slices. \n');
        fprintf(1,'This takes very long, get some more coffee or have lunch... \n');
        tic;
        %nemo_volumes_h
        fprintf(1,'Done after %8.0f s \n',toc);
    end
 
    %%
    if OPT.b_adcp
        %ADCP-data can only be loaded
        %A t_tide tidal analysis may be added here...
    end
    
    %%
    if OPT.b_combi
        %Copy D, and remove unnecessary fields
        E=rmfield(D,{'kind','linetype','interpmask','time','time_nemo','time_jarkus','time_vb','z_jarkus','z_jnz','min_cross_shore_measurement','max_cross_shore_measurement'});
        E.altitude=nan(47+length(Time.all),644,1925); 
        for t=1:47; %Jarkus up to, not including 2011.
            [E.altitude(t,:,:),~,~]=nemo_jarkus2shoregrid(DL,D,t); 
        end
        E.altitude(48:end,:,:)=D.z_jnz(Time.all,:,:);
        E.time(1:47)=round(nanmean(DL.time_bathy(1:47,:),2))+datenum(1970,1,1);
        E.time(48:48+length(Time.all))=D.time(Time.all);
        E.time=E.time';
    end
    
    if OPT.b_nourishm
        N=nemo_load_nourishments(D,1971,2017);
    end
    
    if OPT.b_coastline
        fprintf(1,'Determine Coastline Parameters at z=-0.5m NAP');
        for t=1:length(D.time); [CL.ang(t,:),CL.ang_g(t),CL.ls(t,:),CL.cs(t,:),CL.curv(t,:),CL.dist(t,:)]=nemo_coastline_orientation(D,'altitude',-0.5,t,6,false); end
    end
    
    if OPT.b_waves
        addpath([OPT.basepath,'..\..\meteohydro\Golftransformatie\Tool\tool']);
        fprintf(1,'Determine the wave climate of EURPFM & ZM_BOEI. \n');
%         WE=nemo_read_waterbase_waves; %EURPFM waves
%         WE.climate=nemo_wave_climate(D,WE.d,WE.h,WE.p,WE.time,Time.all);
        %ZM_BOEI waves
        %WZM =nemo_read_zmwavebuoy('./Data/20170119_005/20170119_005.csv');
        %WZM=nemo_load_zmwave;
        %WZM.climate=nemo_wave_climate(D,WZM.Th0,WZM.Hm0,WZM.Tm01,WZM.time,Time.all);
        %Wave transformation tool ZM
        %[WZM,s]=nemo_wavetransform(70744,451833,'ZMBoei_loc');
        [W,s,wzm,eur,ym6,eld]=nemo_wavetransform(71552,453583,{'off_zm_filled'}); %Transformation towards tip of ZM, 12m depth.
        WZM.climate=nemo_wave_climate(D,WZM.phi,WZM.Hs,WZM.Tp,WZM.time,Index,Time,CL);
    end
    
    
end

%% META

Meta=struct('D',{'Shore Transect data'},...
            'DL',{'Jarkus data Delfland'},...
            'E',{'Combined Jarkus and Shore data'},...
            'P',{'Shore Survey path data'},...
            'S',{'Shore survey lines'},...
            'V',{'Derived: Volume parameters'},...
            'VJ',{'Derived: Volume parameters jarkus'},...
            'CL',{'Derived: Coastline parameters'},...
            'Y',{'Derived: Advance/Retreat'},...
            'WZM',{'Derived: Wave parameters local'},...
            'WE',{'Wave parameters Europlatform'},...
            'N',{'Nourishments'},...
            'Slope',{'Derived: Slopes'},...
            'Stats',{'Derived: Altitude statistics'},...
            'Time',{'Time indices'},...
            'Index',{'Alongshore indices'},...
            'OPT',{'Options or switches'}...
            );

%% Save
% if OPT.save_ws
%     %Better not do this!
%     save('Nemo_data.mat'); 
% end


%% Plot
if OPT.plotmaster
    %% Bathymetry
    if OPT.pbathymetries
        nemo_plot_bathymetry(D,'ls','cs','altitude',DL);
        nemo_movie_bathy;
        %Internal print routines
        close all;
        nemo_plot_altitude(D,'altitude');
        close all
    end
        
        
    if OPT.pbathystack
        nemo_plot_bathymetry_stack(D,'altitude',Index.all,Time.july);
        if OPT.print
            print2a4(['./figures/bathymetry/bathystack_july'],'l','n','-r200','o'); 
        end
        close all;
        nemo_plot_bathymetry_stack(D,'altitude',Index.all,Time.all);
        if OPT.print
            print2a4(['./figures/bathymetry/bathystack_all'],'l','n','-r500','o'); 
        end
        close all;
    end
    
    if OPT.ptransect
        t_idx=1:length(D.time);
        for i=1:length(D.alongshore);
            tt=squeeze(sum(~isnan(D.altitude(:,i,:)),3))>10;
            nemo_plot_transect(D,'altitude',i,t_idx(tt));
            print2a4(['./figures/transects/transect_',num2str(i,'%i')],'l','n','-r200','o');
        end
        close all;
    end

    %end
    
    %% Volume change & transport
    if OPT.pvoltransp % Annual volume changes and sediment transport.
        %[V,index,t_index]=nemo_volumes(D,'altitude',Index.all,Time.all);
        nemo_plot_volume_transport(D, V.comp, Index.all, Time.all, OPT);
%         if OPT.print
%             print2a4(['./figures/Volume_Transport_Yearly',datestr(D.time(t_index(t)),'yyyy_mm'),'_',datestr(D.time(t_index(t+1)),'yyyy_mm')],'l','n','-r200','o');
%         end
        nemo_plot_volume_transport_daily(D, V.comp, Index.all, Time.all, OPT);
        nemo_plot_volume_transport_total(D, V.comp, Index.all, Time.all, OPT);
        nemo_plot_volume_transport_total_daily(D, V.comp, Index.all, Time.all, OPT);
        
        close all;
    end
    %%
    if OPT.pvoltimeser % Timeseries of volume changes.
        %Timeseries Zandmotor area
        %[V_zm, ~, t_index]=nemo_volumes(D,'altitude',Index.zm,Time.all);
        for i=305:428;
            nemo_plot_volume_timeseries(D,'altitude','time',V.comp,i,Time.all,'zm');
            if OPT.print
                print2a4([OPT.outputfolder,'/figures/timeser/Timeseries of transect ',num2str(i),' from HvH'],'l','n','-r200','o');
                close(gcf);
            end
        end
        
        %Timeseries Nemo area
        %[V_n, ~, t_index]=nemo_volumes(D,'altitude',Index.all,Time.nemo);
        for i=[1:304,429:610]; 
            nemo_plot_volume_timeseries(D,'altitude','time_nemo',V.nemo,i,Time.nemo,'nemo');
            if OPT.print
                print2a4([OPT.outputfolder,'/figures/timeser/Timeseries of transect ',num2str(i),' from HvH'],'l','n','-r200','o'); 
                close(gcf);
            end
        end
        
        %Timeseries Vlugtenburg area
        %[V_n, ~, t_index]=nemo_volumes(D,'altitude',Index.all,Time.nemo);
        if OPT.vb
            for i=[Index.vb] 
                nemo_plot_volume_timeseries(D,'altitude','time_vbnemo',V.vb,i,Time.vbnemo,'vb');
                if OPT.print
                    print2a4([OPT.outputfolder,'/figures/timeser/Timeseries of transect ',num2str(i),' from HvH'],'l','n','-r200','o'); 
                    close(gcf);
                end
            end
        end
        
        %Timeseries Jarkus transects (1965-2015)
        z_j=nan(52,644,1925);
        for t=1:length(DL.time);
            z_j(t,:,:)=nemo_jarkus2shoregrid(DL,S,t);
        end
        %[index, t_index, Volume, dV, dT, Accretion, Erosion]=nemo_volumes_new(D,'altitude',Index.jarkus,1:51);
        [index, t_index, Volume, dV, dT, Accretion, Erosion]=nemo_volumes_new(D,'z_j',Index.jarkus,1:52);
        for i=index;
            nemo_plot_volume_timeseries(DL,'z_j',dV,i,t_index,Index,Accretion,Erosion);
            if OPT.print
                print2a4(['./figures/Timeseries of Jarkus transects ',num2str(i),' from HvH'],'l','n','-r200','o'); 
            end
        end
        
    end
    %%
%     if OPT.plotvolstack
%         nemo_plot_volume_stack(D,V,'dv',Index.all,Time.all,'difference');
%     end
    if OPT.pvolstack
        nemo_plot_volume_stack(D,V,'dv',Index,Time.all,'difference');
        if OPT.print
            print2a4(['./figures/volstack_dv'],'l','n','-r200','o'); 
        end
        close all;
    end
    
    if OPT.pstats
        nemo_plot_stats(D,Stats,'stdz',threshold);
        if OPT.print
            print2a4(['./figures/Std_altitude'],'l','n','-r200','o'); 
        end
        close all;
    end
    
    if OPT.pwave
        nemo_plot_wave_rose(D,WE,Time.all,WZM);
        close all;
        %Internal print routine.
    end
    
    if OPT.pbedlch
        nemo_plot_bedlch(D,'altitude',Index.all,Time.all,'auto');
        close all;
        nemo_plot_normbedlch(D,'altitude',Index.all,Time.all);
        close all;
        %Internal print routines
    end
      

    
    if OPT.pextrafigs
        nemo_extra_figures;
        close all;
    end
    
    if OPT.ppaperfigs
        nemo_figures_for_paper;
        close all;
    end
end
%EOF