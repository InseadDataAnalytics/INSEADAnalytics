###
### Sarah Gets a Diamond price prediction model in R -- just six lines of code
###

diamond.data<-read.csv(file.choose(), header=TRUE, sep=",") #load the data into the diamond.data dataframe

diamond.data.training<-subset(diamond.data, ID<=6000) #separate ID 1...6000 into "training"
diamond.data.prediction<-subset(diamond.data, ID>=6001) #separate ID 6001...9142 into "prediction" 

fit<-lm(Price~Carat.Weight+Cut+Color+Clarity+Polish+Symmetry+Report, data=diamond.data.training) #run a multiple linear regression model (lm) on the training data, call it "fit" 

predicted.prices<-predict(fit, diamond.data.prediction) #use the "fit" model to predict prices for the prediction data

write.csv2(predicted.prices, file = "Predicted Diamond Prices.csv") # export the predicted prices into a CSV file

###
### Lets take it step-by-step and learn a few more helpful commands
###


str(diamond.data) #show the structure of (data types in) the diamond.data dataframe
head(diamond.data, 4) #show the first 4 rows in the diamond.data dataframe
tail(diamond.data,4) #show the last 4 rows in the diamond.data dataframe

summary(diamond.data) #show summary statistics of the diamond.data dataframe

plot(Price ~ Carat.Weight, data=diamond.data) #plot of price vs carat weight 
plot(diamond.data$Price ~ diamond.data$Carat.Weight) #same thing, note an alternative way to call datafields 

hist(diamond.data$Carat.Weight) #histogram of carat weights

plot(predicted.prices ~ diamond.data.prediction$Carat.Weight) #plot predicted prices vs carat weight for visual inspection
abline(0,0) #plot the horisontal line

summary(fit) # summary of the "fit" regression model

par(mfrow=c(1,4)) # this command sets the plot window to show 1 row of 4 plots
plot(fit) #diagnostic plots for the "fit" model -- will discuss them in class

###
### Log-log model -- minimal changes to the previous code
###

fit.log<-lm(log(Price)~log(Carat.Weight)+Cut+Color+Clarity+Polish+Symmetry+Report, data=diamond.data.training) #added "log()" for price and carat
summary(fit.log)

predicted.prices.log<-exp(predict(fit.log, diamond.data.prediction)) # predicting prices. Note, the fit.log model predicts the log of price, hence add exp() 

par(mfrow=c(1,1))
plot(predicted.prices.log ~ diamond.data.prediction$Carat.Weight) 
abline(0,0)

par(mfrow=c(1,4)) 
plot(fit.log) 

write.csv2(predicted.prices.log, file = "Predicted Diamond Prices LOG.csv")

###
### Assessing the quality of the model -- cross-fold validation
###

diamond.data.testing<-subset(diamond.data, (ID>=5001 & ID<=6000)) #withold 1000 datapoints into a "testing" data
diamond.data.training<-subset(diamond.data, ID<=5000) #redefine the training data

fit<-lm(Price~Carat.Weight+Cut+Color+Clarity+Polish+Symmetry+Report, data=diamond.data.training) #build a model on training data
predicted.prices.testing<-predict(fit, diamond.data.testing) #predict the prices of the 1000 diamonds left for testing the model

percent.errors <- abs((diamond.data.testing$Price-predicted.prices.testing)/diamond.data.testing$Price)*100 #calculate absolute percentage errors
mean(percent.errors) #display Mean Absolute Percentage Error (MAPE)

# repeat the same for the log model 
fit.log<-lm(log(Price)~log(Carat.Weight)+Cut+Color+Clarity+
              Polish+Symmetry+Report, data=diamond.data.training)
predicted.prices.testing.log<-exp(predict(fit.log, diamond.data.testing))

percent.errors.log <- abs((diamond.data.testing$Price-predicted.prices.testing.log)/diamond.data.testing$Price)*100
mean(percent.errors.log) 
# which model is better?
# more advanced approach: automatic "rotation" of the training/testing split to obtain multiple estimates of the expected error; rms package

###
### Interactions 
###

fit.log.i<-lm(log(Price)~log(Carat.Weight)*Color+Cut+Color+Clarity+Polish+Symmetry+Report, data=diamond.data.training) # the "*" sign calls the interaction between the carat and color variables
summary(fit.log.i)

par(mfrow=c(1,4)) 
plot(fit.log.i)

predicted.prices.testing.log.i<-exp(predict(fit.log.i, diamond.data.testing))

percent.errors.log.i <- abs((diamond.data.testing$Price-predicted.prices.testing.log.i)/diamond.data.testing$Price)*100
mean(percent.errors.log.i) #is this model better than previous ones? 

predicted.prices.log.i<-exp(predict(fit.log.i, diamond.data.prediction))
write.csv2(predicted.prices.log.i, file = "Predicted Diamond Prices LOG INTERACTION.csv") # export the predicted prices into a CSV file

###
### OPTIONAL: advanced plotting -- ggplot library (a top-2 "must learn" functionality in R)
###

#install.packages("ggplot2") # installing a package -- do this only once, the first time you plan to use it
library(ggplot2) # calling a library from the package -- do this every time you plan on using it

ggplot(diamond.data.training, aes(x=Carat.Weight, y=Price, shape=Cut, color=Color)) +  geom_point(size=3) #create a Tableau-like plot of price vs carat with color representing "color" and point shapes representing cut

heatmap<-ggplot(diamond.data.training, aes(Carat.Weight, Price))  + geom_hex(bins=50) +scale_fill_gradientn(colours = rainbow(10) )+ggtitle("Heatmap: Price vs Carat Weight")+ theme(aspect.ratio = 0.8)+ labs(x = "Carat Weight", y = "Price")+geom_density2d()
print(heatmap) # create and print a heat-map: a graph displaying the density of data (why might we want that?)

###
### OPTIONAL: variable Selection (Forward/Backward/Stepwise regression)
###

fit.log.ii<-lm(log(Price)~log(Carat.Weight)*Color*Cut + Cut*Color*Clarity+
                        Cut*Color*Clarity*Polish+Symmetry+Report, data=diamond.data.testing)
summary(fit.log.ii)

fit.log.step<-step(lm(log(Price)~log(Carat.Weight)*Color*Cut + Cut*Color*Clarity+
                        Cut*Color*Clarity*Polish+Symmetry+Report, data=diamond.data.testing),direction="backward")
summary(fit.log.step)

fit.log.step<-step(lm(log(Price)~log(Carat.Weight)*Color*Cut + Cut*Color*Clarity+
                        Cut*Color*Clarity*Polish+Symmetry+Report, data=diamond.data.testing),direction="both")
summary(fit.log.step)
# more advanced methods: (1) stepwise methods based on Akaike Information Criterion (AIC), stepAIC command; (2) LASSO, Ridge methods, adding a penalty term for "additional" variables

###
### Other considerations and data pre-processing
###

# There are categories with very few observations: those need to be combined, e.g., levels(diamond.data$Clarity)[levels(diamond.data$Clarity)%in%c("FL","IF")] <- "FL/IF" #see also combine_factors function in reshape package
# Categories with most observations as reference category, e.g., diamond.data$Cut<-relevel(diamond.data$Cut, ref="Ideal") 
# Variance Inflation Factor (vif) is too high (meaning some independent variables are actually correlated); vif-based stepwise variable selection can be uses, e.g., see https://beckmw.wordpress.com/2013/02/05/collinearity-and-stepwise-vif-selection/  

