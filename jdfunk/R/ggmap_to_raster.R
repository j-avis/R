#' Convert ggmap to raster
#'
#' @param x A ggmap object.
#' @return raster object.
#' @export
ggmap_to_raster <- function(x){
  if(!inherits(x, "ggmap")) stop(print("x must be a ggmap object (e.g. from ps_bbox_ggmap)"))

  map_bbox <- attr(x, 'bb')
  .extent <- raster::extent(as.numeric(map_bbox[c(2,4,1,3)]))
  my_map <- raster::raster(.extent, nrow= nrow(x), ncol = ncol(x))
  rgb_cols <- setNames(as.data.frame(t(col2rgb(x))), c('red','green','blue'))
  red <- my_map
  raster::values(red) <- rgb_cols[['red']]
  green <- my_map
  raster::values(green) <- rgb_cols[['green']]
  blue <- my_map
  raster::values(blue) <- rgb_cols[['blue']]
  ras <- raster::stack(red,green,blue)
  crs(ras) <- 4326#3857
  ras
}
