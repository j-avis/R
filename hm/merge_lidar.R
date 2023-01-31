 cp1 <- raster::raster("~/RStudio Projects/hm/datasetsA/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_4.tif")
 cp2 <- raster::raster("~/RStudio Projects/hm/datasetsA/rattlesnake_2011/dtmhs/rattlesnake_2011_dtm_11_hs.tif")
 cp3 <- raster::raster("~/RStudio Projects/hm/datasetsB/columbia_valley_fema_south_2020/dtmhs/columbia_valley_fema_south_2020_dtm_441_hs.tif")
 cp1on3 = projectRaster(cp1, cp3)
 cp2on3 = projectRaster(cp2, cp3)
 cp <- raster::merge(cp2on3, cp3, cp1on3, overlap = TRUE )

 writeRaster(cp, "./hanford_central_plateau_2008_dtm_4_and_rattlesnake_2011_dtm_11_hs.tif.tif", format="GTiff", overwrite=FALSE)
 

fema436m <- raster::raster("~/RStudio Projects/hm/datasetsB/columbia_valley_fema_south_2020/dsmhs/columbia_valley_fema_south_2020_dsm_436_hs.tif")
rs11m <- raster::raster("~/RStudio Projects/hm/datasetsA/rattlesnake_2011/dsm/rattlesnake_2011_dsm_11.tif")

cp0 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_0.tif")
cp1 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_1.tif")
#cp2 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_2.tif")
cp3 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_3.tif")
cp4 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_4.tif")
cp5 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_5.tif")

#cp0on5 = projectRaster(cp0, cp5)
#cp1on5 = projectRaster(cp1, cp5)
#cp2on5 = projectRaster(cp2, cp5)
#cp3on5 = projectRaster(cp3, cp5)
#cp4on5 = projectRaster(cp4, cp5)


cp <- raster::merge(cp0, cp1, cp3, cp4, cp5, overlap = TRUE )
writeRaster(cp, "./hanford_central_plateau_2008_dsm_0_1_3_4_5.tif", format="GTiff", overwrite=FALSE)
plot(cp)

#writeRaster(cp, "./hanford_central_plateau_2008_dsm_4_and_columbia_valley_fema_south_2020_dsm_436_hs.tif", format="GTiff", overwrite=FALSE)
writeRaster(cp, "./hanford_central_plateau_2008_dsm_0_1_3_4_5_and_columbia_valley_fema_south_2020_dsm_436_hs.tif", format="GTiff", overwrite=FALSE)

cp0 <- raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_0.tif")
cp1 <- raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_1.tif")
#cp2 <- raster::raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dsm/hanford_central_plateau_2008_dsm_2.tif")
cp3 <- raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_3.tif")
cp4 <- raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_4.tif")
cp5 <- raster("~/RStudio Projects/hm/hanford_central_plateau_2008/dtm/hanford_central_plateau_2008_dtm_5.tif")
cp <- merge(cp0, cp1, cp3, cp4, cp5, overlap = TRUE )
writeRaster(cp, "./hanford_central_plateau_2008_dtm_0_1_3_4_5.tif", format="GTiff", overwrite=FALSE)
plot(cp)
