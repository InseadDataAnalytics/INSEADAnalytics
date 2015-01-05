
# Project Name: "Session 8 of INSEAD Data Analytics for Business Course: "Projects and Summary"

rm(list = ls()) # clean up the workspace

local_directory <- paste(getwd(),"CourseSessions/Session8", sep="/")
#local_directory <- "~INSEADAnalytics/CourseSessions/Sessions67"

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# THIS IS A SPECIAL CASE PROJECT: IT ONLY HAS SLIDES. IT DOES NOT USE ANY REPORT, DATA, AND WEB APPLICATION

source(paste(local_directory,"library.R", sep="/"))

slidify(paste(local_directory,"Slides_s8.Rmd", sep="/"))
knit2html( paste(local_directory,'Report_s8.Rmd', sep="/"), quiet = TRUE )
