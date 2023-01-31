#' get cropped raster with extent of another raster
#'
#' @param e A raster object.
#' @param z a raster or sf object with desired extent
#' @return a raster object.
#' @export

ez_crop <- function(e, z) {

  if(inherits(e, "sf")){
    return(crop(e, st_transform(e, crs(z))))
  }

  e <- raster::projectRaster(e, crs=crs(z))
  e <- terra::crop(e, extent(z))
  e
}
