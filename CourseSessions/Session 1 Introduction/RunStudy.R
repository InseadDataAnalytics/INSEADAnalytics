
# Project Name: "Sessions 2-3 of INSEAD Big Data Analytics for Business Course: "Dimensionality Reduction and Derived Attributes"

rm(list = ls()) # clean up the workspace

setwd(paste(getwd(),"CourseSessions/Session 1 Introduction",sep="/"))

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# THIS IS A SPECIAL CASE PROJECT: IT ONLY HAS SLIDES. IT DOES NOT USE ANY REPORT, DATA, AND WEB APPLICATION

source("library.R")

slidify("Slides_s1.Rmd")
