
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not
pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071", "corrplot") #Check, and if needed install the necessary packages
install.packages("caret",
                 repos = "http://cran.r-project.org", 
                 dependencies = c("Depends", "Imports", "Suggests"))

hrdata<-read.csv(file.choose()) # Load the datafile to R

#Keep a copy of the original data in a separate data frame, in case I do something stupid further down
hrdataOrig<-hrdata

# Do correlation
sapply(hrdata, is.numeric)
hrdata2 <- hrdata[, sapply(hrdata, is.numeric)]
M <- cor(hrdata2)
corrplot(M, method = "circle")

#drop columns that are not adding value (?s in the correlation matrix): employee count and standard hours, as they're the same value for all employees
drops <- c("StandardHours","EmployeeCount")
hrdata_subset <- hrdata[ , !(names(hrdata) %in% drops)]

# Do correlation again
sapply(hrdata_subset, is.numeric)
hrdata2 <- hrdata_subset[, sapply(hrdata_subset, is.numeric)]
M <- cor(hrdata2)
corrplot(M, method = "circle")

# Change boolean columns from strings into 1s and 0s
hrdata_subset$Attrition <- ifelse(hrdata_subset$Attrition %in% c("Yes"), 1, 0)
hrdata_subset$Over18 <- ifelse(hrdata_subset$Over18 %in% c("Y"), 1, 0)
hrdata_subset$OverTime <- ifelse(hrdata_subset$OverTime %in% c("Yes"), 1, 0)

# Fixing incorrectly classified data types:
hrdata_subset$BusinessTravel <- as.factor(hrdata$BusinessTravel)
hrdata_subset$Department <- as.factor(hrdata$Department)
hrdata_subset$EducationField <- as.factor(hrdata$EducationField)
hrdata_subset$Gender <- as.factor(hrdata$Gender)
hrdata_subset$JobRole <- as.factor(hrdata$JobRole)
hrdata_subset$MaritalStatus <- as.factor(hrdata$MaritalStatus)

# Create a custom function to fix missing values ("NAs") and preserve the NA info as surrogate variables
fixNAs<-function(data_frame){
  # Define reactions to NAs
  integer_reac<-0
  factor_reac<-"FIXED_NA"
  character_reac<-"FIXED_NA"
  date_reac<-as.Date("1900-01-01")
  # Loop through columns in the data frame and depending on which class the variable is, apply the defined reaction and create a surrogate
  
  for (i in 1 : ncol(data_frame)){
    if (class(data_frame[,i]) %in% c("numeric","integer")) {
      if (any(is.na(data_frame[,i]))){
        data_frame[,paste0(colnames(data_frame)[i],"_surrogate")]<-
          as.factor(ifelse(is.na(data_frame[,i]),"1","0"))
        data_frame[is.na(data_frame[,i]),i]<-integer_reac
      }
    } else
      if (class(data_frame[,i]) %in% c("factor")) {
        if (any(is.na(data_frame[,i]))){
          data_frame[,i]<-as.character(data_frame[,i])
          data_frame[,paste0(colnames(data_frame)[i],"_surrogate")]<-
            as.factor(ifelse(is.na(data_frame[,i]),"1","0"))
          data_frame[is.na(data_frame[,i]),i]<-factor_reac
          data_frame[,i]<-as.factor(data_frame[,i])
          
        } 
      } else {
        if (class(data_frame[,i]) %in% c("character")) {
          if (any(is.na(data_frame[,i]))){
            data_frame[,paste0(colnames(data_frame)[i],"_surrogate")]<-
              as.factor(ifelse(is.na(data_frame[,i]),"1","0"))
            data_frame[is.na(data_frame[,i]),i]<-character_reac
          }  
        } else {
          if (class(data_frame[,i]) %in% c("Date")) {
            if (any(is.na(data_frame[,i]))){
              data_frame[,paste0(colnames(data_frame)[i],"_surrogate")]<-
                as.factor(ifelse(is.na(data_frame[,i]),"1","0"))
              data_frame[is.na(data_frame[,i]),i]<-date_reac
            }
          }  
        }       
      }
  } 
  return(data_frame) 
}

# Create another a custom function to combine rare categories into "Other."+the name of the original variavle (e.g., Other.State)
# This function has two arguments: the name of the dataframe and the count of observation in a category to define "rare"
combinerarecategories<-function(data_frame,mincount){ 
  for (i in 1 : ncol(data_frame)){
    a<-data_frame[,i]
    replace <- names(which(table(a) < mincount))
    levels(a)[levels(a) %in% replace] <-paste("Other",colnames(data_frame)[i],sep=".")
    data_frame[,i]<-a }
  return(data_frame) }


#Apply the fixNAs and combinerarecategories functions to the data and then split it into testing and training data.
# newData<-getNoConsumption(hrdata)
# str(newData)
# hrdata_subset2<-fixNAs(hrdata_subset2)
# hrdata_subset2<-combinerarecategories(hrdata_subset2,10) #combine categories with <10 values in hrdata_subset2 into "Other"

set.seed(77850) #set a random number generation seed to ensure that the split is the same everytime
inTrain <- createDataPartition(y = hrdata_subset$Attrition,p = 1176/1470, list = FALSE)
training <- hrdata_subset[ inTrain,]
testing <- hrdata_subset[ -inTrain,]

# Select the variables to be included in the "base-case" model
# First include all variables use glm(Retained.in.2012.~ ., data=training, family="binomial"(link="logit")) Then see which ones have "NA" in coefficients and remove those

#model_logistic<-glm(default.payment.next.month~ LIMIT_BAL + SEX + EDUCATION + MARRIAGE + AGE + PAY_0 + PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6 + BILL_AMT1 + BILL_AMT2 + BILL_AMT3 + BILL_AMT4 + BILL_AMT5 + BILL_AMT6 + PAY_AMT1 + PAY_AMT, data=training, family="binomial"(link="logit"))
model_logistic<-glm(Attrition~. , data=training, family="binomial"(link="logit"))
summary(model_logistic) 

## Stepwise regressions. There are three aproaches to runinng stepwise regressions: backward, forward and "both"
## In either approach we need to specify criterion for inclusion/exclusion. Most common ones: based on information criterion (e.g., AIC) or based on significance  
model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise
summary(model_logistic_stepwiseAIC) 

par(mfrow=c(1,4))
plot(model_logistic_stepwiseAIC) #Error plots: similar nature to lm plots
par(mfrow=c(1,1))

model_logistic_FINAL<-model_logistic_stepwiseAIC #Final model

###Finding predicitons on Testing set
logistic_probabilities_testing<-predict(model_logistic_FINAL,newdata=testing,type="response") #Predict probabilities
logistic_pred_testing<-rep("1",294)
logistic_pred_testing[logistic_probabilities_testing<0.16]="0" #Predict classification
confusionMatrix(logistic_pred_testing,testing$default.payment.next.month) #Display confusion matrix

####ROC Curve
logistic_ROC_pred <- prediction(logistic_probabilities_testing, testing$default.payment.next.month)
logistic_ROC_testing <- performance(logistic_ROC_pred,"tpr","fpr") #Create ROC curve data
plot(logistic_ROC_testing) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(logistic_ROC_pred,"auc") #Create AUC data
logistic_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
logistic_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(logistic_probabilities_testing, testing$default.payment.next.month, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

