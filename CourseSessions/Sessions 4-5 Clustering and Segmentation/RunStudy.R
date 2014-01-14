
# Project Name: "Sessions 4-5 of INSEAD Big Data Analytics for Business Course: "Clustering and Segmentation"

rm(list = ls( )) # clean up the workspace

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# When running the case on a local computer, modify this in case you saved the case in a different directory 
# (e.g. local_directory <- "C:/user/MyDocuments" )
# type in the Console below help(getwd) and help(setwd) for more information
local_directory <- paste(getwd(),"COurseSessions/Sessions 4-5 Clustering and Segmentation", sep="/")

# Please ENTER the name of the file with the data used. The file should contain a matrix with one row per observation (e.g. person) and one column per attribute. THE NAME OF THIS MATRIX NEEDS TO BE ProjectData (otherwise you will need to replace the name of the ProjectData variable below with whatever your variable name is, which you can see in your Workspace window after you load your file)
datafile_name <- "Mall Visits.csv"

# Please ENTER a name that describes the data for this project
data_name="Mall Visits"

# this loads the selected data
ProjectData <- read.csv(paste("data", datafile_name, sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData

# Please ENTER the number of clusters to eventually use for this report
numb_clusters_used = 2

# Please ENTER the distance metric eventually used for the clustering in case of hierarchical clustering 
# (e.g. "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski" - see help(dist)). 
# DEFAULT is "euclidean"
distance_used="euclidean"

# Please ENTER then original raw attributes to use for the segmentation (the "segmentation attributes")
segmentation_attributes_used=1:ncol(ProjectData)

# Please ENTER then original raw attributes to use for the profiling of the segments (the "profiling attributes")
profile_attributes_used=1:ncol(ProjectData)

# Please ENTER the hierarchical clustering method to use (options are:
# "ward", "single", "complete", "average", "mcquitty", "median" or "centroid")
# DEFAULT is "ward"
hclust_method = "ward"

# Please ENTER the kmeans clustering method to use (options are:
# "Hartigan-Wong", "Lloyd", "Forgy", "MacQueen"
# DEFAULT is "Lloyd"
kmeans_method = "Lloyd"

# Please enter the minimum number below which you would like not to print - this makes the readability of the tables easier. Default values are either 10e6 (to print everything) or 0.5. Try both to see the difference.
MIN_VALUE=0.5


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

################################################
# Now run everything
source("R/library.R")
source("R/runcode.R")

if (start_local_webapp)
  runApp("tools")
