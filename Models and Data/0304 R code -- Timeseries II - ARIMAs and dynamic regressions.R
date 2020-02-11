#install.packages("forecast") #-- do this only once 
#install.packages("fpp") #-- do this only once 
#These packages are from the "Forecasting Principles and Practice" - excellent and free book: https://www.otexts.org/fpp
library(forecast)
library(fpp)

###
### DIFFERENCING and ARIMA
###

# we will use a10 dataset (comes with fpp book -- sales of antidiabetic drug)

# Explore the data, log-transform and year-over-year differences
View(a10)

par(mfrow=c(1,3))
plot(a10, xlab="Year",
     ylab="A10 sales")
plot(log(a10), xlab="Year",
     ylab="log A10 sales")
plot(diff(log(a10),12), xlab="Year",
     ylab="Annual change in monthly log A10 sales")

# decomposition 
fit <- stl(log(a10), t.window=12, s.window="periodic", robust=TRUE)
plot(fit)

#a10 dataset from fpp - sales of antidiabetic drug in Australia
par(mfrow=c(1,2))
Acf(diff(log(a10),12)) # auto-correlation function
Pacf(diff(log(a10),12)) # partial auto-correlation function

# fit ARIMA models

# non-seasonal first
fit <- auto.arima(a10,seasonal=FALSE)
fit

#check residuals for autocorrelation
par(mfrow=c(1,1))
Acf(residuals(fit))

# and now seasonal
fit <- auto.arima(a10,seasonal=TRUE)
fit

plot(forecast(fit,60)) #make a prediction for 5 years (60 months)

###
### ARIMA with regressors ("dynamic regression")
###

# with insurance and advertising data (also part of FPP)
plot(insurance, main="Insurance advertising and quotations", xlab="Year")
View(insurance)

# Lagged predictors. Test 0, 1, 2 or 3 lags.
Advert <- cbind(insurance[,2],
                c(NA,insurance[1:39,2]),
                c(NA,NA,insurance[1:38,2]),
                c(NA,NA,NA,insurance[1:37,2]))
colnames(Advert) <- paste("AdLag",0:3,sep="")
Advert


# Choose optimal lag length for advertising based on AIC
# Restrict data so models use same fitting period
fit1 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1], d=0)
fit2 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:2], d=0)
fit3 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:3], d=0)
fit4 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:4], d=0)

AIC(fit1)
AIC(fit2)
AIC(fit3)
AIC(fit4)

#Best fit (as per AIC) is with all data (1:2), so the final model becomes
fit <- auto.arima(insurance[,1], xreg=Advert[,1:2], d=0)
fit

# forecast insurance quotes with advertising = 10
fc10 <- forecast(fit, xreg=cbind(rep(10,20),c(Advert[40,1],rep(10,19))), h=20)
plot(fc10, main="Forecast quotes with advertising set to 10", ylab="Quotes")

# see how forecasts with advertising = 10 will differ from advertising = 5
par(mfrow=c(1,2))
plot(fc10, main="Forecast quotes with advertising set to 10", ylab="Quotes")

fc6 <- forecast(fit, xreg=cbind(rep(6,20),c(Advert[40,1],rep(6,19))), h=20)
plot(fc6, main="Forecast quotes with advertising set to 6", ylab="Quotes")