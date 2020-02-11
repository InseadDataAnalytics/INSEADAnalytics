
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") #Check, and if needed install the necessary packages

STCdata_A<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE) # Load the datafile to R

str(STCdata_A) # See if some data types were misclassified when importing data from CSV

# Fixing incorrectly classified data types:
STCdata_A$From.Grade <- as.factor(STCdata_A$From.Grade)
STCdata_A$To.Grade <- as.factor(STCdata_A$To.Grade)
STCdata_A$Is.Non.Annual. <- as.factor(STCdata_A$Is.Non.Annual.)
STCdata_A$Days <- as.factor(STCdata_A$Days)
#STCdata_A$Departure.Date <- as.Date(STCdata_A$Departure.Date, origin="1899-12-30")
#STCdata_A$Return.Date <- as.Date(STCdata_A$Return.Date, origin="1899-12-30")
#STCdata_A$Deposit.Date <- as.Date(STCdata_A$Deposit.Date, origin="1899-12-30")
#STCdata_A$Early.RPL <- as.Date(STCdata_A$Early.RPL, origin="1899-12-30")
#STCdata_A$Latest.RPL <- as.Date(STCdata_A$Latest.RPL, origin="1899-12-30")
#STCdata_A$Initial.System.Date <- as.Date(STCdata_A$Initial.System.Date, origin="1899-12-30")
STCdata_A$CRM.Segment <- as.factor(STCdata_A$CRM.Segment)
STCdata_A$Parent.Meeting.Flag <- as.factor(STCdata_A$Parent.Meeting.Flag)
STCdata_A$MDR.High.Grade <- as.factor(STCdata_A$MDR.High.Grade)
STCdata_A$School.Sponsor <- as.factor(STCdata_A$School.Sponsor)
STCdata_A$NumberOfMeetingswithParents <- as.factor(STCdata_A$NumberOfMeetingswithParents)
STCdata_A$SingleGradeTripFlag <- as.factor(STCdata_A$SingleGradeTripFlag)
#STCdata_A$FirstMeeting <- as.Date(STCdata_A$FirstMeeting, origin="1899-12-30")
#STCdata_A$LastMeeting <- as.Date(STCdata_A$LastMeeting, origin="1899-12-30")
STCdata_A$Retained.in.2012. <- as.factor(STCdata_A$Retained.in.2012.)

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

STCdata_A<-fixNAs(STCdata_A) #Apply fixNAs function to the data to fix missing values

table(STCdata_A$Group.State)# check for rare categories

# Create another a custom function to combine rare categories into "Other."+the name of the original variavle (e.g., Other.State)
# This function has two arguments: the name of the dataframe and the count of observation in a category to define "rare"
combinerarecategories<-function(data_frame,mincount){ 
  for (i in 1 : ncol(data_frame)){
    a<-data_frame[,i]
    replace <- names(which(table(a) < mincount))
    levels(a)[levels(a) %in% replace] <-paste("Other",colnames(data_frame)[i],sep=".")
    data_frame[,i]<-a }
  return(data_frame) }


#Apply combinerarecategories function to the data and then split it into testing and training data.

STCdata_A<-combinerarecategories(STCdata_A,20) #combine categories with <20 values in STCdata into "Other"

set.seed(77850) #set a random number generation seed to ensure that the split is the same everytime
inTrain <- createDataPartition(y = STCdata_A$Retained.in.2012.,
                               p = 1888/2389, list = FALSE)
training <- STCdata_A[ inTrain,]
testing <- STCdata_A[ -inTrain,]

# Select the variables to be included in the "base-case" model
# First include all variables use glm(Retained.in.2012.~ ., data=training, family="binomial"(link="logit")) Then see which ones have "NA" in coefficients and remove those

model_logistic<-glm(Retained.in.2012.~ Special.Pay + 
                      To.Grade + Group.State + Is.Non.Annual. +
                      Tuition + FRP.Active + FRP.Cancelled + FRP.Take.up.percent. + 
                      Cancelled.Pax + Total.Discount.Pax + Initial.System.Date + 
                      Poverty.Code + CRM.Segment + School.Type + Parent.Meeting.Flag + 
                      MDR.Low.Grade + MDR.High.Grade + Total.School.Enrollment + 
                      EZ.Pay.Take.Up.Rate + School.Sponsor +  
                      SPR.New.Existing + FPP + FirstMeeting + LastMeeting + 
                      DifferenceTraveltoFirstMeeting + DepartureMonth  + MajorProgramCode + SingleGradeTripFlag + 
                      FPP.to.School.enrollment + FPP.to.PAX + SchoolSizeIndicator, data=training, family="binomial"(link="logit"))

summary(model_logistic) 

# to add surrogates paste this to the list of variables; note, it will run quite a bit slower
#Special.Pay_surrogate + Early.RPL_surrogate + Latest.RPL_surrogate + 
#Initial.System.Date_surrogate + CRM.Segment_surrogate + MDR.High.Grade_surrogate + 
#Total.School.Enrollment_surrogate + FirstMeeting_surrogate + 
#LastMeeting_surrogate + DifferenceTraveltoFirstMeeting_surrogate + 
#DifferenceTraveltoLastMeeting_surrogate + FPP.to.School.enrollment_surrogate

##The model clearly has too many variables, most of which are insignificant 

## Stepwise regressions. There are three aproaches to runinng stepwise regressions: backward, forward and "both"
## In either approach we need to specify criterion for inclusion/exclusion. Most common ones: based on information criterion (e.g., AIC) or based on significance  
model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise
summary(model_logistic_stepwiseAIC) 

par(mfrow=c(1,4))
plot(model_logistic_stepwiseAIC) #Error plots: similar nature to lm plots
par(mfrow=c(1,1))

###Finding predicitons: probabilities and classification
logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=testing,type="response") #Predict probabilities
logistic_classification<-rep("1",500)
logistic_classification[logistic_probabilities<0.6073]="0" #Predict classification using 0.6073 threshold. Why 0.6073 - that's the average probability of being retained in the data. An alternative code: logistic_classification <- as.integer(logistic_probabilities > mean(testing$Retained.in.2012. == "1"))
logistic_classification<-as.factor(logistic_classification)

###Confusion matrix  
confusionMatrix(logistic_classification,testing$Retained.in.2012.,positive = "1") #Display confusion matrix

####ROC Curve
logistic_ROC_prediction <- prediction(logistic_probabilities, testing$Retained.in.2012.)
logistic_ROC <- performance(logistic_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(logistic_ROC) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(logistic_ROC_prediction,"auc") #Create AUC data
logistic_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
logistic_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(logistic_probabilities, testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

