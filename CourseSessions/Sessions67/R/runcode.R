

######################################################################
# generate the report, slides, and if needed start the web application


unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( paste(local_directory,"doc/Report_s67.Rmd", sep="/"),"Report_s67.Rmd", overwrite = T )
knit2html( 'Report_s67.Rmd', quiet = TRUE )
file.copy( 'Report_s67.html', paste(local_directory,"doc/Report_s67.html", sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      

unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( paste(local_directory,"doc/Slides_s67.Rmd", sep="/"),"Slides_s67.Rmd", overwrite = T )
slidify( "Slides_s67.Rmd" )
file.copy( 'Slides_s67.html', paste(local_directory,"doc/Slides_s67.html", sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      

