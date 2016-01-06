get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}

libraries_used=c("stringr","gtools","foreign","reshape2","digest","timeDate","devtools","knitr","graphics",
                 "grDevices","xtable","sqldf","stargazer","TTR","quantmod","shiny",
                 "Hmisc","vegan","fpc","GPArotation","FactoMineR","cluster",
                 "psych","stringr","googleVis", "png","ggplot2","googleVis", "gridExtra","RcppArmadillo","xts","DescTools")

get_libraries(libraries_used)

options(stringsAsFactors=FALSE)

#####

#
#
#

yeardays<-function(x){
  fd<-as.integer(as.Date(head(names(x),1),format="%Y-%m-%d"))
  ld<-as.integer(as.Date(tail(names(x),1),format="%Y-%m-%d"))
  365.25*length(x)/(ld-fd)
}

vol_pa<-function(x,exclude_zero=(x!=0), holidays = holidayNYSE()) {
  if(is.null(names(x))){ good_days <- TRUE }else { good_days <- isBizday(as.timeDate(names(x)), holidays, wday = 1:5) }
  x1<-drop(x[exclude_zero & good_days])
  sqrt(yeardays(x1))*sd(x1)
}

sharpe<-function(x,exclude_zero=(x!=0), holidays = holidayNYSE() ) {
  if(is.null(names(x))){ good_days <- TRUE }else { good_days <- isBizday(as.timeDate(names(x)), holidays, wday = 1:5) }
  x1<-drop(x[exclude_zero & good_days])
  round(yeardays(x1)*mean(x1)/vol_pa(x1),digits=2)   # annualized
}

bps<-function(x,exclude_zero=(x!=0))round(10000*mean(drop(x[exclude_zero])),digits=2)

drawdown<-function(x)round(100*max(cummax(cumsum(x))-cumsum(x)),digits=2)

pnl_stats<-function(x, show_tr = FALSE, show_gr = FALSE){
  if(class(x)=="matrix")if(ncol(x)>1)x<-x[,1]
  ret<-c(Ret=round(100*yeardays(x)*mean(x),digits=1),Vol=round(100*vol_pa(x),digits=1),Sharpe=round(sharpe(x),2),DD=round(drawdown(x),1))
  ret
}

pnl_plot<-function(x,...){
  pargs<-as.list(match.call(expand.dots=TRUE))
  if(!"ylab" %in% names(pargs)) ylab<-deparse(substitute(x)) else ylab<-pargs$ylab
  if(!"main" %in% names(pargs)) main<-paste(names(pnl_stats(x)),pnl_stats(x),sep=":",collapse=" ") else main<-pargs$main
  plot_arguments<-c(list(x=cumsum(x*100),type="l",ylab=ylab,cex.main = 0.9, main=main,axes=FALSE),pargs[setdiff(names(pargs),c("","x","ylab","main"))])
  do.call(plot,plot_arguments)
  if(!is.null(names(x))){
    axis(1,at=seq(1,length(x),length.out=5),labels=names(x)[seq(1,length(x),length.out=5)])
    axis(2)
  } else { axis(1); axis(2)}
}

pnl_matrix<-function(perf, digits = 2){
  month_map<-c("01"="Jan","02"="Feb","03"="Mar","04"="Apr","05"="May","06"="Jun","07"="Jul","08"="Aug","09"="Sep","10"="Oct","11"="Nov","12"="Dec")
  perf_dates<-structure(do.call(rbind,strsplit(names(perf),"-")),dimnames=list(names(perf),c("Year","Month","Day")))
  perf_dates[,"Month"]<-month_map[perf_dates[,"Month"]]
  perf_years  <- sort(unique(perf_dates[,"Year"]))
  perf_months <- month_map
  res<-structure(
    outer(perf_years,perf_months,function(i_vec,j_vec)mapply(function(i,j){
      perf_ndx <- perf_dates[,"Year"]==i & perf_dates[,"Month"]==j
      if(sum(perf_ndx)==0)return(NA)
      prod(perf[perf_ndx]+1)-1
    },i_vec,j_vec)),
    dimnames=list(perf_years,perf_months)
  )
  round(cbind(res,Year=apply(res,1,function(r)prod(r[!is.na(r)]+1)-1))*100,digits=2)
}

show_stats<-function(x)paste(names(pnl_stats(x)),pnl_stats(x),sep=":",collapse=" \\textbar ")

###

# if number of non-zeroes of x is less than n, return 0, else return the mean of the non-zero entries 
non_zero_mean<-function(x,n=1)ifelse(sum(x!=0)<n,0,mean(x[x!=0]))
# moving average of previous n elements : 0 for first n-1 elements
ma<-function(x,n,f=identity){res<-as.numeric(filter(f(x),rep(1/n,n),method="convolution",sides=1,circular=FALSE)); ifelse(is.na(res),0,res)}
# moving sum of previous n elements : 0 for first n-1 elements
ms<-function(x,n,f=identity){res<-as.numeric(filter(f(x),rep(1,n),method="convolution",sides=1,circular=FALSE)); ifelse(is.na(res),0,res)}
# shift forward if n +ve , backward if n -ve.
moving_average<-function(n)function(x)ma(x,n)
moving_sum<-function(n)function(x)ms(x,n)

shift<-function(a,n=1,filler=0){
  x<-switch(class(a),matrix=a,matrix(a,ncol=1,dimnames=list(names(a),NULL)))
  if(n==0)return(x)
  if(n>0){
    rbind(matrix(filler,ncol=ncol(x),nrow=n),head(x,-n)) 
  } else {
    rbind(tail(x,n),matrix(filler,ncol=ncol(x),nrow=abs(n)))
  }
}
# replace non-finite elements in x with zeroes
scrub<-function(x){
  if(length(x)==0)return(0)
  x[which(!is.finite(x))]<-0
  x
}

######

# roll function over multiple matrix rows, in parallel. mapply for matrices.
multiroll_fun<-function(fun,w,...,MoreArgs=NULL,verbose=identity){
  data<-list(...)
  if(length(data)==0)stop("multiroll: data required")
  if(length(data)!=length(formals(fun)))stop("multiroll: fun arg count differs from data length")
  if(!all(unlist(lapply(data,class))=="matrix"))stop("multiroll: only matrix")
  if( length(unique(unlist(lapply(data,nrow))))!=1 )stop("multiroll: all matrices must have same rows")
  p<-nrow(data[[1]])
  ndx<-t(matrix(c(0,w-1),nrow=2,ncol=p-w+1)+t(matrix(1:(p-w+1),ncol=2,nrow=p-w+1)))
  res<-t(simplify2array(apply(ndx,1,function(r){
    window_res<-do.call(fun,c(lapply(data,function(m)m[r[1]:r[2],,drop=FALSE]),MoreArgs))
    if(class(verbose)=="function")cat(r[2]," ",verbose(window_res),"\n")
    window_res
  })))
  if(class(res)=="matrix")rownames(res)<-rownames(data[[1]])[ndx[,2]] else names(res)<-rownames(data[[1]])[ndx[,2]]
  res
}

# apply function to matrix, matrix result
row_apply<-function(m,f,...){
  if(class(m)!="matrix")return(NULL)
  if(!any(class(f)%in%c("function","standardGeneric")))return(NULL)
  mcol<-ncol(m)
  res<-t(apply(m,1,function(r){
    row_res<-drop(unlist(f(r,...)))
    if(length(row_res)==1)return(rep(row_res,mcol))
    if(length(row_res)==mcol)return(row_res)
    return(rep(0,length(r)))
  }))
  dimnames(res)<-dimnames(m)
  res
}

# apply function to matrix, matrix result
col_apply<-function(m,f,...){
  if(class(m)!="matrix")return(NULL)
  if(!any(class(f)%in%c("function","standardGeneric")))return(NULL)
  mrow<-nrow(m)
  res<-apply(m,2,function(r){
    row_res<-drop(unlist(f(r,...)))
    if(length(row_res)==1)return(rep(row_res,mrow))
    if(length(row_res)==mrow)return(row_res)
    return(rep(0,length(r)))
  })
  dimnames(res)<-dimnames(m)
  res
}

"%-%"<-row_apply
"%|%"<-col_apply

############################

# data is a daysXsecurities matrix of dayly returns.
# the %|% operator applies a function column-wise
# moving_average(window) returns a function that does it.
rolling_variance<-function(data,window){
  average_square <- (data*data)%|%moving_average(window)
  average_move <- data%|%moving_average(window)
  average_square - average_move*average_move
}

rolling_correlation<-function(security1,security2,window){
  covariance<-rolling_covariance(security1,security2,window)
  variance1<-rolling_variance(security1,window)
  variance2<-rolling_variance(security2,window)
  ifelse(variance1>0&variance2>0,covariance/sqrt(variance1*variance2),0)
}


################

render_latex_pnl_matrix<-function(x1,caption,digits=0,lmargin="-2cm", resize_factor=1){
  x<-ifelse(is.na(x1),0,x1)
  m_max_x<-max(x[col(x)<ncol(x)])
  m_min_x<-min(x[col(x)<ncol(x)])
  y_max_x<-max(x[,ncol(x)])
  y_min_x<-min(x[,ncol(x)])
  month_pnl_to_latex<-function(xi){
    if(is.na(xi))return("-") #return("\\cellcolor{ black!20 } $\\times$")
    if(xi>0)return(paste("{\\color[rgb]{0,",round((xi/m_max_x)^(1/3),digits=2),",0}",formatC(xi,format="f",dig=digits),"}",sep="",collaplse=""))
    if(xi<0)return(paste("{\\color[rgb]{",round((xi/m_min_x)^(1/3),digits=2),",0,0}",formatC(xi,format="f",dig=digits),"}",sep="",collaplse=""))
    return(formatC(xi,format="f",dig=digits))
  }
  year_pnl_to_latex<-function(xi){
    if(is.na(xi))return("-") #("\\cellcolor{ black!20 } $\\times$")
    if(xi>0)return(paste("{\\color[rgb]{0,",round(xi/y_max_x,digits=2),",0}",formatC(xi,format="f",dig=digits),"}",sep="",collaplse=""))
    if(xi<0)return(paste("{\\color[rgb]{",round(xi/y_min_x,digits=2),",0,0}",formatC(xi,format="f",dig=digits),"}",sep="",collaplse=""))
    return(formatC(xi,format="f",dig=digits))
  }
  if(nchar(lmargin)>0)cat("\\begin{adjustwidth}{",lmargin,"}{}\n",sep="")
  if(resize_factor!=1)cat(paste(paste("\\scalebox{", resize_factor,sep=""), "}{ \n", sep=""))
  cat("\\begin{tabular}{",paste(paste(rep("r",ncol(x)),collapse=""),"r",sep="",collapse=""),"}\n",sep="")
  cat("\\hline\n")
  for(i in 1:ncol(x))cat("& ",latexTranslate(colnames(x)[i]))
  cat("\\\\ \n")
  cat("\\hline \n")
  for(i in 1:nrow(x)){
    if(i %% 2 >0) cat("\\rowcolor[gray]{0.95}\n")
    cat(latexTranslate(rownames(x)[i])," ")
    for(j in 1:ncol(x)){
      if(j<ncol(x))cat("& ",month_pnl_to_latex(x1[i,j])) else cat("& \\textbf{",year_pnl_to_latex(x1[i,j]),"}")
    }
    cat("\\\\ \n")
  }
  cat("\\hline \n")
  cat("\\end{tabular}\n")
  if(resize_factor!=1)cat("} \n")
  if(nchar(caption)>0)cat("\\captionof{table}{",latexTranslate(caption),"}\n") 
  if(nchar(lmargin)>0)cat("\\end{adjustwidth}\n")
}


latex_render_data_frame<-function(x,caption,label, digits,align=paste(rep("l",ncol(x)),sep="",collapse=""),lmargin="-3.75cm",show_rownames=FALSE,in_lot=TRUE,red_text="",green_text="",blue_text="",resize_factor=1){
  #  cat("\\begin{center} \n")
  #  cat("\\begin{adjustwidth}{",lmargin,"}{",lmargin,"}\n",sep="")
  #  cat("\\centering\n")
  align_string<-align
  if(show_rownames)align_string<-paste("l",align_string,sep="",collapse="")
  #  cat(paste(paste("\\scalebox{", resize_factor,sep=""), "}{ \n", sep=""))
  cat("\\begin{table}[H]\n")
  cat("\\resizebox{",resize_factor,"\\textwidth}{!}{\\begin{minipage}{\\textwidth}")
  cat("\\begin{tabular}{",align_string,"}\n")
  cat("\\hline\n")
  if(show_rownames)cat(" & ")
  if(length(colnames(x))>0)for(i in 1:ncol(x)){
    if(i>1)cat("& ")
    cat(latexTranslate(colnames(x)[i]))
  }
  cat("\\\\ \n")
  cat("\\hline \n")
  for(i in 1:nrow(x)){
    if(i %% 2 >0) cat("\\rowcolor[gray]{0.95}\n")
    if(show_rownames)cat(latexTranslate(rownames(x)[i])," & ",sep="")
    for(j in 1:ncol(x)){
      the_value<-x[i,j]
      if(is.na(the_value))the_value<-"-"
      res<-switch(class(the_value),
                  numeric=paste("\\textcolor",ifelse(sign(the_value)<0,"{red}","{black}"),"{",formatC(the_value,format="f",dig=digits),"}",sep="",collapse=""),
                  integer=paste("\\textcolor",ifelse(sign(the_value)<0,"{red}","{black}"),"{",format(the_value,scientific=FALSE,digits=0,big.mark=","),"}",sep="",collapse=""),
                  character={
                    formatted_value<-latexTranslate(the_value)
                    if(the_value %in% red_text)formatted_value<-paste("\\textcolor{red}{",formatted_value,"}")
                    if(the_value %in% green_text)formatted_value<-paste("\\textcolor{green}{",formatted_value,"}")
                    if(the_value %in% blue_text)formatted_value<-paste("\\textcolor{blue}{",formatted_value,"}")
                    formatted_value
                  },
                  latexTranslate(as.character(the_value))
      )
      if(j>1)cat("& ")
      cat(res)
    }
    cat("\\\\ \n")
  }
  cat("\\hline")
  cat("\n")
  cat("\\end{tabular}\n")
  if(nchar(caption)>0)cat("\\caption{",latexTranslate(caption),"}\n") 
  # cat("} \n")
  cat(paste(paste("\\label{", latexTranslate(label),sep=""),"}\n",sep=""))
  cat("\\end{minipage} } \n")
  cat("\\end{table}\n")
  #  cat("\\end{adjustwidth}\n")
  #  cat("\\end{center}")
}

print_dataframe_latex<-function(x,title="", caption = ""){
  x1<-xtable(x,format="latex",row.names=FALSE, longtable=TRUE, booktabs=TRUE,digits=0,caption=caption)
  rcol<-tail(ifelse((1:nrow(x1)-1)%%2==0,"\\rowcolor[gray]{1.00} \n","\\rowcolor[gray]{0.95} \n"),-1)
  rndx<-tail(1:nrow(x1)-1,-1)
  title_string<-""
  if(length(title)>0)title_string<-paste0(
    "\\hline \n",
    "\\multicolumn{",ncol(x),"}{c}{",title,"} \\\\ \n"
  )
  print(
    x1,
    floating=FALSE,
    include.rownames = FALSE,
    include.colnames = FALSE,
    tabular.environment = "longtable",
    add.to.row = list(
      pos = as.list(c(0,rndx)),
      command = c(paste(
        title_string,
        "\\hline  \n",
        paste(latexTranslate(colnames(x)), collapse=" & "), "\\\\",
        "\\hline  \n",
        "\\endfirsthead \n", 
        "\\hline \n", 
        paste(latexTranslate(colnames(x)), collapse=" & "), "\\\\",
        "\\hline \n",
        "\\endhead \n", 
        "\\hline \n",
        "\\multicolumn{",ncol(x),"}{r}{\\textit{Continued}} \\ \n", 
        "\\endfoot ",
        "\\endlastfoot \n",
        collapse=" "),rcol)
    )
  )
}


#############




