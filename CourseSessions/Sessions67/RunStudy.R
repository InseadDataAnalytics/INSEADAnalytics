
# Project Name: "Sessions 6-7 of INSEAD Big Data Analytics for Business Course: "Classification"


rm(list = ls( )) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# When running the case on a local computer, modify this in case you saved the case in a different directory 
# (e.g. local_directory <- "C:/user/MyDocuments" )
# type in the Console below help(getwd) and help(setwd) for more information
local_directory <- "~/INSEADjan2014/CourseSessions/Sessions67"

cat("\n *********\n WORKING DIRECTORY IS ", local_directory, "\n PLEASE CHANGE IT IF IT IS NOT CORRECT using setwd(..) - type help(setwd) for more information \n *********")
datafile_name="Boat_Purchase"

# this loads the selected data: DO NOT EDIT THIS LINE
ProjectData <- read.csv(paste(paste(local_directory, "data", sep="/"), paste(datafile_name,"csv", sep="."), sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
ProjectData=data.matrix(ProjectData) # make sure the data are numeric!!!! check your file!

# Please ENTER a name that describes the data for this project
data_name="Boats Customers"

# Please ENTER the name of the class variable:
dependent_variable="Q18_PurchaseFuture"

# Please ENTER the attributes to use as independent variables (default is 1:ncol(ProjectData), namely all of them)
independent_variables=colnames(ProjectData)[2:15]

# Please ENTER the percentage of data used for estimation
estimation_data_percent = 80
validation_data_percent = 10

# Please enter 0 if you want to "randomly" split the data in estimation and validation/test
random_sampling = 0

# Please ENTER the probability threshold above which an observations  
# is predicted as class 1:
Probability_Threshold=50 # between 1 and 99%
Probability_Threshold = Probability_Threshold/100 # make it between 0 and 1

# Please ENTER the profit/cost values for the correctly and wrong classified data:
actual_1_predict_1 = 100
actual_1_predict_0 = -75
actual_0_predict_1 = -50
actual_0_predict_0 = 0


# CART parameters:
# PLEASE ENTER THE CART complexity control cp (e.g. 0.001 to 0.02, depending on the data)
CART_cp = 0.01

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

Profit_Matrix = matrix(c(actual_1_predict_1, actual_0_predict_1, actual_1_predict_0, actual_0_predict_0), ncol=2)
colnames(Profit_Matrix)<- c("Predict 1", "Predict 0")
rownames(Profit_Matrix) <- c("Actual 1", "Actual 0")
test_data_percent = 100-estimation_data_percent-validation_data_percent
source(paste(local_directory,"R/library.R", sep="/"))
# what to pass to CART.... do not change this line!!!
CART_control = rpart.control(cp = CART_cp)
source(paste(local_directory,"R/heatmapOutput.R", sep = "/"))
source(paste(local_directory,"R/runcode.R", sep = "/"))

if (start_local_webapp){
  
  # MAKE SURE THIS INSTALLS FINE if a local web app is to be use - the local computer needs
  # to have the shiny library to run the shiny apps
  if (require(shiny) == FALSE) 
    install_libraries("shiny")
  
  # first load the data files in the data directory so that the App see them
  Resort_Visits <- read.csv(paste(local_directory, "data/Resort_Visits.csv", sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
  Boat_Purchase <- read.csv(paste(local_directory, "data/Boat_Purchase.csv", sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
  Boat_Purchase=data.matrix(Boat_Purchase) # this file needs to be converted to "numeric"....
  
  # now run the app
  runApp(paste(local_directory,"tools", sep="/"))  
}

