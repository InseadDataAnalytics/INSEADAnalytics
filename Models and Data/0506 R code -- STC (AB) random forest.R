
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("caret","ROCR","lift","randomForest") #Check, and if needed install the necessary packages

# Load the data, correct mis-classified datafields, fixNAs -- same as you did in the logistic regression file
# To ensure "appled-to-apples" comparisons with logistic regression, use the same training and testing -- the code below only works in the same R session after you've ran the logistic regression code


model_forest <- randomForest(Retained.in.2012.~ ., data=training, 
                             type="classification",
                             importance=TRUE,
                             ntree = 500,           # hyperparameter: number of trees in the forest
                             mtry = 10,             # hyperparameter: number of random columns to grow each tree
                             nodesize = 10,         # hyperparameter: min number of datapoints on the leaf of each tree
                             maxnodes = 10,         # hyperparameter: maximum number of leafs of a tree
                             cutoff = c(0.5, 0.5)   # hyperparameter: how the voting works; (0.5, 0.5) means majority vote
                             ) 

plot(model_forest)  # plots error as a function of number of trees in the forest; use print(model_forest) to print the values on the plot

varImpPlot(model_forest) # plots variable importances; use importance(model_forest) to print the values

###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",500)
forest_classification[forest_probabilities[,2]<0.5]="0" #Predict classification using 0.5 threshold. Why 0.5 and not 0.6073? Use the same as in cutoff above
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Retained.in.2012., positive="1") #Display confusion matrix. Note, confusion matrix actually displays a better accuracy with threshold of 50%

#There is also a "shortcut" forest_prediction<-predict(model_forest,newdata=testing, type="response") 
#But it by default uses threshold of 50%: actually works better (more accuracy) on this data


####ROC Curve
forest_ROC_prediction <- prediction(forest_probabilities[,2], testing$Retained.in.2012.) #Calculate errors
forest_ROC <- performance(forest_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(forest_ROC) #Plot ROC curve

####AUC (area under curve)
AUC.tmp <- performance(forest_ROC_prediction,"auc") #Create AUC data
forest_AUC <- as.numeric(AUC.tmp@y.values) #Calculate AUC
forest_AUC #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(forest_probabilities[,2],  testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

### An alternative way is to plot a Lift curve not by buckets, but on all data points
Lift_forest <- performance(forest_ROC_prediction,"lift","rpp")
plot(Lift_forest)
