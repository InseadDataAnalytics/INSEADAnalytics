#install.packages("forecast") #-- do this only once 
#Check the book: https://www.otexts.org/fpp2 and the blog: http://robjhyndman.com/hyndsight 
library(forecast)

ElectricPriceData<-read.csv(file.choose(), header=TRUE, sep=",")

ElectricPrice_ts <- ts(ElectricPriceData$ElectricRate,start=2004, frequency=12) # ts function defines the dataset as timeseries starting Jan 2004 and having seasonality of frequency 12 (monthly) 

#plot various decompositions into error/noise, trend and seasonality

fit <- decompose(ElectricPrice_ts, type="multiplicative") #decompose using "classical" method, multiplicative form
plot(fit)

fit <- decompose(ElectricPrice_ts, type="additive") #decompose using "classical" method, additive form
plot(fit)

fit <- stl(ElectricPrice_ts, t.window=12, s.window="periodic") #decompose using STL (Season and trend using Loess)
plot(fit)

plot(ElectricPrice_ts)

# Create exponential smoothing models: additive vs multiplicative noise (first A vs M), additive vs multiplicative trend (second A vs M) and no seasonality vs automatic detection (third N vs Z) trend and no seasonlity (AAN), multiplicative (MMN)
ElectricPrice_AAN <- ets(ElectricPrice_ts, model="AAN")
ElectricPrice_AAZ <- ets(ElectricPrice_ts, model="AAZ", damped=FALSE)
ElectricPrice_MMN <- ets(ElectricPrice_ts, model="MMN", damped=FALSE)
ElectricPrice_MMZ <- ets(ElectricPrice_ts, model="MMZ", damped=FALSE)

# Create their prediction "cones" for 360 months (30 years) into the future with quintile confidence intervals
ElectricPrice_AAN_pred <- forecast(ElectricPrice_AAN, h=360, level=c(0.8, 0.95))
ElectricPrice_AAZ_pred <- forecast(ElectricPrice_AAZ, h=360, level=c(0.8, 0.95))
ElectricPrice_MMN_pred <- forecast(ElectricPrice_MMN, h=360, level=c(0.8, 0.95))
ElectricPrice_MMZ_pred <- forecast(ElectricPrice_MMZ, h=360, level=c(0.8, 0.95))

# Compare the prediction "cones" visually
par(mfrow=c(1,4)) # This command sets the plot window to show 1 row of 4 plots
plot(ElectricPrice_AAN_pred, xlab="Year", ylab="Predicted Electric Rate")
plot(ElectricPrice_MMN_pred, xlab="Year", ylab="Predicted Electric Rate")
plot(ElectricPrice_AAZ_pred, xlab="Year", ylab="Predicted Electric Rate")
plot(ElectricPrice_MMZ_pred, xlab="Year", ylab="Predicted Electric Rate")

# Lets look at what our models actually are -- ETS
ElectricPrice_AAZ
ElectricPrice_MMZ

#Create a trigonometric box-cox autoregressive trend seasonality (TBATS) model
ElectricPrice_tbats <- tbats(ElectricPrice_ts)
ElectricPrice_tbats_pred <-forecast(ElectricPrice_tbats, h=360, level=c(0.8, 0.95))
par(mfrow=c(1,1))
plot(ElectricPrice_tbats_pred, xlab="Year", ylab="Predicted Electric Rate")

par(mfrow=c(1,3)) # Lets look at the three models with seasonality on one graph on the same scale
plot(ElectricPrice_AAZ_pred, xlab="Year", ylab="Predicted Electric Rate", ylim=c(0,0.4))
plot(ElectricPrice_MMZ_pred, xlab="Year", ylab="Predicted Electric Rate", ylim=c(0,0.4))
plot(ElectricPrice_tbats_pred, xlab="Year", ylab="Predicted Electric Rate", ylim=c(0,0.4))

# Lets look at what our models actually are -- TBATS
ElectricPrice_tbats

###
### Comparing models -- Time series Cross Validation (Rolling Horizon Holdout)
###

f_AAN  <- function(y, h) forecast(ets(y, model="AAN"), h = h)
errors_AAN <- tsCV(ElectricPrice_ts, f_AAN, h=1, window=60)

f_MMN  <- function(y, h) forecast(ets(y, model="MMN"), h = h)
errors_MMN <- tsCV(ElectricPrice_ts, f_MMN, h=1, window=60)

f_AAA  <- function(y, h) forecast(ets(y, model="AAA"), h = h)
errors_AAA <- tsCV(ElectricPrice_ts, f_AAA, h=1, window=60)

f_MMM  <- function(y, h) forecast(ets(y, model="MMM"), h = h)
errors_MMM <- tsCV(ElectricPrice_ts, f_MMM, h=1, window=60)

par(mfrow=c(1,1)) 
plot(errors_AAN, ylab='tsCV errors')
abline(0,0)
lines(errors_MMN, col="red")
lines(errors_AAA, col="green")
lines(errors_MMM, col="blue")
legend("left", legend=c("CV_error_AAN", "CV_error_MMN","CV_error_AAA","CV_error_MMM"), col=c("black", "red", "green", "blue"), lty=1:4)

mean(abs(errors_AAN/ElectricPrice_ts), na.rm=TRUE)*100
mean(abs(errors_MMN/ElectricPrice_ts), na.rm=TRUE)*100
mean(abs(errors_AAA/ElectricPrice_ts), na.rm=TRUE)*100
mean(abs(errors_MMM/ElectricPrice_ts), na.rm=TRUE)*100

f_TBATS  <- function(y, h) forecast(tbats(y), h = h)
errors_TBATS <- tsCV(ElectricPrice_ts, f_TBATS, h=1, window=60)

plot(errors_AAA, ylab='tsCV errors', col="green")
abline(0,0)
lines(errors_MMM, col="blue")
lines(errors_TBATS, col="gray")
legend("left", legend=c("CV_error_AAA", "CV_error_MMM","CV_error_TBATS"), col=c("green", "blue", "gray"), lty=1:4)

mean(abs(errors_TBATS/ElectricPrice_ts), na.rm=TRUE)*100

# Print the mean and confidence intervals for the MMZ model
ElectricPrice_MMZ_pred

# Export the results out
write.csv(ElectricPrice_MMZ_pred, file = "Predicted Electric Rates.csv") # export the selected model's predictions into a CSV file

