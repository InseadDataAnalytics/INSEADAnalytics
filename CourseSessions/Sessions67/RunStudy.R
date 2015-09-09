
# Project Name: "Sessions 6-7 of INSEAD Data Analytics for Business Course: "Classification"


rm(list = ls( )) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# When running the case on a local computer, modify this in case you saved the case in a different directory 
# (e.g. local_directory <- "C:/user/MyDocuments" )
# type in the Console below help(getwd) and help(setwd) for more information
local_directory <- paste(getwd(),"CourseSessions/Sessions67", sep="/")
#local_directory <- "~INSEADAnalytics/CourseSessions/Sessions67"

cat("\n *********\n WORKING DIRECTORY IS ", local_directory, "\n PLEASE CHANGE IT IF IT IS NOT CORRECT using setwd(..) - type help(setwd) for more information \n *********")

# Please ENTER the name of the file with the data used. The file should contain a matrix with one row per observation (e.g. person) and one column per attribute. THE NAME OF THIS MATRIX NEEDS TO BE ProjectData (otherwise you will need to replace the name of the ProjectData variable below with whatever your variable name is, which you can see in your Workspace window after you load your file)
datafile_name="Boats" # do not add .csv at the end! make sure the data are numeric!!!! check your file!

# Please ENTER the filename that indicates subsets of the data to use (e.g. only a specific cluster)
# This file need to have 2 columns with the second one indicating the cluster ID of the observation. 
# The rows of this files are aligned with those of the datafile_name one
# This is used ONLY for the report "MyBoatsDrivers"
cluster_file_ini = "Boats_cluster" # make sure this file exists in the "data" directory

# Please ENTER the name Report and Slides (in the doc directory) to generate 
report_file = "Report_s67"
#report_file = "SampleBoatsDriversSegments"
#report_file = "MyBoatsDrivers"
slides_file = "Slides_s67"

# Please ENTER the class (dependent) variable:
# Please use numbers, not column names! e.g. 82 uses the 82nd column are dependent variable.
# YOU NEED TO MAKE SURE THAT THE DEPENDENT VARIABLES TAKES ONLY 2 VALUES: 0 and 1!!!
dependent_variable= 82

# Please ENTER the attributes to use as independent variables 
# Please use numbers, not column names! e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
independent_variables= c(54:80) # use 54-80 for boats

# Please ENTER the profit/cost values for the correctly and wrong classified data:
actual_1_predict_1 = 100
actual_1_predict_0 = -75
actual_0_predict_1 = -50
actual_0_predict_0 = 0

# Please ENTER the probability threshold above which an observations  
# is predicted as class 1:
Probability_Threshold=50 # between 1 and 99%

# Please ENTER the percentage of data used for estimation
estimation_data_percent = 80
validation_data_percent = 10

# Please enter 0 if you want to "randomly" split the data in estimation and validation/test
random_sampling = 0

# Tree parameter
# PLEASE ENTER THE Tree (CART) complexity control cp (e.g. 0.001 to 0.02, depending on the data)
CART_cp = 0.01

# Please enter the minimum size of a segment for the analysis to be done only for that segment
min_segment = 100

# Please enter the maximum number of observations to show in the report and slides 
# (DEFAULT is 50. If the number is large the report and slides may not be generated - very slow or will crash!!)
max_data_report = 50 # can also chance in server.R

###########################
# Would you like to also start a web application on YOUR LOCAL COMPUTER once the report and slides are generated?
# Select start_webapp <- 1 ONLY if you run the case on your local computer
# NOTE: Running the web application on your LOCAL computer will open a new browser tab
# Otherwise, when running on a server the application will be automatically available
# through the ShinyApps directory

# 1: start application on LOCAL computer, 0: do not start it
# SELECT 0 if you are running the application on a server 
# (DEFAULT is 0). 
start_local_webapp <- 0
# NOTE: You need to make sure the shiny library is installing (see below)

################################################
# Now run everything

Probability_Threshold = Probability_Threshold/100 # make it between 0 and 1
ProjectData <- read.csv(paste(paste(local_directory, "data", sep="/"), paste(datafile_name,"csv", sep="."), sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
ProjectData=data.matrix(ProjectData)

if (datafile_name == "Boats")
  colnames(ProjectData)<-gsub("\\."," ",colnames(ProjectData))

dependent_variable = unique(sapply(dependent_variable,function(i) min(ncol(ProjectData), max(i,1))))
independent_variables = unique(sapply(independent_variables,function(i) min(ncol(ProjectData), max(i,1))))

if (length(unique(ProjectData[,dependent_variable])) !=2){
  cat("\n*****\n BE CAREFUL, THE DEPENDENT VARIABLE TAKES MORE THAN 2 VALUES...")
  cat("\nSplitting it around its median...\n*****\n ")
  new_dependent = ProjectData[,dependent_variable] >= median(ProjectData[,dependent_variable])
  ProjectData[,dependent_variable] <- 1*new_dependent
}

Profit_Matrix = matrix(c(actual_1_predict_1, actual_0_predict_1, actual_1_predict_0, actual_0_predict_0), ncol=2)
colnames(Profit_Matrix)<- c("Predict 1", "Predict 0")
rownames(Profit_Matrix) <- c("Actual 1", "Actual 0")
test_data_percent = 100-estimation_data_percent-validation_data_percent
source(paste(local_directory,"R/library.R", sep="/"))

### TO EDIT DEPENDING ON VERSION
if (require(shiny) == FALSE) 
  install.packages("shiny")

CART_control = rpart.control(cp = CART_cp)
source(paste(local_directory,"R/heatmapOutput.R", sep = "/"))
source(paste(local_directory,"R/runcode.R", sep = "/"))

if (start_local_webapp){
      
  # now run the app
  runApp(paste(local_directory,"tools", sep="/"))  
}

