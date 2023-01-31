library("devtools")
library("roxygen2")
dir("./")
setwd("..")
document()
install("jdfunk")

library(jdfunk)

get_elev
