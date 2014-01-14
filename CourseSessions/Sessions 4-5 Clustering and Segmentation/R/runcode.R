

Mall_Visits <- read.csv(paste("data", "Mall Visits.csv", sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
Boats <- read.csv(paste("data", "Boats.csv", sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
Boats=data.matrix(Boats)
ProjectData <- read.csv(paste("data", "Mall Visits.csv", sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData

ProjectData_segment=ProjectData[,segmentation_attributes_used]
ProjectData_profile=ProjectData[,profile_attributes_used]

source("R/heatmapOutput.R")


unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( "../doc/Slides_s45.Rmd","Slides_s45.Rmd", overwrite = T )
file.copy( "../doc/All3.png","All3.png", overwrite = T )
slidify( "Slides_s45.Rmd" )
file.copy( 'Slides_s45.html', "../doc/Slides_s45.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      

unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( "../doc/Report_s45.Rmd","Report_s45.Rmd", overwrite = T )
file.copy( "../doc/All3.png","All3.png", overwrite = T )
knit2html( 'Report_s45.Rmd', quiet = TRUE )
file.copy( 'Report_s45.html', "../doc/Report_s45.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      
