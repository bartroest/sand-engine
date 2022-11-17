# sand-engine

Scripts to analyse Sand Engine morphology and the wider Delfland coastal cell.

This toolbox consists of scripts and initial data to perform data analysis on the topo-bathymetrical surveys in the Delfland coastal cell. These surveys consist of three datasets:
1: Jarkus, annual coastal surveys 1965-present of the Dutch coast.
2: Zandmotor, (bi-)monthly 2011-2016 and 6-monthly surveys 2017-present of the Sand Engine peninsula and its surroundings.
3: Nemo, bi-monthly surveys 2012-2016 of the Delfland coast North and South of the Sand Engine.

With this toolbox you can create DEM's of the Delfland coast from scratch, using:
1: scripts (this toolbox)
2: initial data (this toolbox)
3a: access to the raw survey data at the Sand Engine SVN repository at https://zandmotordata.nl/
3b: alternatively download combined_data_delfland_surveypath.nc from  https://opendap.4tu.nl/thredds/catalog/data2/uuid/d469c50b-edb6-4aa7-811d-f19b389ed344/catalog.html to obtain xyz point clouds.

Further many post-processing and plotting scripts are included. Ideally, when running the "nemo.m" all post-processing will be performed and most figures will be generated. Post-processing can be performed also from the existing dataset at https://opendap.4tu.nl/thredds/catalog/data2/uuid/d469c50b-edb6-4aa7-811d-f19b389ed344/catalog.html 


This toolbox is used to compile the following datasets:
Roest, Bart. 2017, Combined morphology surveys Delfland 2011-2016, https://doi.org/10.4121/uuid:d469c50b-edb6-4aa7-811d-f19b389ed344 (An updated version can be requested from the author, or made with this toolbox).

This toolbox is used in the following research publications:
Roest, Bart. 2017, The influence of the Sand Engine on the sediment transports and budgets of the Delfland coast: Analysis of bi-monthly high-resolution coastal profiles. Master thesis. http://resolver.tudelft.nl/uuid:5596663f-1668-4de6-b47e-425d7cb8d82e
Roest B, de Vries S, de Schipper M, Aarninkhof S. Observed Changes of a Mega Feeder Nourishment in a Coastal Cell: Five Years of Sand Engine Morphodynamics. Journal of Marine Science and Engineering. 2021; 9(1):37. https://doi.org/10.3390/jmse9010037

Please refer to the aformentioned paper and dataset when using these data in your research.

This toolbox requires several matlab scripts from Deltares' OpenEarthTools to work. https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/