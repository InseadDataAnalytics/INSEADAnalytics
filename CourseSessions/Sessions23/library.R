# Required R libraries (need to be installed - it can take a few minutes the first time you run the project)

# installs all necessary libraries from CRAN
get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}

libraries_used=c("devtools","knitr","graphics","grDevices","xtable","pryr",
                 "Hmisc","vegan","fpc","GPArotation","FactoMineR","cluster",
                 "psych","stringr","googleVis", "png","ggplot2","googleVis", "gridExtra")
get_libraries(libraries_used)

if (require(slidifyLibraries) == FALSE) 
  install_github("slidifyLibraries", "ramnathv")
if (require(slidify) == FALSE) 
  install_github("slidify", "ramnathv") 

#############

my_summary <- function(thedata){
  res = apply(thedata, 2, function(r) c(min(r), quantile(r, 0.25), quantile(r, 0.5), mean(r), quantile(r, 0.75), max(r), sd(r)))
  res <- round(res,2)
  colnames(res) <- colnames(thedata)
  rownames(res) <- c("min", "25 percent", "median", "mean", "75 percent", "max", "std")
  t(res)
}
