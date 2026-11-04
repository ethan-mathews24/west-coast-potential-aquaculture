# Prioritizing Potential Aquaculture Areas Along the West Coast


![](images/aqua.jpg)

<p align="center">
<a href="https://unsplash.com/photos/white-and-silver-round-coins-on-blue-surface-udVjzhI9gXs">Aquaculture</a>
</p>



### Purpose of this Repository

Marine aquaculture could be a more sustainable protein source than land-based meat production (Gentry et al., 2017). This repository uses raster and vector analysis in R to find suitable growing areas for oysters and a second species within West Coast EEZs. Suitability is based on average sea surface temperature (2008–2012) and ocean depth. The workflow is wrapped in a reusable function, so it can be applied to any species with known temperature and depth ranges.



### Package Dependencies 

* `tidyverse`

* `fs`

* `tmap`

* `terra`

* `sf`



### File Structure 

```
EDS223-HWK3
├── data
│   ├── average_annual_sst_2008.tif
│   ├── average_annual_sst_2009.tif
│   ├── average_annual_sst_2010.tif
│   ├── average_annual_sst_2011.tif
│   ├── average_annual_sst_2012.tif
│   ├── depth.tif
│   ├── wc_regions_clean.shp
├── images
├── potential_aquaculture.pdf
├── potential_aquaculture.qmd
└── README.md
```



### Repository Contents 

The `data` folder contains the data used for this analysis.

The `images` folder contains images that were used for the README an results sections.



### Results

IMAGES GO HERE



### Data Information/Access

#### Sea Surface Temperature

For this analysis, we used average annual sea surface temperature (SST) from the years 2008 to 2012 to characterize the average sea surface temperature within the region. The data we worked with was originally generated from [NOAA’s 5km Daily Global Satellite Sea Surface Temperature Anomaly v3.1.](https://coralreefwatch.noaa.gov/product/5km/index_5km_ssta.php)

Data files used from this analysis:

* `average_annual_sst_2008.tif`
* `average_annual_sst_2009.tif`
* `average_annual_sst_2010.tif`
* `average_annual_sst_2011.tif`
* `average_annual_sst_2012.tif`


#### Bathymetry

To characterize the depth of the ocean we will use the [General Bathymetric Chart of the Oceans (GEBCO).3.](https://www.gebco.net/data-products/gridded-bathymetry-data#area)

Data file used for this analysis:

* `depth.tif`

#### Exclusive Economic Zones (EEZ)

We will be designating maritime boundaries using Exclusive Economic Zones off of the west coast of US from [Marineregions.org.](https://www.marineregions.org/eez.php)

Data file used for this analysis: 

* `wc_regions_clean.shp`



### Authors and Contributors 

Author: [Ethan Mathews](https://github.com/ethan-mathews24)

Contributor: [Annie Adams](https://github.com/annieradams)



### Citations


Gentry, R., Froehlich, H., Grimm, D., Kareiva, P., Parke, M., Rust, M., Gaines, S., & Halpern, B. (2017). Mapping the global potential for marine aquaculture. *Nature Ecology & Evolution*, 1, 1317-1324, https://www.nature.com/articles/s41559-017-0257-9. 