# this script is a basic intro to regression analysis for T1
# data used: "T1_Sales_Data_part1.csv"

# load the data "T1_Sales_Data_part1.csv"
SalesData <- read.csv(file.choose())

# another way: SalesData <- read.csv("T1_Sales_Data_part1.csv") 
# provided file is in your working directory

# ------------------------------------------------------------------------------------
#                               explore the data
# ------------------------------------------------------------------------------------

# make sure that the field types are interpreted correctly (as numbers/integers, factors, etc.)
str(SalesData)

SalesData$SKU <- as.factor(SalesData$SKU)

# let's get summary of data
summary(SalesData)

# let's look at distribution of a particular variable
hist(SalesData$Sales)


# ------------------------------------------------------------------------------------
#                           single-variable regression
# ------------------------------------------------------------------------------------

# -----------------------------
#     model estimation
# -----------------------------

# plot the data for visual inspection
plot(Sales ~ Test, data = SalesData , xlim = c(0,30)) 

# run regression: Y=market sales, X=test sales
Model_single <- lm(Sales ~ Test, data = SalesData) 

# get summary of the model
summary(Model_single) 

# add fitted line to plot
abline(Model_single, col = "red", lwd = 3)


# -----------------------------
#     model diagnostics
# -----------------------------

# first, extract residuals
Model_single_residuals <- resid(Model_single) 

# plot residuals vs X for visual inspection
plot(Model_single_residuals ~ SalesData$Test)

# add a horizontal line to plot at 0
abline(0,0)

# plot residuals vs Y for visual inspection
plot(Model_single_residuals ~ SalesData$Sales) 

# add a horizontal line to plot at 0
abline(0,0)

par(mfrow=c(1,4)) # This command sets the plot window to show 1 row of 4 plots
plot(Model_single) # check the model using diagnostic plots

# -----------------------------
#     model prediction
# -----------------------------

# Create a data frame with one case for test sales = 10
new_data <- data.frame("Test" = 10) 

# check the data
str(new_data)

# predict market sales if test sales=10
Model_single_prediction <- predict(Model_single, newdata=new_data)
Model_single_prediction

# ------------------------------------------------------------------------------------
#                           multi-variable regression
# ------------------------------------------------------------------------------------

# -----------------------------
#     model estimation
# -----------------------------

# let's add another regressor SKU: Y=market sales, X1=test sales, X2=SKU
Model_multiple <- lm(Sales ~ Test + SKU, data = SalesData) 

# get summary of the model
summary(Model_multiple) 

# -----------------------------
#     model diagnostics
# -----------------------------

# extract residuals
Model_multiple_residuals <- resid(Model_multiple)

par(mfrow=c(1,1))

# plot residuals vs X for visual inspection
plot(Model_multiple_residuals ~ SalesData$Test)

# plot a horizontal line
abline(0,0) 

# plot residuals vs Y for visual inspection
plot(Model_multiple_residuals ~ SalesData$Sales) 

# plot a horizontal line
abline(0,0)

par(mfrow=c(1,4))
plot(Model_multiple) 

# -----------------------------
#     model prediction
# -----------------------------

# Create a data frame with one case for test sales = 10 and SKU = "Bear"
new_data_multiple = data.frame("Test"= 10, SKU = "Bear") 

# predict market sales if test sales=10 and the SKU is a "Bear"
predict(Model_multiple, newdata=new_data_multiple) 

# compare to previous prediction
Model_single_prediction

# which one do we trust more?
