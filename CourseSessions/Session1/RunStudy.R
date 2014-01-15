
# Project Name: "Sessions 2-3 of INSEAD Big Data Analytics for Business Course: "Dimensionality Reduction and Derived Attributes"

rm(list = ls()) # clean up the workspace

# When running the case on a local computer, modify this in case you saved the case in a different directory 
# (e.g. local_directory <- "C:/user/MyDocuments" )
# type in the Console below help(getwd) and help(setwd) for more information
local_directory <- "~/CourseSessions/Session 1 Introduction" 
local_directory <- "C:/Theos/insead/eLAB/INSEADjan2014/CourseSessions/Session 1 Introduction"

cat("\n *********\n WORKING DIRECTORY IS ", local_directory, "\n PLEASE CHANGE IT IF IT IS NOT CORRECT using setwd(..) - type help(setwd) for more information \n *********")

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# THIS IS A SPECIAL CASE PROJECT: IT ONLY HAS SLIDES. IT DOES NOT USE ANY REPORT, DATA, AND WEB APPLICATION

source(paste(local_directory,"library.R", sep="/"))

slidify(paste(local_directory,"Slides_s1.Rmd", sep="/"))
