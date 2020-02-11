
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("caret","ROCR","lift","xgboost") #Check, and if needed install the necessary packages

# Load the data, correct mis-classified datafields, fixNAs -- same as you did in the logistic regression file
# To ensure "appled-to-apples" comparisons with logistic regression, use the same training and testing -- the code below only works in the same R session after you've ran the logistic regression code


training.x <-model.matrix(Retained.in.2012.~ ., data = training)
testing.x <-model.matrix(Retained.in.2012.~ ., data = testing)

model_XGboost<-xgboost(data = data.matrix(training.x[,-1]), 
                       label = as.numeric(as.character(training$Retained.in.2012.)), 
                       eta = 0.1,       # hyperparameter: learning rate 
                       max_depth = 20,  # hyperparameter: size of a tree in each boosting iteration
                       nround=50,       # hyperparameter: number of boosting iterations  
                       objective = "binary:logistic"
                       )

XGboost_prediction<-predict(model_XGboost,newdata=testing.x[,-1], type="response") #Predict classification (for confusion matrix)
confusionMatrix(as.factor(ifelse(XGboost_prediction>0.6073,1,0)),testing$Retained.in.2012.,positive="1") #Display confusion matrix

####ROC Curve
XGboost_pred_testing <- prediction(XGboost_prediction, testing$Retained.in.2012.) #Calculate errors
XGboost_ROC_testing <- performance(XGboost_pred_testing,"tpr","fpr") #Create ROC curve data
plot(XGboost_ROC_testing) #Plot ROC curve

####AUC
auc.tmp <- performance(XGboost_pred_testing,"auc") #Create AUC data
XGboost_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
XGboost_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(XGboost_prediction, testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

