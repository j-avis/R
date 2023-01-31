#' get a plottable RGB array from a RGB raster
#'
#' @param x A raster object.
#' @return an array object.
#' @export

get_rgb_array <-function(ras) {

  names(ras) = c("r","g", "b")

  ras_r = rayshader::raster_to_matrix(ras$r)
  ras_g = rayshader::raster_to_matrix(ras$g)
  ras_b = rayshader::raster_to_matrix(ras$b)

  ras_rgb_array = array(0, dim=c(nrow(ras_r), ncol(ras_r), 3))

  ras_rgb_array[,,1] = ras_r/255 #Red layer
  ras_rgb_array[,,2] = ras_g/255 #Blue layer
  ras_rgb_array[,,3] = ras_b/255 #Green layer

  tarray = aperm(ras_rgb_array, c(2,1,3))
  tarray
}
