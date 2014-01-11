# Required R libraries (need to be installed - it can take a few minutes the first time you run the project)

# installs all necessary libraries from CRAN
get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}

libraries_used=c("devtools","shiny","knitr","graphics","grDevices","xtable",
                 "Hmisc","vegan","fpc","GPArotation","FactoMineR","cluster",
                 "psych")
get_libraries(libraries_used)

if (require(slidifyLibraries) == FALSE) 
  install_github("slidifyLibraries", "ramnathv")
if (require(slidify) == FALSE) 
  install_github("slidify", "ramnathv") 

#############

corstars <- function(x){
  require(Hmisc)
  x <- as.matrix(x)
  R <- rcorr(x)$r
  p <- rcorr(x)$P
  mystars <- ifelse(p < 0.01, "**", ifelse(p < 0.05, "*", "  "))
  R <- format(round(cbind(rep(-1.111, ncol(x)), R), 3))[,-1]
  Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
  diag(Rnew) <- paste(diag(R), "", sep = "")
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep = "")
  Rnew <- as.data.frame(Rnew)
  return(Rnew)
}
