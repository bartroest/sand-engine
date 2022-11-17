help('nemo_help');
% NEMO_HELP Overview of NEMO routines
% nemo                           - Master script of the thesis research of Bart Roest, and calls the desired ones.
% nemo_EOF                       - Performs Empirical Orthagonal Function analysis on transects.
% nemo_MKL                       - calculates the MKL position for given transects.
% nemo_MKL_trend                 - Calculates the trend based on calculated MKL's in m/year.
% nemo_Schematize_data           - Script to schematise XYZ along a track to predefined survey lines
% nemo_altitude_trend            - Calculates the linear trend of bed-level per point.
% nemo_animate_alongshore        - Shows 5 consecutive CS-profiles, cycling through.
% nemo_animate_transect          - Shows a cycle of all consecutive surveys for 1 transect.
% nemo_bar_detector              - Detects locations of local maxima (bars) and minima (troughs).
% nemo_bathyfila                 - Determines the first and last available altitude at a position.
% nemo_binwidth                  - Defines the representative alongshore distance associated with a transect.
% nemo_build_indices             - Build time and alongshore indices for useful subsets.
% nemo_build_shorenormalcoordinates - Transforms RD to local shorenormal coordinates.
% nemo_build_shorenormalgrid     - Creates a RSP-based grid. (0,0)=southern most transect origin.
% nemo_build_slope               - Calculates the average bed slope between two bed levels;
% nemo_build_surveylines         - Builds the transects for the Delfland coast.
% nemo_cerc                      - Determines the sediment transport rate according to the CERC formula.
% nemo_closuredepth              - Finds the depth of closure based on variance of the altitude.
% nemo_cmap_volch                - Colormap for ZM volume change [-2500 2500] m3/m.
% nemo_coastline_orientation     - Calculates the orientation of a depth contour
% nemo_combine_jarkus_shore      - Combines Jarkus measurements and Shore surveys.
% nemo_combine_matroos_locations - Patches missing data from other station.
% nemo_combine_noos              - Combined NOOS files from a location.
% nemo_composite_volume          - Builds a composite matrix for volumes, based on alongshore position.
% nemo_corr_all                  - Correlates all predefined timeseries
% nemo_corr_table                - Presents a table with correlation coefficients.
% nemo_correlate                 - Correlates two properties, both scaled and unscaled
% nemo_correlate_profiles        - Correlates two profiles, and return paramters.
% nemo_correlator                - Detemines R^2 and corrcoefs of the columns of two matrices.
% nemo_crossref_surveydates      - Read the survey dates for the different surveydomains.
% nemo_data2netcdf               - Exports Delfland combined transect data to NetCDF.
% nemo_depth_contour_accurate    - Finds the most seaward position from RSP to the desired depth.
% nemo_depth_contour_lc          - Finds the most seaward position of the desired depth on ls,cs grid.
% nemo_depth_contour_xy          - Finds the most seaward position of the desired depth on the RD-XY grid.
% nemo_depth_contours_accurate   - Finds most seaward position of depth1 and first position of depth2 following depth1.
% nemo_download_matroos          - _DATA Downloads NOOS files from the RWS Matroos server.
% nemo_erosive_extent            - UNFINISHED! Determines the alongshore extent of the erosive area.
% nemo_extra_figures             - nemo_plot_extra_figures - Creates extra figures needed for thesis report.
% nemo_extract_line_Shore        - Extracts data from the surveypath in the vicinity of the Surveyline.
% nemo_fparams                   - Determines and plots the fitting parameters for a gaussian on a depth contour.
% nemo_gaus_fit                  - Fits a Gaussian to an isobath of the Sand Engine.
% nemo_get_data_line             - Gets data from surveypath for arbitrary line.
% nemo_get_slope                 - Calculates the pointwise cross-shore slope of transects.
% nemo_gradients                 - calculates the gradient along axes of the specified coordinate system.
% nemo_gridded                   - Makes a gridded surface from surveypath with no extrapolation.
% nemo_height_distribution       - NEMO_ALTITUDE_CHANGE_DISTRIBUTION Calculates average bedlevel change for several altitudes in the coastal profile.
% nemo_help                      - Overview of NEMO routines.
% nemo_import_xyz_bokasurvey     - Imports xyz data from BOKA surveys.
% nemo_import_xyz_construction   - Imports xyz data from construction surveys.
% nemo_initize_jarkus            - Returns indices and values of NeMo/ZM transects for which jarkus data exists.
% nemo_interp_jarkus             - Interpolates Jarkus transects to surveygrid (5m spacing instead of 10m).
% nemo_jarkus                    - Retreives Jarkus data for Jarkus-area from Jarkus NetCDF.
% nemo_jarkus2shoregrid          - Maps Jarkus transects to Shore surveygrid.
% nemo_jarkus_interp_cs          - Interpolates Jarkus data in cross-shore direction to 5m.
% nemo_load_nourishments         - Loads data of nourishments along the Delfland coast.
% nemo_load_zmwave               - Load wavedata from the ZM wave buoy
% nemo_mb2trans                  - reads MB path and interpolates to transects.
% nemo_movie_bathy               - Creates a movie from prepared frames of the bathymetry
% nemo_movie_var                 - NEMO_MOVIE makes a movie based on prepared frames, based on D.time.
% nemo_northarrow                - plots a 'North arrow' on a map.
% nemo_planbound                 - Sets limits to axes for the NeMo or SE area.
% nemo_plot_3dvolumes            - plots a 3d timestack of volume changes.
% nemo_plot_aligned_transect     - plots all surveys at transect aligned at arbitrary altitude.
% nemo_plot_altitude             - plots topographical maps of all surveys.
% nemo_plot_balanceareas         - plots difference map with volume changes per area.
% nemo_plot_bathy_bedlch_year    - Plots maps of bathymetry and bedlevel change in two columns.
% nemo_plot_bathymetry           - Plots Jarkus and Shore-based bathymetry per survey.
% nemo_plot_bathymetry_stack     - Plots figure with grid of bathymetries.
% nemo_plot_bathysedero          - Simple script to visualise Sed/Erosion between surveys.
% nemo_plot_beddiff              - Plots net bedlevel change, cumulative eroision and acrretion and ratio
% nemo_plot_bedlactivity         - Plots the scaled variance of bedlevel change.
% nemo_plot_bedlch               - Plots the bedlevel change between surveys
% nemo_plot_contours             - Plot contour lines for subsequent surveys.
% nemo_plot_corr                 - Plots correlations between volume changes and hydrodynamics
% nemo_plot_corr2                - Plots correlations between volume changes and hydrodynamics
% nemo_plot_correlation          - plots the R^2 versus one dimension of D.
% nemo_plot_cpdv                 - Plots the volume changes of alongshore balance areas as function of wave energy.
% nemo_plot_csdata               - Plots a stack of the minimum and maximum CS-position with data.
% nemo_plot_depthcontour         - Plots the outer position of a certain depth on a shore-normal, transect based grid.
% nemo_plot_doc                  - Plots depth of closure.
% nemo_plot_figures_for_paper    - Plots and prints all figures for in the paper.
% nemo_plot_gaussfit             - Plots Gaussian fit to depth contour
% nemo_plot_hillshade            - Plots 'hilshade' of the bathymetry based on given coordinates
% nemo_plot_jarkbathymetry       - Plots Jarkus-based bathymetry per survey.
% nemo_plot_lsbalanceareas_waveseries - Plots a figure with volume and wave timeseries.
% nemo_plot_map                  - Plots a map of the survey area and the North Sea (inset).
% nemo_plot_normbedlch           - Plots normalised bedlevel change between surveys
% nemo_plot_northseamap          - Generates a map of the North Sea area with coasts and borders.
% nemo_plot_profile_adjustment   - NEMO_PLOT_PROFILE_ADUSTMENT Plots a figure of three profiles indicative of slope change.
% nemo_plot_profile_std          - Plots profiles with standard deviation.
% nemo_plot_relclpos             - Plots depth contour positions relative to a certain survey
% nemo_plot_relcontour           - pcolor of relative coastline position.
% nemo_plot_slope                - Plots slopes for several surveys and indication on bathymetry.
% nemo_plot_slope_stack          - Plots a timestack of the slope for individual surveys.
% nemo_plot_slopeanddiffmap      - nemo_plot_slopeandmap Plots the CS-slope of a certain survey and a contour map.
% nemo_plot_slopeandmap          - Plots the CS-slope of a certain survey and a contour map.
% nemo_plot_stats                - Plots the desired statistical value of the depth array.
% nemo_plot_std_contour          - Plot standard deviation of Cross-shore contour postion.
% nemo_plot_survey_projection    - Projects a matrix on a 3D surf of surveyed altitude.
% nemo_plot_surveyareas          - Plots an indication of the different survey domains
% nemo_plot_surveydates          - Plots an overview of the different survey dates.
% nemo_plot_timestack            - Plots an arbitrary timestack
% nemo_plot_transect             - Plots a single defined transect for the given surveys.
% nemo_plot_transect_timestack   - Plots a timestack of a single transect(-parameter)
% nemo_plot_verticalvolch        - Plots the normalised volume change on a vertical plane.
% nemo_plot_volume_series_waveenergy - Plots the volume series (net volume changes) in balance areas as funtion of wave energy.
% nemo_plot_volume_stack         - Plots a timestack of volume changes per transect of the whole survey area.
% nemo_plot_volume_timeseries    - Plots timeseries of the volumetric development of a transect.
% nemo_plot_volume_timeseries_lsbalanceareas - Plots volumes per budget area.
% nemo_plot_wave_rose            - Plots a wave rose for all time intervals
% nemo_plot_wavepower_series     - Calculates and plots wavepower from wave timeseries.
% nemo_print2paper               - Prints figures in multiple formats for in my research paper
% nemo_print2thesis              - Prints figures in pre-defined format to fit nicely in my MSc-thesis :)
% nemo_profile_retreat           - Calculates the horizontal displacement of depth contours.
% nemo_raw2transects             - Script to convert the .mat files of the Shore surveys into a NetCDF file
% nemo_raw_build_slope           - Calculates the average bed slope between two bed levels for raw data;
% nemo_raw_plot_transect         - Plots a single defined transect for the given surveys.
% nemo_raw_volumes               - Calculates volume changes of Raw transects.
% nemo_read_adcp                 - NEMO_ADCP_IMPORT Import numeric data from a text file as column vectors.
% nemo_read_crsurvdates          - Reads the .xls file crossref_surveydates,
% nemo_read_pathmultibeam        - Reads raw data of Delfland Multibeam surveys, creates a struct and saves a .mat file.
% nemo_read_surveytxt            - Convert Shore .txt to .mat-file
% nemo_read_txtVlugtenburg       - Read Shore Vlugtenburg-survey txt-files and output a struct.
% nemo_read_txtwalking           - Read Shore Vlugtenburg-survey walking .txt-files and output a struct.
% nemo_read_waterbase_waves      - Reads waterbase txt-files and makes equidistant time vectors.
% nemo_read_wavedata             - Read data from the wave transformation model in zandmotordata.nl
% nemo_read_wavetransform        - Reads the outputfiles of the WaveTransformation tool.
% nemo_read_zmwavebuoy           - Read wave data from the ZM-Wavebuoy.
% nemo_readmultibeam             - Imports raw multibeam data from delfland, 2015.
% nemo_readmultibeam2            - reads raw survey data from delfland multibeam, 2012.
% nemo_regime_indicator          - Determines the extent of erosion along the Sand Engine peninsula.
% nemo_slope_VH                  - Determines the CS-slope from the Horizontal Volume slices struct.
% nemo_slope_new                 - Determines the slope between two altitudes by linear fitting.
% nemo_stats                     - Calculates various statistics of a (t,x,y)-array over t.
% nemo_subset                    - Takes a subset from a Jarkus compliant struct.
% nemo_surveybounds              - Plots the upper and lower limits of the surveyed area.
% nemo_surveypath2netcdf         - writes survey-path xyz-data to a netCDF file.
% nemo_tidevalues                - Interpolates mean tidal values between HVH and SCH.
% nemo_tracker                   - Tracks different marco features of the Sand Engine
% nemo_update_matroos_timeseries - UPDATE MATROOS WAVE CONDITIONS!
% nemo_vb_txt2mat                - Reads raw data from Vlugtenburg and exports a .mat-file.
% nemo_volumes                   - Calculates volume changes of transects.
% nemo_volumes_fast              - NEMO_VOLUMES Calculates only net volume changes of transects.
% nemo_volumes_fast_h            - NEMO_VOLUMES_H Calculates volume changes of transects in horizontal slices.
% nemo_volumes_h_all             - Calculates volume changes of transects in horizontal slices.
% nemo_volumes_jarkus            - NEMO_VOLUMES Calculates volume changes of transects.
% nemo_voronoi                   - Determines and plots the Voronoi diagram of a survey
% nemo_wave_climate              - determines averaged wave parameters between surveys.
% nemo_xcorr_profile             - Cross correlates profiles at different timesteps.
% nemo_xyz_construction2transects - Attempt to construct a DEM from early surveys.
% nemo_zm_retreat                - Shows and calculates the cross shore extent of a transect at a certain height.
% 
% %% General scripts
% zmcmap                         - Sets the colormap to the Shore Zandmotor-colormap with m values, 128 is default.
% rotatecoordinates              - Rotates (x,y) coordinates around an angle theta w.r.t N.
% plot_map2                      - Plot a North Sea Map
% Waves2Nearshore                - Translates offshore wave heights and angles to nearshore values
