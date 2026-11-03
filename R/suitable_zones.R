# Make function for finding suitable zones in EEZ along the Wes Coast

# To use this function you need to input the minimum and maximum sea surface temperature
# as well as the minimum and maximum depth that these specific species
# need in order to be viable in aquaculture along the west coast Exclusive Economic Zones.

suitable_zones <- function(
  min_sst,
  max_sst,
  min_depth,
  max_depth,
  SpeciesName
) {
  # Process data so layers can be combined

  # find mean SST from 2008-2012 and convert from K to C°
  avg_sst_C <- mean(sst_stack, na.rm = TRUE) - 273.15

  # Resample the depth data to match resolution of SST
  depth_resample <- resample(depth, avg_sst_C, method = "bilinear")

  # Checking and converting depth to match SST resolution
  if (all(res(avg_sst_C) == res(depth_resample))) {
    print("The resolutions match")
  } else {
    warning("Update resolutions to match")
    res(depth_resample) <- res(avg_sst_C)
  }
  # Checking and converting depth to match SST extent
  if (ext(avg_sst_C) == ext(depth_resample)) {
    print("The extents match")
  } else {
    warning("Update extents to match")
    ext(depth_resample) <- ext(avg_sst_C)
  }

  # Checking and converting depth to match SST CRS
  if (crs(depth_resample) == crs(avg_sst_C)) {
    print("The CRSs match")
  } else {
    warning("Update CRSs to match")
    crs(depth_resample) <- crs(avg_sst_C)
  }

  # Reclassify SST by making matrix
  rcl_sst <- matrix(
    c(
      -Inf,
      min_sst,
      0,
      min_sst,
      max_sst,
      1,
      max_sst,
      Inf,
      0
    ),
    ncol = 3,
    byrow = TRUE
  )

  # Apply it to raster layer
  sst_zones <- classify(avg_sst_C, rcl = rcl_sst)

  # Reclassify depth by making matrix
  rcl_depth <- matrix(
    c(
      -Inf,
      max_depth,
      0,
      max_depth,
      min_depth,
      1,
      0,
      Inf,
      0
    ),
    ncol = 3,
    byrow = TRUE
  )

  # Apply it to raster layer
  depth_zones <- classify(depth_resample, rcl = rcl_depth)

  # Find areas that satisfy both SST and depth
  species_zone <- c(depth_zones, sst_zones)

  suitable_zones <- lapp(species_zone, fun = function(sst, depth) sst * depth)

  # Convert sf object to terra vector for rasterizing
  EEZ_vector <- terra::vect(EEZ)

  # Rastertize EEZ
  EEZ_raster <- rasterize(EEZ_vector, suitable_zones, field = 'rgn_id')

  # Calculating area of each cell
  cell_area <- cellSize(suitable_zones, unit = "km", mask = TRUE)

  # Only the cells assigned to 1
  suitable_area <- mask(cell_area, suitable_zones, maskvalues = 0)

  # Select raster cells that fall in EEZ regions
  suitable_area_eez <- zonal(
    suitable_area,
    EEZ_raster,
    fun = 'sum',
    na.rm = TRUE
  )

  # Convert into DataFrame
  suitability_df <- as_tibble(suitable_area_eez) |>
    rename(suitable_area_km2 = area) # rename column name

  # Join suitable areas to EEZ polygons
  EEZ_map <- left_join(EEZ, suitability_df, by = "rgn_id")

  # Make a map of West Coast EEZ's
  tm_shape(EEZ_map) +

    # Add a basemap
    tm_basemap("OpenStreetMap") +

    # Customize legend
    tm_fill(
      fill_alpha = 0.75,
      fill = "suitable_area_km2",
      fill.legend = tm_legend(
        "Suitable Area (km²)",
        position = tm_pos_out("right", "center")
      )
    ) +

    # Customize border of polygons
    tm_borders(
      lwd = 0.5
    ) +

    # Add a scalebar
    tm_scalebar(
      position = c("left", "bottom")
    ) +

    # Add a compass
    tm_compass(
      position = c("right", "top")
    ) +

    # Add a title
    tm_title(
      paste("Suitable", SpeciesName, "by EEZ\nAlong The West Coast"),
      fontface = "bold"
    )
}
