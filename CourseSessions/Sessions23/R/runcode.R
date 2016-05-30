

######################################################################
# generate the report, slides, and if needed start the web application


reportfilename = paste(report_file, "Rmd", sep=".")
docreportfilename = paste("doc", reportfilename, sep="/")
htmloutput = paste(report_file, "html", sep = ".")
dochtmloutput = paste("doc", htmloutput, sep="/")

unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( paste(local_directory,docreportfilename, sep="/"),reportfilename, overwrite = T )
rmarkdown::render( reportfilename, quiet = TRUE )
file.copy( htmloutput, paste(local_directory,dochtmloutput, sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      

reportfilename = paste(slides_file, "Rmd", sep=".")
docreportfilename = paste("doc", reportfilename, sep="/")
htmloutput = paste(slides_file, "html", sep = ".")
dochtmloutput = paste("doc", htmloutput, sep="/")

unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( paste(local_directory,docreportfilename, sep="/"),reportfilename, overwrite = T )
slidify( reportfilename )
file.copy( htmloutput, paste(local_directory,dochtmloutput, sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      
