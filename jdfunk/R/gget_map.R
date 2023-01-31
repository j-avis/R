#' get cropped ggmap with extent of another object
#'
#' @param x A sf or raster object.
#' @return a gg map object.
#' @export
gget_map <- function(obj, mt="satellite") {
  options <- c("terrain", "terrain-background", "satellite", "roadmap", "hybrid", "toner",
               "watercolor", "terrain-labels", "terrain-lines", "toner-2010", "toner-2011",
               "toner-background", "toner-hybrid", "toner-labels", "toner-lines", "toner-lite")
  if(! mt %in% options){
    stop("map tupe must be one of the following" + options)
  }


  if(inherits(obj, "sf")){
    bb <- st_bbox(st_transform(obj, crs=4326))
    names(bb) = c("left", "bottom", "right", "top")
  }
  if(inherits(obj, c("RasterLayer", "RasterBrick", "RasterStack"))){
    bb <- raster::extent(raster::projectRaster(obj, crs = 4326, method = "bilinear"))
    bb <-c("left"=attr(bb, "xmin"), "bottom"=attr(bb, "ymin"), "right"=attr(bb, "xmax"), "top"=attr(bb, "ymax"))
  }

  #To avoid potential errors, make it big, then crop it back
  bbb<-c(bb['left']*1.00002, bb['top']*1.00002, bb['bottom']*0.99998, bb['right']*0.99998)
  gg<-get_map(location=bbb, maptype=mt)
  gg
}
