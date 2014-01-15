


ProjectDataFactor=ProjectData[,factor_attributes_used]


unlink( "TMPdirReport", recursive = TRUE )      
dir.create( "TMPdirReport" )
setwd( "TMPdirReport" )
file.copy( paste(local_directory,"doc/Report_s23.Rmd", sep="/"),"Report_s23.Rmd", overwrite = T )
knit2html( 'Report_s23.Rmd', quiet = TRUE )
file.copy( 'Report_s23.html', paste(local_directory,"doc/Report_s23.html", sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirReport", recursive = TRUE )      


unlink( "TMPdirSlides", recursive = TRUE )      
dir.create( "TMPdirSlides" )
setwd( "TMPdirSlides" )
file.copy( paste(local_directory,"doc/Slides_s23.Rmd", sep="/"),"Slides_s23.Rmd", overwrite = T )
slidify( "Slides_s23.Rmd" )
file.copy( 'Slides_s23.html', paste(local_directory,"doc/Slides_s23.html", sep="/"), overwrite = T )
setwd( "../" )
unlink( "TMPdirSlides", recursive = TRUE )      
