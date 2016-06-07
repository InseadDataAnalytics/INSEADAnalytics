# Project Name: "R tutorial"

rm(list = ls()) # clean up the workspace

# When running the case on a local computer, modify this in case you saved the case in a different directory 
# (e.g. local_directory <- "C:/user/MyDocuments" )
# type in the Console below help(getwd) and help(setwd) for more information
#local_directory <- paste(getwd(), "CourseSessions/Session1", sep="/")
local_directory = getwd()
#local_directory <- "MYDIRECTORY/CourseSessions/Session1"

#cat("\n *********\n WORKING DIRECTORY IS ", local_directory, "\n PLEASE CHANGE IT IF IT IS NOT CORRECT using setwd(..) - type help(setwd) for more information \n *********")

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

ProjectData <- read.csv(file = "data/Boats.csv", header = TRUE, sep=";")
correlation_columns = 3:6


# THIS IS A SPECIAL CASE PROJECT: IT ONLY HAS SLIDES. IT DOES NOT USE ANY REPORT, DATA, AND WEB APPLICATION

source(paste(local_directory,"R/library.R", sep="/"))

rmarkdown::render("doc/rtutorialdoc.Rmd", quiet = TRUE )

