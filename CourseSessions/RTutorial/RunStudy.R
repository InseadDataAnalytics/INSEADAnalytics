# This is the begining of a new world.....
# We will have some fun
#### INITIALIZATION
################################################################################
rm(list = ls( ))
getwd()
# Let's get the data
ProjectData = read.csv("data/Boats.csv", sep=";", dec=",", header = TRUE)
###
# THis is the file where i have the main report for the project 
docfile = "doc/report.Rmd"

################################################################################
#### THese are the main "parameters" of the project

################################################################################
### This is where I ask RunStudy.R to "compile" my project document
source("R/library.R")
## Generate the report
rmarkdown::render(docfile, quiet = TRUE )
