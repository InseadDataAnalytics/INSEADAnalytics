if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

credit_data_24000<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE) #Load the data
new_applicants<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE) #Load the new applications

str(credit_data_24000) #Look at the structure of the data

credit_data_24000$default_0<-as.factor(credit_data_24000$default_0) #Redefine default_0 as a categorical variable

#separate 1000 datapoints into a testing dataset to decide on who to give loans to
training<-subset(credit_data_24000,ID<=23000)
testing<-subset(credit_data_24000,ID>23000)

###
### With CART
### 

pacman::p_load("caret","partykit","ROCR","lift","rpart","e1071")

ctree_tree<-ctree(default_0~. -ID,data=training) #Run ctree on training data
ctree_probabilities<-predict(ctree_tree,newdata=testing) #Predict probabilities on the testing data
write.csv(ctree_probabilities, file="predicted_default_probs_ctree_testing.csv") #Export testing data predictions (for Excel analyses)

ctree_probabilities<-predict(ctree_tree,newdata=new_applicants) #Predict probabilities for new applications
write.csv(ctree_probabilities, file="predicted_default_probs_ctree_new_applicants.csv") #Export predictions

#to view confusion matrix on testing
ctree_probabilities<-predict(ctree_tree,newdata=testing,type="prob")
ctree_classification<-rep("1",1000)
ctree_classification[ctree_probabilities[,2]<0.3]="0" 
ctree_classification<-as.factor(ctree_classification)
confusionMatrix(ctree_classification,testing$default_0,positive = "1")

###
### With Logistic Regression 
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

model_logistic<-glm(default_0~ . -ID, data=training, family="binomial"(link="logit"))

model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise
summary(model_logistic_stepwiseAIC) 

logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=testing,type="response")
write.csv(logistic_probabilities, file="predicted_default_probs_logistic_testing.csv")

logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=new_applicants,type="response")
write.csv(logistic_probabilities, file="predicted_default_probs_logistic_new_applicants.csv")

###
### With Random Forest 
###

pacman::p_load("caret","ROCR","lift","randomForest")

#training_sm<-subset(credit_data_24000,ID<=15000)

model_forest <- randomForest(default_0 ~ . -ID, data=training, #_sm, 
                             importance=TRUE,proximity=TRUE,
                             cutoff = c(0.5, 0.5),type="classification")

plot(model_forest)
varImpPlot(model_forest)

forest_probabilities<-predict(model_forest,newdata=testing,type="prob")[,2]
write.csv(forest_probabilities, file="predicted_default_probs_forest_testing.csv")

forest_probabilities<-predict(model_forest,newdata=new_applicants,type="prob")[,2]
write.csv(forest_probabilities, file="predicted_default_probs_forest_new_applicants.csv")

###
### With Support Vector Machines (SVM)
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

model_svm <- svm(default_0 ~. -ID, data=training, probability=TRUE)
summary(model_svm)

svm_probabilities<-attr(predict(model_svm,newdata=testing, probability=TRUE), "prob")

svm_classification<-rep("1",1000)
svm_classification[svm_probabilities[,1]<0.3]="0" 
svm_classification<-as.factor(svm_classification)
confusionMatrix(svm_classification,testing$default_0,positive = "1")

svm_probabilities<-attr(predict(model_svm,newdata=testing, probability=TRUE), "prob")[,1]
write.csv(svm_probabilities, file="predicted_default_probs_SVM_testing.csv")

svm_probabilities<-attr(predict(model_svm,newdata=new_applicants, probability=TRUE), "prob")[,1]
write.csv(svm_probabilities, file="predicted_default_probs_SVM_new_applicants.csv")

###
### With LASSO / Ridge
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

#create the y variable and matrix (capital X) of x variables (will make the code below easier to read + will ensure that all levels exist)

y<-training$default_0

X<-model.matrix(ID ~. - default_0 , data=credit_data_24000)[,-1]
X<-cbind(credit_data_24000$ID,X)

# split X into testing, trainig/holdout and prediction as before
X.training<-subset(X,X[,1]<=23000)[,-1]
X.testing<-subset(X, X[,1]>=23001)[,-1]

# create model matrix for the new applicants, first adjust data for some minor "glitches" in formatting
#new_applicants<-new_applicants[,-25]
#new_applicants[,1]<-c(1:1000)

X.prediction<-model.matrix(ID ~. , data = new_applicants)[,-1]

#LASSO (alpha=1)
lasso.fit<-glmnet(x = X.training, y = y, alpha = 1, family="binomial")
plot(lasso.fit, xvar = "lambda")

#selecting the best penalty lambda
crossval <-  cv.glmnet(x = X.training, y = y, alpha = 1, family="binomial") #create cross-validation data
plot(crossval)
penalty.lasso <- crossval$lambda.min #determine optimal penalty parameter, lambda
log(penalty.lasso) #see where it was on the graph
plot(crossval,xlim=c(-8,-4),ylim=c(0.92,0.95)) # lets zoom-in
lasso.opt.fit <-glmnet(x = X.training, y = y, alpha = 1, lambda = penalty.lasso, family="binomial") #estimate the model with the optimal penalty
coef(lasso.opt.fit) #resultant model coefficients

# predicting the performance on the testing set
lasso_probabilities <- predict(lasso.opt.fit, s = penalty.lasso, newx =X.testing, family="binomial",type="response")
write.csv(lasso_probabilities, file="predicted_default_probs_LASSO_testing.csv")

lasso_classification<-rep("1",1000)
lasso_classification[lasso_probabilities<0.3]="0" 
lasso_classification<-as.factor(lasso_classification)
confusionMatrix(lasso_classification,testing$default_0,positive = "1")

# predicting the performance on new applicants
lasso_probabilities <- predict(lasso.opt.fit, s = penalty.lasso, newx =X.prediction, family="binomial",type="response")
write.csv(lasso_probabilities, file="predicted_default_probs_LASSO_new_applicants.csv")

#Ridge (alpha=0)
ridge.fit<-glmnet(x = X.training, y = y, alpha = 0, family="binomial")
plot(ridge.fit, xvar = "lambda")

#selecting the best penalty lambda
crossval <-  cv.glmnet(x = X.training, y = y, alpha = 0, family="binomial") #create cross-validation data
plot(crossval)
penalty.ridge <- crossval$lambda.min #determine optimal penalty parameter, lambda
log(penalty.ridge) #see where it was on the graph
plot(crossval,xlim=c(-4.5,-2),ylim=c(0.92,0.95)) # lets zoom-in
ridge.opt.fit <-glmnet(x = X.training, y = y, alpha = 0, lambda = penalty.ridge, family="binomial") #estimate the model with the optimal penalty
coef(ridge.opt.fit) #resultant model coefficients

# predicting the performance on the testing set
ridge_probabilities <- predict(ridge.opt.fit, s = penalty.ridge, newx =X.testing, family="binomial",type="response")
write.csv(ridge_probabilities, file="predicted_default_probs_ridge_testing.csv")

ridge_classification<-rep("1",1000)
ridge_classification[ridge_probabilities<0.3]="0" 
ridge_classification<-as.factor(ridge_classification)
confusionMatrix(ridge_classification,testing$default_0,positive = "1")

# predicting the performance on new applicants
ridge_probabilities <- predict(ridge.opt.fit, s = penalty.ridge, newx =X.prediction, family="binomial",type="response")
write.csv(ridge_probabilities, file="predicted_default_probs_ridge_new_applicants.csv")

###
### With Deep Learning (using TensorFlow controlled via Keras)
###

# The initial installation is a bit tricky, use the code below for the first time; after that, pacman

#install.packages("tensorflow")
#library(tensorflow)
#install_tensorflow()
#tf$constant("Hellow Tensorflow") ## a simple way to check if it installed correctly

#install.packages("keras")
#library(keras)
#install_keras()

pacman::p_load("tensorflow", "keras")

# Preprocessing data for inputting into Keras
# Tensors are matrices... hence the input data has to be in a form of a matrix

x_train <- data.matrix(training[,-25]) #matrix of features ("X variables") for training; remove the "default_0" column number 25
y_train <- training$default_0 #target vector ("Y variable") for training 

x_test <- data.matrix(testing[,-25]) #matrix of features ("X variables") for testing; remove the "default_0" column number 25
y_test <- testing$default_0 #target vector ("Y variable") for testing 

x_train <- array_reshape(x_train, c(nrow(x_train), 24)) #Keras interprets data using row-major semantics (as opposed to R's default column-major semantics). Hence need to "reshape" the matrices 
x_test <- array_reshape(x_test, c(nrow(x_test), 24))

# final data preparation steps: scaling for X and converting to categorical for Y

x_train <- scale(x_train)
x_test <- scale(x_test)

y_train <- to_categorical(y_train, 2)
y_test <- to_categorical(y_test, 2)

#
# Defining the neural network model architecture: layers, units, activations. 
#

# common kinds of layers: https://keras.io/layers/about-keras-layers/

  # dense -- connect to each neuron
  # dropout -- connect to each neuron with some probability 
  # convolution -- foundation of computer vision/perception 
  # recurrent -- foundation of time-dependent modeling (text, time-series, etc.) Wekaer than LSTM
  # LSTM -- long short-term memory 
  # flatten/embedding/ -- utility layers: particular kinds of data preparation 

# common kinds of activations: https://keras.io/activations/
  # relu -- piece-wise linear 
  # sigmoid, tanh -- S-shaped 
  # softmax -- normalization to probabilities using exp/sum(exp) transform [like in logistic regression]

model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 256, activation = 'relu') %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 2, activation = 'softmax')

#
# Compiling the model 
#

# common loss functions: https://keras.io/losses/
  # mean_absolute_percentage_error, mean_absolute_error -- for continuous quantities
  # binary_crossentropy, categorical_crossentropy, sparse_categorical_crossentropy -- for events (binary, multinomial)

# common optimizers: https://keras.io/optimizers/
  # adam -- commonly used
  # SGD -- "stochastic gradient descent"

# common metrics: https://keras.io/metrics/ 
  # accuracy, mae, mape 

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = c('accuracy')
)

# Training / "fitting" the model

history <- model %>% fit(
  x_train, y_train, # on what data to train
  epochs = 30, # how many repetitions to have
  batch_size = 256, # how many datapoints are fed to the network at a time 
  validation_split = 0.2  # percentage of training data to keep for cross-validation 
)

summary(model)

plot(history)

# model %>% evaluate(x_test, y_test) # apply the model to testing data

TF_NN_probabilities <- model %>% predict(x_test)  # predict probabilities
write.csv(TF_NN_probabilities, file="predicted_default_probs_TF_NN_testing.csv")

TF_NN_classification<-rep("1",1000)
TF_NN_classification[TF_NN_probabilities[,2]<0.3]="0" 
TF_NN_classification<-as.factor(TF_NN_classification)

confusionMatrix(TF_NN_classification,testing$default_0, positive = "1")

x_prediction <- data.matrix(new_applicants)
x_prediction <- array_reshape(x_prediction, c(nrow(x_prediction), 24))
x_prediction <- scale(x_prediction)

# predicting the performance on new applicants
TF_NN_new_applicant_probabilities <- model %>% predict(x_prediction)
write.csv(TF_NN_new_applicant_probabilities, file="predicted_default_probs_TF_NN_new_applicants.csv")
