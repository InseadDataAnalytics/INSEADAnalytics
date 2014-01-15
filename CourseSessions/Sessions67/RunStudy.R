
# Project Name: "Sessions 6-7 of INSEAD Big Data Analytics for Business Course: "Classification"


rm( list = ls( ) ) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# Please ENTER the name of the file with the data used. The file should contain a matrix with one row per observation (e.g. person) and one column per attribute. THE NAME OF THIS MATRIX NEEDS TO BE ProjectData (otherwise you will need to replace the name of the ProjectData variable below with whatever your variable name is, which you can see in your Workspace window after you load your file)
datafile_name="DefaultData"

# Please ENTER a name that describes the data for this project
data_name="Resort Customers"

load(paste("data",datafile_name,sep="/")) # this contains only the matrix ProjectData

# Please ENTER the name of the class variable:
dependent_variable="Visit"

# Please ENTER the attributes to use as independent variables (default is 1:ncol(ProjectData), namely all of them)
attributes_used=1:ncol(ProjectData)

# Please ENTER the percentage of data used for estimation
estimation_data_percent = 80
validation1_data_percent = 20

# Please ENTER the probability threshold above which an observations  
# is predicted as class 1:
Probability_Threshold=50

# Would you like to also start a web application once the report and slides are generated?
# 1: start application, 0: do not start it. 
# Note: starting the web application will open a new browser 
# with the application running
start_webapp <- 1

######################################################################

validation2_data_percent = 100-estimation_data_percent-validation1_data_percent
ProjectData_used = ProjectData[,attributes_used]
Probability_Threshold = Probability_Threshold/100
source("R/library.R")

unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( "../doc/Slides_s67.Rmd","Slides_s67.Rmd", overwrite = T )
slidify( "Slides_s67.Rmd" )
file.copy( 'Slides_s67.html', "../doc/Slides_s67.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      

unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( "../doc/Report_s67.Rmd","Report_s67.Rmd", overwrite = T )
knit2html( 'Report_s67.Rmd', quiet = TRUE )
file.copy( 'Report_s67.html', "../doc/Report_s67.html", overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      

if (start_webapp)
  runApp("tools")
