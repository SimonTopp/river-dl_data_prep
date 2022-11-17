# River-DL Data Prep Pipeline

This repository contains code for pulling and formatting driver data for stream temperature and discharge models for the Delaware River Basin. Data is pulled from [Oliver et al. (2021; 10.5066/P9GD8I7A)](https://www.sciencebase.gov/catalog/folder/5f6a26af82ce38aaa2449100) and formats it for use in the USGS [River-DL](https://github.com/USGS-R/river-dl) process guided deep learning repository. Specifically, this repository pulls:

-   Stream temperature and discharge information from USGS gagues

-   A distance matrix representing the stream network in the Delaware River Basin

-   Predictions from the application of a process based model (PRMS-SNTemp) for the basin

-   Driver data for the models include meteorological forcings and reach characteristics

### Using this repostiory

This repository uses a `Snakemake` workflow to access the items on Sciencebase and reformat them for River-dl. To run the workflow:

1.   Install the dependencies in `environment.yml`. With conda you can do this with `conda env create -f environment.yaml`
2.  Activate your conda environment `source activate river_dl_data_prep`
3.  Edit the path configurations and any other desired arguments in `config.yml`
4.  Run the Snakemake workflow with `snakemake –configfile config.yml -s Snakemake —cores <n>`

### Disclaimer

This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey, an agency of the United States Department of Interior. For more information, see the official USGS copyright policy

Although this software program has been used by the U.S. Geological Survey (USGS), no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided \"AS IS.\"
