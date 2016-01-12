
# rm(list=ls()) # Clean up the memory, if we want to rerun from scratch
# source("Exercises/Introduction to R/helpersSet1.R")

getdata.fromscratch = 1

website_used = "yahoo" # can be "yahoo" or other ( see help(getSymbols) ). Depending on the website we may need to change the stock tickers' representation

mytickers = c("SPY", "AAPL")  # Other tickers for example are "GOOG", "GS", "TSLA", "FB", "MSFT", 
NumberOfStocks = length(mytickers)
startDate = "2005-01-01"

if (getdata.fromscratch){
  # Get SPY first, to get all trading days
  tmp<-as.matrix(try(getSymbols(Symbols="SPY",from = startDate,src = website_used, auto.assign=FALSE)))
  #cat(colnames(tmp))
  
  StockPrices=matrix(rep(NA,nrow(tmp)*NumberOfStocks), ncol=NumberOfStocks)
  colnames(StockPrices)<-c(); 
  rownames(StockPrices)<-rownames(tmp)
  StockVolume=StockPrices
  StockPrices[,1] <- tmp[,6]
  
  ticker_to_get = mytickers[2]
  tmpdata<-as.matrix(try(getSymbols(Symbols=ticker_to_get,from = startDate,auto.assign=FALSE)))
  if (!inherits(tmpdata, "try-error"))
  {
    therownames=intersect(rownames(tmpdata),rownames(StockPrices))
    StockPrices[therownames,2]<-tmpdata[therownames,6] # adjusted close price
    StockVolume[therownames,2]<-tmpdata[therownames,5] # shares volume for now - need to convert to dollars later
  } else {
    cat(ticker_to_get," NOT found")
  }
  
  # Get the daily returns now. Use the simple percentage difference approach 
  StockReturns= (tail(StockPrices,-1)-head(StockPrices,-1))/head(StockPrices,-1) # note that this removes the first day as we have no way to get the returns then!
  
  # Now remove the first day from the other data, too
  StockPrices = StockPrices[rownames(StockReturns),]
  StockVolume = StockPrices[rownames(StockReturns),]
  colnames(StockPrices)<-mytickers
  colnames(StockVolume)<-mytickers
  colnames(StockReturns)<-mytickers
  
  save(StockReturns,StockPrices,StockVolume, file = "DataSet1.Rdata")
} else {
  load("DataSet1.Rdata")
}



