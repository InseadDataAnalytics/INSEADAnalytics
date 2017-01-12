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

# Determine document output format, return "html" by default
getDocumentOutputFormat <- function() {
  format <- opts_knit$get('rmarkdown.pandoc.to')
  if (!is.null(format)) format else "html"
}

# Format tables for html/latex output
normalize.abs <- function(x, min=0, max=1, na.rm=FALSE) normalize(abs(x), min, max, na.rm)
iprint.df <- function(df, scale=FALSE) {
  if (getDocumentOutputFormat() == "html") {
    if (class(df) != "data.frame")
      df <- as.data.frame(df)
    x <- lapply(colnames(df), function(col) {
      if (is.numeric(df[, col]))
        color_bar(rgb(238, 238, 238, max=255), normalize.abs, min=0.1, na.rm=TRUE)
      else
        formatter("span")
    })
    names(x) <- colnames(df)
    tags$div(class="formattable_container", HTML(gsub("NA", "", format_table(df, x))))
  } else if (opts_knit$get('rmarkdown.pandoc.to') == "latex") {
    cat(ifelse(scale, "\\setkeys{Gin}{height=\\textheight}\\adjustbox{width=\\linewidth}{", "\\begin{center}"))
    cat(kable(df, format="latex", booktabs=TRUE, longtable=!scale))
    cat(ifelse(scale, "}\\setkeys{Gin}{height=\\maxheight}", "\\end{center}"))
  } else {
    kable(df)
  }
}

# Format plots for html/latex output
iplot.df <- function(df, x=colnames(df)[1], y="value", v="variable", type="line", xlab=NULL, ylab=NULL) {
  if (getDocumentOutputFormat() == "html") {
    p <- c3(df, x=x, y=y, group=v, width="100%", height="480px")
    p <- switch(type,
                line = p %>% c3_line('spline'),
                bar  = p %>% c3_bar(bar_width=0.90)
    )
    if (!is.null(xlab)) p <- p %>% xAxis(label=xlab)
    if (!is.null(ylab)) p <- p %>% yAxis(label=ylab)
    p
  } else {  # latex, etc.
    p <- ggplot(df, aes_string(x=x, y=y, colour=v))
    p <- switch(type,
                line = p + geom_line(),
                bar  = p + geom_bar(stat="identity")
    )
    if (!is.null(xlab)) p <- p + labs(x=xlab)
    if (!is.null(ylab)) p <- p + labs(y=ylab)
    p
  }
}

iplot.hist <- function(x, breaks="Sturges", xlab=NULL) {
  h <- hist(x, breaks=breaks, plot=FALSE)
  df <- data.frame(x=head(h$breaks, -1), Frequency=h$counts)
  iplot.df(df, x="x", y="Frequency", v=NULL, type="bar", xlab=xlab)
}

iplot.grid <- if (getDocumentOutputFormat() == "html") tags$div else grid.arrange

iplot.dendrogram <- function(cluster) {
  labels <- (length(cluster$labels) > 40)
  if (getDocumentOutputFormat() == "html") {
    cluster$labels <- if (!labels) NULL else cluster$labels
    margins <- list(top=10, right=0, bottom=ifelse(labels, 120, 10), left=0)
    dendroNetwork(cluster, width="100%", height="480px", fontSize=14,
                  treeOrientation="vertical", margins=margins, textRotate=90)
  } else {  # latex, etc.
    ggdendrogram(Hierarchical_Cluster, theme_dendro=FALSE, labels=labels) +
      xlab("Observations") + ylab("Height")
  }
}

