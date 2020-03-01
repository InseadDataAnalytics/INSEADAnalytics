##plan for tutorial 2 FBL 18D

if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071",'dplyr',
               "partykit","rpart") #Check, and if needed install the necessary packages


#/Users/varun/Dropbox (KG Lab)/Developing the course/Tutorial 2/0506 STC(A) data_numerical dates.csv

STCdata_A<-read.csv(file.choose()) # Load the datafile to R

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

STCdata_A<-fixNAs(STCdata_A)
STCdata_A<-combinerarecategories(STCdata_A,10) #combine categories with <10 values in STCdata into "Other"

set.seed(77850) #set a random number generation seed to ensure that the split is the same everytime
inTrain <- createDataPartition(y = STCdata_A$Retained.in.2012.,
                               p = 1888/2389, list = FALSE)
training <- STCdata_A[ inTrain,]
testing <- STCdata_A[ -inTrain,]

# CTREE 

ctree_tree<-ctree(Retained.in.2012.~.,data=training) #Run ctree on training data
plot(ctree_tree, gp = gpar(fontsize = 8)) #Plotting the tree (adjust fontsize if needed)

ctree_prediction<-predict(ctree_tree,newdata=testing, type="response") #Predict classification (for confusion matrix); default with ctree
confusionMatrix(ctree_prediction,testing$Retained.in.2012.) #Display confusion matrix

####ROC Curve
ctree_probabilities_testing <-predict(ctree_tree,newdata=testing,type = "prob") #Predict probabilities
ctree_pred_testing <- prediction(ctree_probabilities_testing[,2], testing$Retained.in.2012.) #Calculate errors
ctree_ROC_testing <- performance(ctree_pred_testing,"tpr","fpr") #Create ROC curve data
plot(ctree_ROC_testing) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(ctree_pred_testing,"auc") #Create AUC data
ctree_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
ctree_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(ctree_prediction,  testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart


##now we have access to a new dataset that gives us more information!

# Load the new datafile to R

STCdata_extra<-read.csv(file.choose()) 

# See if some data types were misclassified 
# when importing data from CSV
str(STCdata_extra) 

#change the date formats
STCdata_extra$X...3.FPP.Date <- as.factor(as.Date(STCdata_extra$X...3.FPP.Date, 
                                                  origin="1899-12-30"))
STCdata_extra$X...10.FPP.Date <- as.factor(as.Date(STCdata_extra$X...10.FPP.Date, 
                                                   origin="1899-12-30"))
STCdata_extra$X...20.FPP.Date <- as.factor(as.Date(STCdata_extra$X...20.FPP.Date, 
                                                   origin="1899-12-30"))
STCdata_extra$X...35.FPP.Date <- as.factor(as.Date(STCdata_extra$X...35.FPP.Date, 
                                                   origin="1899-12-30"))
str(STCdata_extra) 

##fixing the missing values
STCdata_extra = fixNAs(STCdata_extra)

##let's engineer some new features
##suggestions??

# merge the data
STCdata_merged = merge(STCdata,
                       STCdata_extra,
                       by = 'ID')

# Trim training to few hundred datapoints for things to run faster
set.seed(77850)
inTrain <- createDataPartition(y = STCdata_merged$Retained.in.2012.,
                               p = 888/2389, list = FALSE)
training <- STCdata[ inTrain,]
testing <- STCdata[ -inTrain,]


# write a new formula with new variables

# CTREE 

ctree_tree<-ctree(Retained.in.2012.~.,
                  data=training) #Run ctree on training data

# extree_data(Retained.in.2012.~.,
#   data=training) #Run ctree on training data

#Plotting the tree (adjust fontsize if needed)
plot(ctree_tree, 
     gp = gpar(fontsize = 8)) 


ctree_prediction<-predict(ctree_tree,newdata=testing, 
                          type="response") #Predict classification (for confusion matrix); default with ctree
#Display confusion matrix
confusionMatrix(ctree_prediction,testing$Retained.in.2012.) 


# rerun step-wise AIC

# Make predictions

# Compare against previous accuracy



