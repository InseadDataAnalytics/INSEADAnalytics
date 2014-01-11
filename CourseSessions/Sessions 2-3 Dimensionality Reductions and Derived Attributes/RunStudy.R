# Project Name: "Sessions 2-3 of INSEAD Big Data Analytics for Business Course: "Dimensionality Reduction and Derived Attributes"

rm( list = ls( ) ) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# Please ENTER the name of the file with the data used. The file should contain a matrix with one row per observation (e.g. person) and one column per attribute. THE NAME OF THIS MATRIX NEEDS TO BE ProjectData (otherwise you will need to replace the name of the ProjectData variable below with whatever your variable name is, which you can see in your Workspace window after you load your file)
datafile_name="DefaultData"

# Please ENTER a name that describes the data for this project
data_name="MBA Applicants"

load(paste("data",datafile_name,sep="/")) # this contains only the matrix ProjectData

# Please ENTER the number of factors to eventually use for this report
numb_factors_used = 2

# Please ENTER the rotation eventually used (e.g. "none", "varimax", "quatimax", "promax", "oblimin", "simplimax", and "cluster" - see help(principal)). Defauls is "varimax"
rotation_used="varimax"

# Please ENTER then original raw attributes to use (default is 1:ncol(ProjectData), namely all of them)
attributes_used=1:ncol(ProjectData)

# Please enter the minimum number below which you would like not to print - this makes the readability of the tables easier. Default values are either 10e6 (to print everything) or 0.5. Try both to see the difference.
MIN_VALUE=0.5

# Would you like to also start a web application once the report and slides are generated?
# 1: start application, 0: do not start it. 
# Note: starting the web application will open a new browser 
# with the application running
start_webapp <- 1

######################################################################

ProjectDataFactor=ProjectData[,attributes_used]
source("R/library.R")


unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( "../doc/Slides_s23.Rmd","Slides_s23.Rmd", overwrite = T )
file.copy( "../doc/All3.png","All3.png", overwrite = T )
slidify( "Slides_s23.Rmd" )
file.copy( 'Slides_s23.html', "../doc/Slides_s23.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      

unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( "../doc/Report_s23.Rmd","Report_s23.Rmd", overwrite = T )
file.copy( "../doc/All3.png","All3.png", overwrite = T )
knit2html( 'Report_s23.Rmd', quiet = TRUE )
file.copy( 'Report_s23.html', "../doc/Report_s23.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      

if (start_webapp)
  runApp("tools")
