#library(rgdal)
library(raster)
library(readxl)
library("tidyverse")
library(ggplot2)
library(sf)
library(rayshader)
library(ggmap)
register_google(key="AIzaSyC4C6WTIQmIiSQErXBDqQFWv4-nhzKHbzQ")

#' returns cropped lidar or SRTM elevation data, needs upgraded to work on disk for lidar.
#'Use info in https://stat.ethz.ch/pipermail/r-sig-geo/2020-November/028497.html and GDALinfo() to make version that crops on disk
#'Until then, just having it in a function will reduce memory use
#' @param x A raster or sf object.
#' @return raster object.
#' @export
get_elev <- function(wells, model="dsm" ){
  
  # N46W120_raster <- raster::raster("~/RStudio Projects/hm/N46W120.hgt")
  # N46W120_wells <- crop(N46W120_raster, extent(projectExtent(wells, crs(N46W120_raster))))

  cp <- raster("./hanford_central_plateau_2008_dsm_0_1_3_4_5.tif")
  
  cp_wells <- crop(cp, st_transform(wells, crs=crs(cp)) )
  cp_wells
}


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

#' get cropped raster with extent of another raster 
#'
#' @param x A raster object.
#' @return a raster object.
#' @export

ez_crop <- function(e, z) {
  
  if(inherits(e, "sf")){
   return(crop(e, st_transform(z, crs(e))))
  }
  
  e <- raster::projectRaster(e, crs=crs(z))
  print(extent(e))
  print(extent(z))
  e <- terra::crop(e, extent(z))
  e
}

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



#' Load well data
#'
#' @varriable hv = FILENAME for HEIS horizontal and vertical data for wells in an area

hv <- "~/RStudio Projects/hm/uplant/Well Horizontal and Vertical Survey1-18-2023version-3.3.xlsx"

Well_Horizontal_and_Vertical_Survey <- read_excel(hv) %>%
dplyr::select("WELL_NAME", "WELL_ID", "EASTING", "NORTHING", "HORIZ_SURVEY_UNITS", "HORIZ_DATUM", "HORIZ_SURVEY_DATE", "ELEVATION", "ELEV_SURVEY_UNITS", "ELEV_DATUM", "ELEV_SURVEY_DATE")

#'
#' @varriable wld = FILENAME HEIS water level detail data for wells in an area
#' 
hv <- "~/RStudio Projects/hm/uplant/Water Level Detail for Selections1-18-2023version-3.3.xlsx"
Water_Level_Detail_for_Selections <- read_excel(hv,
  col_types = c("text", "text", "date", "numeric", "numeric", "numeric", "text",
    "text", "text", "numeric", "numeric", "numeric", "text", "text", 
    "numeric", "text", "numeric", "text", "text", "text", "text", 
    "text", "numeric","numeric", "numeric", "text", "numeric", 
    "text", "text", "date", "numeric", "numeric"))

#hanford uses a particular flavor of UTM (Washington South NAD83?) with EPSG code 32149
hanford_EPSG <- 32149
well_locations <- st_as_sf(Well_Horizontal_and_Vertical_Survey, coords = c("EASTING","NORTHING"), remove = FALSE, crs=32149) 


##get elevation map
elevation <- get_elev(well_locations)

e_matrix <- raster_to_matrix(elevation)

e_matrix %>%
  sphere_shade(texture = "desert") %>%
  #add_water(detect_water(e_matrix, zscale = 4))  %>%
  add_shadow(ray_shade(e_matrix, zscale = 4, multicore = TRUE, 
                       sunaltitude = 10, sunangle = 45),0.3) %>%
  plot_3d(e_matrix, zscale = 4, water = TRUE,
          zoom=0.85, windowsize = 1000, 
          background = "grey50", shadowcolor = "grey20")

well_coord <- well_locations %>%
  st_transform( crs(elevation)) %>%
  st_coordinates()

lat=unlist(well_coord[,2])
long=unlist(well_coord[,1])

render_points(lat=lat, long=long, extent=extent(elevation), heightmap = e_matrix,
              zscale=4, color="red", size=5)

render_camera(theta = 0, phi=33, zoom=0.4, fov=55)

# 
# plot(base_map_raster)
# extent(base_map)
# extent(well_locations)
# 
# plot(base_map_raster)
# plot(elevation)
# ggmap(base_map)
# base_map_raster_crop <- raster::crop(base_map_raster, well_locations )
# 

#load maps and make rasters  running get_map twice helps
base_map <- gget_map(elevation, "hybrid")

base_map_raster <- ggmap_to_raster(base_map) %>%
  projectRaster(crs=terra::crs("epsg:32149"))

cropped_raster<- ez_crop(base_map_raster, elevation)

rgb_array <- get_rgb_array(cropped_raster)

dim(rgb_array)
dim(e_matrix)

rgb_contrast = scales::rescale(rgb_array, to=c(0,1))

rgb_contrast %>%
  plot_3d(e_matrix, windowsize = c(1100,900), zscale = 4, shadowdepth = -50,
           zoom=0.5, phi=45,theta=-45,fov=70, background = "#F2E1D0", shadowcolor = "#523E2B")
