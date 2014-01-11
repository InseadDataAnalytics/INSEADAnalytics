
# A number of useful functions for manipulating matrices

ma<-function(x,n,f=identity){res<-as.numeric(filter(f(x),rep(1/n,n),method="convolution",sides=1,circular=FALSE)); ifelse(is.na(res),0,res)}
ms<-function(x,n,f=identity){res<-as.numeric(filter(f(x),rep(1,n),method="convolution",sides=1,circular=FALSE)); ifelse(is.na(res),0,res)}
moving_average<-function(n)function(x)ma(x,n)
moving_sum<-function(n)function(x)ms(x,n)

# apply function to matrix, matrix result
row_apply<-function(m,f,...){
  if(class(m)!="matrix")return(NULL)
  if(!class(f)%in%c("function","standardGeneric"))return(NULL)
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
  if(!class(f)%in%c("function","standardGeneric"))return(NULL)
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

cross_fun<-function(x,y,fun,...){
  if(!all(dim(x)==dim(y)))return(NULL)
  t(sapply(1:nrow(x),function(i)head(rep(fun(x[i,],y[i,],...),ncol(x)),ncol(x))))
}

##########################################

# These are two very useful matrix functions. 
# Example: x=A%-%sum where A is a matrix and sum can be replaced with any vector function. 

"%-%"<-row_apply
"%|%"<-col_apply

