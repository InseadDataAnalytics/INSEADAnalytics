
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("caret","partykit","ROCR","lift","rpart","e1071")

# Load the data, correct mis-classified datafields, fixNAs -- same as you did in the logistic regression file
# To ensure "appled-to-apples" comparisons with logistic regression, use the same training and testing -- the code below only works in the same R session after you've ran the logistic regression code

# There are two families of CART algorithms: conditoinal interence trees (ctree function; caret package) and recursive partitioning (rpart function; partykit package)

###
### CTREE 
###

ctree_tree<-ctree(Retained.in.2012.~.,data=training) #Run ctree on training data
plot(ctree_tree, gp = gpar(fontsize = 8)) #Plotting the tree (adjust fontsize if needed)

ctree_probabilities<-predict(ctree_tree,newdata=testing,type="prob") #Predict probabilities
ctree_classification<-rep("1",500)
ctree_classification[ctree_probabilities[,2]<0.6073]="0" #Predict classification using 0.6073 threshold. Why 0.6073 - that's the average probability of being retained in the data. An alternative code: logistic_classification <- as.integer(logistic_probabilities > mean(testing$Retained.in.2012. == "1"))
ctree_classification<-as.factor(ctree_classification)

###Confusion matrix  
confusionMatrix(ctree_classification,testing$Retained.in.2012.,positive = "1")

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
plotLift(ctree_probabilities[,2],  testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
### RPART
###

# The rpart method has an important "complexity parameter", cp, which determines how big the tree is.  

CART_cp = rpart.control(cp = 0.0005) #set cp to a small number to "grow" a large tree

rpart_tree<-rpart(Retained.in.2012.~.,data=training, method="class", control=CART_cp) #"Grow" a tree on training data

prunned_rpart_tree<-prune(rpart_tree, cp=0.007) #Prun the tree. Play with cp to see how the resultant tree changes
plot(as.party(prunned_rpart_tree), type = "extended",gp = gpar(fontsize = 7)) #Plotting the tree (adjust fontsize if needed)

# Understand the relationship between the cross-validated error, size of the tree and cp.
plotcp(rpart_tree) # Use printcp(rpart_tree) to print the values. As a rule of thumb pick up the largest cp which does not give a substantial drop in error

rpart_prediction_class<-predict(prunned_rpart_tree,newdata=testing, type="class") #Predict classification (for confusion matrix)
confusionMatrix(rpart_prediction_class,testing$Retained.in.2012.,positive = "1") #Display confusion matrix

rpart_probabilities_testing <-predict(prunned_rpart_tree,newdata=testing,type = "prob") #Predict probabilities
rpart_pred_testing <- prediction(rpart_probabilities_testing[,2], testing$Retained.in.2012.) #Calculate errors
rpart_ROC_testing <- performance(rpart_pred_testing,"tpr","fpr") #Create ROC curve data
plot(rpart_ROC_testing) #Plot ROC curve

auc.tmp <- performance(rpart_pred_testing,"auc") #Create AUC data
rpart_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
rpart_auc_testing #Display AUC value

plotLift(rpart_prediction_class,  testing$Retained.in.2012., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

