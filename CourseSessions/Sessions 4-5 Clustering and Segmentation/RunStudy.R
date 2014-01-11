
# Project Name: "Sessions 4-5 of INSEAD Big Data Analytics for Business Course: "Clustering and Segmentation"


rm( list = ls( ) ) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# Please ENTER the name of the file with the data used. The file should contain a matrix with one row per observation (e.g. person) and one column per attribute. THE NAME OF THIS MATRIX NEEDS TO BE ProjectData (otherwise you will need to replace the name of the ProjectData variable below with whatever your variable name is, which you can see in your Workspace window after you load your file)
datafile_name="DefaultData"

# Please ENTER a name that describes the data for this project
data_name="Mall Visits"

load(paste("data",datafile_name,sep="/")) # this contains only the matrix ProjectData

# Please ENTER the number of clusters to eventually use for this report
numb_clusters_used = 2

# Please ENTER the distance metric eventually used for the clustering in case of hierarchical clustering (e.g. "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski" - see help(dist)). Defauls is "euclidean"
distance_used="euclidean"

# Please ENTER then original raw attributes to use for the segmentation (the "segmentation attributes")
segmentation_attributes_used=1:ncol(ProjectData)

# Please ENTER then original raw attributes to use for the profiling of the segments (the "profiling attributes")
profile_attributes_used=1:ncol(ProjectData)

# Please enter the minimum number below which you would like not to print - this makes the readability of the tables easier. Default values are either 10e6 (to print everything) or 0.5. Try both to see the difference.
MIN_VALUE=0.5

# Would you like to also start a web application once the report and slides are generated?
# 1: start application, 0: do not start it. 
# Note: starting the web application will open a new browser 
# with the application running
start_webapp <- 1

######################################################################

ProjectData_segment=ProjectData[,segmentation_attributes_used]
ProjectData_profile=ProjectData[,profile_attributes_used]
source("R/library.R")

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

if (start_webapp)
  runApp("tools")
