
# Project Name: "Session 8 of INSEAD Big Data Analytics for Business Course: "Projects and Summary"

rm(list = ls()) # clean up the workspace

setwd(paste(getwd(),"CourseSessions/Session 8 Projects and Summary",sep="/"))

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# THIS IS A SPECIAL CASE PROJECT: IT ONLY HAS SLIDES. IT DOES NOT USE ANY REPORT, DATA, AND WEB APPLICATION

source("library.R")

slidify("Slides_s8.Rmd")
knit2html( 'Report_s8.Rmd', quiet = TRUE )
