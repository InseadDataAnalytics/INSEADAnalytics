# Required R libraries (need to be installed - it can take a few minutes the first time you run the project)


# installs all necessary libraries from CRAN or Github
get_libraries <- function(filenames_list) suppressPackageStartupMessages({ 
  lapply(filenames_list, function(thelibrary){    
    thelibrary.split <- strsplit(thelibrary, "/")[[1]]
    if (length(thelibrary.split) > 1) {
      # install from Github
      if (!suppressWarnings(require(thelibrary.split[2], character.only=TRUE))) {
        devtools::install_github(thelibrary, quiet=TRUE)
        library(thelibrary.split[2], character.only=TRUE)
      }
    } else {
      # install from CRAN
      if (!suppressWarnings(require(thelibrary, character.only=TRUE))) {
        install.packages(thelibrary, repos="http://cran.r-project.org/", quiet=TRUE)
        library(thelibrary, character.only=TRUE)
      }
    }
  })
})

libraries_used=c("devtools","knitr","graphics","grDevices","xtable","pryr",
                 "Hmisc","vegan","fpc","GPArotation","FactoMineR","cluster",
                 "psych","stringr","googleVis", "png","ggplot2","googleVis", 
                 "gridExtra", "reshape2", "DT", "ramnathv/slidifyLibraries",
                 "ramnathv/slidify", "cttobin/ggthemr", "dplyr", "mrjoh3/c3",
                 "rpart.plot","vkapartzianis/formattable", "ggdendro","ROCR",
                 "networkD3")
get_libraries(libraries_used)

#############

my_summary <- function(thedata){
  res = apply(thedata, 2, function(r) c(min(r), quantile(r, 0.25), quantile(r, 0.5), mean(r), quantile(r, 0.75), max(r), sd(r)))
  res <- round(res,2)
  colnames(res) <- colnames(thedata)
  rownames(res) <- c("min", "25 percent", "median", "mean", "75 percent", "max", "std")
  t(res)
}
