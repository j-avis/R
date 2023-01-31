#' returns cropped lidar or SRTM elevation data, needs upgraded to work on disk for lidar.
#'Use info in https://stat.ethz.ch/pipermail/r-sig-geo/2020-November/028497.html and GDALinfo() to make version that crops on disk
#'Until then, just having it in a function will reduce memory use
#' @param x A raster or sf object.
#' @return raster object.
#' @export
get_elev <- function(wells, model="dsm" ){

  if(inherits(wells, "sf")){
    ext <- function(cp) st_transform(wells, crs=crs(cp))
    }
  if(inherits(wells, c("RasterLayer", "RasterBrick", "RasterStack"))){
    ext <- function(cp) extent(projectExtent(wells, crs(cp)))
  }

  if(model=="dsm") {
    cp <- raster("./hanford_central_plateau_2008_dsm_0_1_3_4_5.tif")
    cp_wells <- crop(cp, ext(cp) )
  }
  if( model == "dtm"){
    cp <- raster("./hanford_central_plateau_2008_dtm_0_1_3_4_5.tif")
    cp_wells <- crop(cp, ext(cp) )

  }

  if(model=="srtm") {
    cp <- raster("~/RStudio Projects/hm/N46W120.hgt")
    cp_wells <- crop(cp, ext)
  }

  cp_wells
}
