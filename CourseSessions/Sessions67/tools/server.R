
#local_directory <- "YOURDIRECTORY/INSEADAnalytics/CourseSessions/Sessions67"
local_directory <- paste(getwd(),"..",sep="/")
source(paste(local_directory,"R/library.R",sep="/"))
source(paste(local_directory,"R/heatmapOutput.R",sep="/"))

# To be able to upload data up to 30MB
options(shiny.maxRequestSize=30*1024^2)
options(rgl.useNULL=TRUE)
options(scipen = 50)

max_data_report = 50 

shinyServer(function(input, output,session) {
  
  ############################################################
  # STEP 1: Read the data 
  read_dataset <- reactive({
    input$datafile_name_coded
    
    # First read the pre-loaded file, and if the user loads another one then replace 
    # ProjectData with the filethe user loads
    ProjectData <- read.csv(paste(paste(local_directory,"data",sep="/"), paste(input$datafile_name_coded, "csv", sep="."), sep = "/"), sep=";", dec=",") # this contains only the matrix ProjectData
    ProjectData=data.matrix(ProjectData)
    
    updateSelectInput(session, "dependent_variable","Dependent Variable",  choices = colnames(ProjectData), selected=colnames(ProjectData)[1])
    updateSelectInput(session, "independent_variables","Independent Variables",  choices = colnames(ProjectData), selected=colnames(ProjectData)[1])
    updateSelectInput(session, "box_chosen","Independent Variable",  choices = colnames(ProjectData), selected=colnames(ProjectData)[1])
    updateSelectInput(session, "hist_chosen","Independent Variable", choices =  colnames(ProjectData), selected=colnames(ProjectData)[1])
    
    ProjectData
  })
  
  user_inputs <- reactive({
    input$datafile_name_coded
    input$dependent_variable
    input$independent_variables
    input$estimation_data_percent
    input$validation_data_percent
    input$random_sampling
    input$Probability_Threshold
    input$actual_1_predict_1
    input$actual_0_predict_1
    input$actual_0_predict_0
    input$actual_1_predict_0
    input$use_tree 
    input$use_log
    input$use_svm
    input$use_forest
    
    methods_available = "no choice"
    
    if (input$use_tree == "1")
      methods_available = setdiff(unique(c(methods_available, "tree")),"no choice")
    if (input$use_log == "1")
      methods_available = setdiff(unique(c(methods_available, "logistic")),"no choice")
    #if (input$use_svm == "1")
    #  methods_available = setdiff(unique(c(methods_available, "svm")),"no choice")
    if (input$use_forest == "1")
      methods_available = setdiff(unique(c(methods_available, "forest")),"no choice")
    
    if (input$use_tree == "0")
      methods_available = setdiff(methods_available, "tree")
    if (input$use_log == "0")
      methods_available = setdiff(methods_available, "logistic")
    #if (input$use_svm == "0")
    #  methods_available = setdiff(methods_available, "svm")
    if (input$use_forest == "0")
      methods_available = setdiff(methods_available, "forest")    
    
    if ((input$use_tree == "0") & (input$use_log == "0") &
          #(input$use_svm == "0") & 
          (input$use_forest == "0"))
      methods_available = "no choice"
    
    updateSelectInput(session, "drivers_method_chosen","Method(s) available to see", choices = methods_available, selected = methods_available[1])      
    updateSelectInput(session, "hit_method_chosen","Method(s) available to see",  choices = methods_available, selected=methods_available[1])
    updateSelectInput(session, "roc_method_chosen","Method(s) available to see",  choices = methods_available, selected=methods_available[1])
    updateSelectInput(session, "lift_method_chosen","Method(s) available to see",  choices = methods_available, selected=methods_available[1])
    updateSelectInput(session, "profit_method_chosen","Method(s) available to see",  choices = methods_available, selected=methods_available[1])
    
    ProjectData = read_dataset()
    independent_variables = intersect(colnames(ProjectData), input$independent_variables)
    dependent_variable = intersect(colnames(ProjectData), input$dependent_variable)
    independent_variables = setdiff(independent_variables,dependent_variable)
    
    estimation_data_percent = max(0,min(input$estimation_data_percent,100))
    validation_data_percent = max(0, min(input$validation_data_percent,100))
    validation_data_percent = min(validation_data_percent, 100 - estimation_data_percent)
    test_data_percent = 100-estimation_data_percent-validation_data_percent
    
    Profit_Matrix = matrix(c(input$actual_1_predict_1, input$actual_0_predict_1, 
                             input$actual_1_predict_0, input$actual_0_predict_0), ncol=2)
    colnames(Profit_Matrix)<- c("Predict 1", "Predict 0")
    rownames(Profit_Matrix) <- c("Actual 1", "Actual 0")
    
    ###
    if (input$random_sampling == "1"){
      estimation_data=sample.int(nrow(ProjectData),ceiling(estimation_data_percent*nrow(ProjectData)/100))
      non_estimation_data = setdiff(1:nrow(ProjectData),estimation_data)
      validation_data=non_estimation_data[sample.int(length(non_estimation_data), floor(validation_data_percent/(validation_data_percent+test_data_percent)*length(non_estimation_data)))]
    } else {
      estimation_data=1:ceiling(estimation_data_percent*nrow(ProjectData)/100)
      non_estimation_data = setdiff(1:nrow(ProjectData),estimation_data)
      validation_data = (tail(estimation_data,1)+1):(tail(estimation_data,1) + floor(validation_data_percent/(validation_data_percent+test_data_percent)*length(non_estimation_data)))
    }    
    test_data = setdiff(1:nrow(ProjectData), union(estimation_data,validation_data))
    
    estimation_data=ProjectData[estimation_data,]
    validation_data=ProjectData[validation_data,]
    test_data=ProjectData[test_data,]
    
    ###
    independent_variables_nolabel = NULL
    if (length(independent_variables))    
      independent_variables_nolabel = paste("IV", 1:length(independent_variables), sep="")
    
    estimation_data_nolabel = cbind(estimation_data[,dependent_variable], estimation_data[,independent_variables])
    colnames(estimation_data_nolabel)<- c(dependent_variable,independent_variables_nolabel)
    
    validation_data_nolabel = cbind(validation_data[,dependent_variable], validation_data[,independent_variables])
    colnames(validation_data_nolabel)<- c(dependent_variable,independent_variables_nolabel)
    
    test_data_nolabel = cbind(test_data[,dependent_variable], test_data[,independent_variables])
    colnames(test_data_nolabel)<- c(dependent_variable,independent_variables_nolabel)
    
    estimation_data_nolabel = data.frame(estimation_data_nolabel)
    validation_data_nolabel = data.frame(validation_data_nolabel)
    test_data_nolabel = data.frame(test_data_nolabel)
    ###
    
    Probability_Threshold = min(100, max(0, input$Probability_Threshold))/100
    
    list(ProjectData = read_dataset(), 
         estimation_data = estimation_data,
         validation_data = validation_data,
         test_data = test_data,
         dependent_variable = dependent_variable,
         independent_variables = independent_variables,
         independent_variables_nolabel = independent_variables_nolabel,
         estimation_data_nolabel = estimation_data_nolabel,
         validation_data_nolabel = validation_data_nolabel,
         test_data_nolabel = test_data_nolabel,
         Profit_Matrix = Profit_Matrix,
         estimation_data_percent = estimation_data_percent,
         validation_data_percent = validation_data_percent,
         test_data_percent = test_data_percent,
         random_sampling = input$random_sampling,
         Probability_Threshold = Probability_Threshold
    )
  }) 
  
  
  ############################################################
  # STEP 2: create a "reactive function" as well as an "output" 
  # for each of the R code chunks in the report/slides to use in the web application. 
  # These also correspond to the tabs defined in the ui.R file. 
  
  # The "reactive function" recalculates everything the tab needs whenever any of the inputs 
  # used (in the left pane of the application) for the calculations in that tab is modified by the user 
  # The "output" is then passed to the ui.r file to appear on the application page/
  
  
  ########## The Parameters Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  the_parameters_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$dependent_variable
    input$independent_variables
    input$estimation_data_percent
    input$validation_data_percent
    input$random_sampling
    input$Probability_Threshold
    
    all_inputs <- user_inputs()
    
    percent1_estimation = ifelse(nrow(all_inputs$estimation_data), round(100*sum(all_inputs$estimation_data[,all_inputs$dependent_variable]==1)/nrow(all_inputs$estimation_data),1), 0)
    percent1_validation = ifelse(nrow(all_inputs$validation_data), round(100*sum(all_inputs$estimation_data[,all_inputs$dependent_variable]==1)/nrow(all_inputs$estimation_data),1), 0)
    percent1_test = ifelse(nrow(all_inputs$test_data), round(100*sum(all_inputs$estimation_data[,all_inputs$dependent_variable]==1)/nrow(all_inputs$estimation_data),1), 0)
    
    allparameters=c(nrow(all_inputs$ProjectData), 
                    nrow(all_inputs$estimation_data),
                    nrow(all_inputs$validation_data),
                    nrow(all_inputs$test_data),
                    all_inputs$random_sampling,
                    percent1_estimation,
                    percent1_validation,
                    percent1_test,
                    length(all_inputs$independent_variables),
                    all_inputs$Probability_Threshold, 
                    all_inputs$dependent_variable, 
                    all_inputs$independent_variables
    )
    allparameters<-matrix(allparameters,ncol=1)    
    theparameter_names <- c("Total number of observations", 
                            "Number of estimation data",
                            "Number of validation data",
                            "Number of test data",
                            "Data Sampling",
                            "Percentage of class 1 observations in estimation data",
                            "Percentage of class 1 observations in validation data",
                            "Percentage of class 1 observations in test data",
                            "Number of independent variables used",
                            "Probability Threshold","Dependent Variable", 
                            paste("Independent Variable:",1:length(all_inputs$independent_variables), sep=" ")
    )
    
    if (length(allparameters) == length(theparameter_names))
      rownames(allparameters)<- theparameter_names
    colnames(allparameters)<-NULL
    allparameters<-as.data.frame(allparameters)
    
    allparameters
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$parameters<-renderTable({
    the_parameters_tab()
  })
  
  ########## The Summary Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_summary_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$action_summary
    
    all_inputs <- user_inputs()
    estimation_data = all_inputs$estimation_data
    
    my_summary(estimation_data)
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$summary <- renderTable({        
    t(the_summary_tab())
  })
  
  
  ########## The hisotgrams Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_histogram_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$hist_chosen
    input$action_histograms
    
    all_inputs <- user_inputs()
    estimation_data = all_inputs$estimation_data
    estimation_data[,input$hist_chosen,drop=F]
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$histograms <- renderPlot({  
    data_used = unlist(the_histogram_tab())
    
    numb_of_breaks = ifelse(length(unique(data_used)) < 10, length(unique(data_used)), length(data_used)/5)
    hist(data_used, breaks=numb_of_breaks,main = NULL, xlab=paste("Histogram of Variable: ",colnames(data_used)), ylab="Frequency", cex.lab=1.2, cex.axis=1.2)
  })
  
  
  ########## The box plots Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_box_plots_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$dependent_variable
    input$independent_variables
    input$estimation_data_percent
    input$validation_data_percent
    input$random_sampling
    input$action_box
    
    all_inputs <- user_inputs()
    estimation_data = all_inputs$estimation_data
    estimation_data[,input$box_chosen,drop=F]
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$box_plots <- renderPlot({  
    all_inputs <- user_inputs()
    data_used = unlist(the_box_plots_tab())
    
    boxplot(data_used~all_inputs$estimation_data[,all_inputs$dependent_variable],
            data=all_inputs$estimation_data, 
            main=colnames(data_used), xlab=all_inputs$dependent_variable)
  })
  
  ##################################################################################################################
  # The next few tabs are the "heavy computations" for each classifier, so we do them only once when needed
  ##################################################################################################################
  
  classifier_params_tab <- reactive({
    input$tree_cp
    input$svm_lambda
    input$svm_kernel
    input$svm_kernel_param
    input$forest_ntree
    input$forest_maxnodes
    
    list(tree_cp = input$tree_cp,
         svm_lambda = input$svm_lambda,
         svm_kernel = input$svm_kernel,
         svm_kernel_param = input$svm_kernel_param,
         forest_ntree = input$forest_ntree, 
         forest_maxnode = input$forest_maxnodes)
  })
  
  
  the_tree_computations <- reactive({
    # list the user inputs the tab depends on (easier to read the code)
    
    class_params = classifier_params_tab()
    CART_control = class_params$tree_cp
    
    res = list()
    if (input$use_tree == "1"){
      
      all_inputs <- user_inputs()
      estimation_data_nolabel = as.data.frame(all_inputs$estimation_data_nolabel)
      validation_data_nolabel = as.data.frame(all_inputs$validation_data_nolabel)
      test_data_nolabel = as.data.frame(all_inputs$test_data_nolabel)
      
      dependent_variable = all_inputs$dependent_variable
      independent_variables_nolabel = all_inputs$independent_variables_nolabel
      
      formula=paste(colnames(estimation_data_nolabel[,dependent_variable,drop=F]),paste(Reduce(paste,sapply(head(independent_variables_nolabel,-1), function(i) paste(i,"+",sep=""))),tail(independent_variables_nolabel,1),sep=""),sep="~")
      CART_tree<-rpart(formula, data= estimation_data_nolabel,method="class", 
                       control=rpart.control(cp = CART_control))
      
      estimation_Probability_class1_tree<-predict(CART_tree, estimation_data_nolabel)[,"1"]    
      validation_Probability_class1_tree<-predict(CART_tree, validation_data_nolabel)[,"1"]    
      test_Probability_class1_tree<-predict(CART_tree, test_data_nolabel)[,"1"]    
      
      res = list(CART_tree = CART_tree,
                 tree_cp = CART_control,
                 estimation_Probability_class1 = estimation_Probability_class1_tree,
                 validation_Probability_class1 = validation_Probability_class1_tree,
                 test_Probability_class1 = test_Probability_class1_tree)
    }
    res
  })
  
  ####
  
  the_logistic_computations <- reactive({
    input$use_log
    
    res = list()
    if (input$use_log == "1"){
      all_inputs <- user_inputs()
      estimation_data = as.data.frame(all_inputs$estimation_data)
      validation_data = as.data.frame(all_inputs$validation_data)
      test_data = as.data.frame(all_inputs$test_data)
      dependent_variable = all_inputs$dependent_variable
      independent_variables = all_inputs$independent_variables
      
      formula_log=paste(colnames(estimation_data[,dependent_variable,drop=F]),paste(Reduce(paste,sapply(head(independent_variables,-1), function(i) paste(i,"+",sep=""))),tail(independent_variables,1),sep=""),sep="~")
      
      logreg_solution <- glm(formula_log, family=binomial(link="logit"), data=estimation_data)
      
      estimation_Probability_class1_log<-predict(logreg_solution, type="response", newdata=estimation_data[,independent_variables])
      validation_Probability_class1_log<-predict(logreg_solution, type="response", newdata=validation_data[,independent_variables])
      test_Probability_class1_log<-predict(logreg_solution, type="response", newdata=test_data[,independent_variables])
      
      res = list(logreg_solution = logreg_solution,
                 estimation_Probability_class1 = estimation_Probability_class1_log,
                 validation_Probability_class1 = validation_Probability_class1_log,
                 test_Probability_class1 = test_Probability_class1_log)
    }
    res
  })
  
  ####
  the_svm_computations<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$use_svm
    
    class_params = classifier_params_tab() 
    svm_lambda = class_params$svm_lambda
    svm_kernel = class_params$svm_kernel
    svm_kernel_param = class_params$svm_kernel_param
    
    res = list()
    if (input$use_svm == "1"){
      all_inputs <- user_inputs()
      estimation_data = all_inputs$estimation_data
      validation_data = all_inputs$validation_data
      test_data = all_inputs$test_data
      dependent_variable = all_inputs$dependent_variable
      independent_variables = all_inputs$independent_variables
      
      x = estimation_data[,independent_variables]
      y = as.factor(estimation_data[,dependent_variable])
      
      svm_solution <- svm(x,y, cost = svm_lambda,
                          kernel = svm_kernel, 
                          degree = min(1,round(svm_kernel_param,0)), 
                          gamma = max(0,svm_kernel_param),
                          probability=TRUE )
      
      estimation_Probability_class1_svm <- attr(predict(svm_solution, estimation_data[,independent_variables],probability = TRUE,decision.values=FALSE), "probabilities")[,1]
      validation_Probability_class1_svm <- attr(predict(svm_solution, validation_data[,independent_variables],probability = TRUE,decision.values=FALSE), "probabilities")[,1]
      test_Probability_class1_svm <- attr(predict(svm_solution, test_data[,independent_variables],probability = TRUE,decision.values=FALSE), "probabilities")[,1]
      
      res = list(svm_solution = svm_solution,
                 estimation_Probability_class1 = estimation_Probability_class1_svm,
                 validation_Probability_class1 = validation_Probability_class1_svm,
                 test_Probability_class1 = test_Probability_class1_svm)
      res
    }
  })
  
  the_forest_computations<-reactive({
    input$use_forest
    
    class_params = classifier_params_tab()    
    forest_ntree = class_params$forest_ntree 
    forest_maxnode = class_params$forest_maxnodes
    
    res = list()
    if (input$use_forest == "1"){
      all_inputs <- user_inputs()
      estimation_data = all_inputs$estimation_data
      validation_data = all_inputs$validation_data
      test_data = all_inputs$test_data
      dependent_variable = all_inputs$dependent_variable
      independent_variables = all_inputs$independent_variables
      
      x = estimation_data[,independent_variables]
      y = as.factor(estimation_data[,dependent_variable])
      forest_solution <- randomForest(x,y,ntree = forest_ntree, 
                                      maxnodes = forest_maxnode,
                                      importance = TRUE)
      
      estimation_Probability_class1_forest<-predict(forest_solution, type="prob", newdata=estimation_data[,independent_variables])[,"1"]
      validation_Probability_class1_forest<-predict(forest_solution, type="prob", newdata=validation_data[,independent_variables])[,"1"]
      test_Probability_class1_forest<-predict(forest_solution, type="prob", newdata=test_data[,independent_variables])[,"1"]
      
      res = list(forest_solution = forest_solution,
                 estimation_Probability_class1 = estimation_Probability_class1_forest,
                 validation_Probability_class1 = validation_Probability_class1_forest,
                 test_Probability_class1 = test_Probability_class1_forest)
    } 
    res
  })
  
  #### Now get the necessary outputs
  
  output$drivers <- renderTable({  
    input$action_drivers
    method_used = input$drivers_method_chosen
    
    all_inputs <- user_inputs()
    
    #res = matrix("No Method has been selected", nrow=15,ncol=1)    
    if (method_used == "tree"){ 
      res = round(the_tree_computations()$CART_tree$variable.importance, 2)
      #rownames(res) <- all_inputs$independent_variables
      #colnames(res) <- "tree"
    }
    if (method_used == "logistic"){ 
      res = round(summary(the_logistic_computations()$logreg_solution)$coefficients,1)
      as.data.frame(res)
      #colnames(res) <- "logistic"
    }
    if (method_used == "svm"){
      res = matrix("SVM does not provide this", ncol=1)
      colnames(res) <- "svm"
    }
    if (method_used == "forest"){
      
      res = round(the_forest_computations()$forest_solution$importance,2)
      as.data.frame(res)
      #colnames(res) <- "forest"
    }
    
    as.data.frame(res)
  })
  
  output$tree <- renderPlot({
    input$action_tree
    
    res <- plot(rep(0,1000), main = "Tree has not been selected for estimation")
    if (input$use_tree == "1")
      res <- fancyRpartPlot(the_tree_computations()$CART_tree)
    
    res
  })
  
  output$hit_rates <- renderTable({  
    input$action_hit
    available_methods = input$hit_method_chosen    
    hit_data_chosen = input$hit_data_chosen
    
    Probability_Threshold = input$Probability_Threshold/100  
    all_inputs <- user_inputs()
    
    res = matrix("No Method has been selected", ncol=1)    
    if (length(intersect(available_methods, c("tree","logistic","svm","forest")))){
      res = NULL
      for (method_used in available_methods){
        if (method_used == "tree")
          use_results = the_tree_computations()
        if (method_used == "logistic")
          use_results = the_logistic_computations()
        if (method_used == "svm")
          use_results = the_svm_computations()
        if (method_used == "forest")
          use_results = the_forest_computations()
        
        if (hit_data_chosen == "Estimation Data"){
          probs = use_results$estimation_Probability_class1
          actual_class = all_inputs$estimation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Validation Data"){ 
          probs = use_results$validation_Probability_class1
          actual_class = all_inputs$validation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Test Data") { 
          probs = use_results$test_Probability_class1
          actual_class = all_inputs$test_data[,all_inputs$dependent_variable]
        }
        prediction_class = (probs >= Probability_Threshold)
        res = c(res, 100*sum(prediction_class==actual_class)/length(actual_class)) 
      }
      res = matrix(res,ncol=1)
      rownames(res) <- available_methods
      colnames(res) <- hit_data_chosen
    }
    
    res
  })
  
  
  output$roc_curve <- renderPlot({      
    input$action_roc
    available_methods = input$roc_method_chosen
    hit_data_chosen = input$roc_data_chosen
    
    Probability_Threshold = input$Probability_Threshold/100    
    all_inputs <- user_inputs()
    
    res <- rep(0,1000) 
    
    if (length(available_methods)){  
      res = lapply(available_methods, function(method_used){
        
        if (method_used == "tree"){ 
          use_results = the_tree_computations()
          thecolor = "black"
        }
        if (method_used == "logistic"){ 
          use_results = the_logistic_computations()
          thecolor = "blue"
        }
        if (method_used == "svm"){ 
          use_results = the_svm_computations()
          thecolor = "red"
        }
        if (method_used == "forest"){ 
          use_results = the_forest_computations()
          thecolor = "green"
        }
        
        if (hit_data_chosen == "Estimation Data"){
          probs = use_results$estimation_Probability_class1
          actual_class = all_inputs$estimation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Validation Data"){ 
          probs = use_results$validation_Probability_class1
          actual_class = all_inputs$validation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Test Data") { 
          probs = use_results$test_Probability_class1
          actual_class = all_inputs$test_data[,all_inputs$dependent_variable]
        }
        
        the_pred = prediction(probs, actual_class)     
        list( theperf = performance(the_pred, "tpr", "fpr"),
              thecolor = thecolor
        )
      })
    }
    
    if (length(res) == 1000) { 
      plot(res, main = "No method estimated or selected")
    } else {
      if(length(available_methods) > 1){
        for (iter in 1:length(res)){
          theperf = res[[iter]]$theperf
          thecolor = res[[iter]]$thecolor          
          plot(theperf, col=thecolor, lty=1, main="ROC Curve")          
          if(iter == 1){
            grid()
            par(new=TRUE)
          }else if(iter != 1 && iter != length(res)){
            par(new=TRUE)
          }else{
            par(new=FALSE)
          }
        }
      } else {
        theperf = res[[1]]$theperf
        thecolor = res[[1]]$thecolor        
        plot(theperf, col=thecolor, lty=1,main="ROC Curve")
      }      
    }
  })
  
  
  output$lift_curve <- renderPlot({  
    input$action_lift
    available_methods = input$lift_method_chosen    
    hit_data_chosen = input$lift_data_chosen
    
    Probability_Threshold = input$Probability_Threshold/100    
    all_inputs <- user_inputs()
    
    res <- rep(0,1000) 
    
    if (length(available_methods)){  
      res = lapply(available_methods, function(method_used){
        
        if (method_used == "tree"){ 
          use_results = the_tree_computations()
          thecolor = "black"
        }
        if (method_used == "logistic"){ 
          use_results = the_logistic_computations()
          thecolor = "blue"
        }
        if (method_used == "svm"){ 
          use_results = the_svm_computations()
          thecolor = "red"
        }
        if (method_used == "forest"){ 
          use_results = the_forest_computations()
          thecolor = "green"
        }
        
        if (hit_data_chosen == "Estimation Data"){
          probs = use_results$estimation_Probability_class1
          actual_class = all_inputs$estimation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Validation Data"){ 
          probs = use_results$validation_Probability_class1
          actual_class = all_inputs$validation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Test Data") { 
          probs = use_results$test_Probability_class1
          actual_class = all_inputs$test_data[,all_inputs$dependent_variable]
        }
        
        all1s=sum(actual_class);         
        xaxis = sort(unique(c(0,1,probs)), decreasing = TRUE)
        the_lift = 100*Reduce(cbind,lapply(xaxis, function(prob){
          useonly = which(probs >= 1-prob)
          c(length(useonly)/length(actual_class), sum(actual_class[useonly])/all1s) 
        }))
        list( theperf = the_lift,
              thecolor = thecolor
        )
      })
    }
    
    if (length(res) == 1000) { 
      plot(res, main = "No method estimated or selected")
    } else {
      if(length(available_methods) > 1){
        for (iter in 1:length(res)){
          theperf = res[[iter]]$theperf
          thecolor = res[[iter]]$thecolor          
          plot(theperf[1,], theperf[2,], col=thecolor,type='l', lty=1,main="Lift Curve")          
          if(iter == 1){
            grid()
            par(new=TRUE)
          }else if(iter != 1 && iter != length(res)){
            par(new=TRUE)
          }else{
            par(new=FALSE)
          }
        }
      } else {
        theperf = res[[1]]$theperf
        thecolor = res[[1]]$thecolor        
        plot(theperf[1,], theperf[2,], col=thecolor, type='l',lty=1, main="Lift Curve")
      }      
    }    
  })
  
  
  output$profit_curve <- renderPlot({  
    input$action_profit
    available_methods = input$profit_method_chosen    
    hit_data_chosen = input$profit_data_chosen
    
    Probability_Threshold = input$Probability_Threshold/100    
    all_inputs <- user_inputs()
    Profit_Matrix<-all_inputs$Profit_Matrix
    res <- rep(0,1000) 
    
    if (length(available_methods)){  
      res = lapply(available_methods, function(method_used){
        
        if (method_used == "tree"){ 
          use_results = the_tree_computations()
          thecolor = "black"
        }
        if (method_used == "logistic"){ 
          use_results = the_logistic_computations()
          thecolor = "blue"
        }
        if (method_used == "svm"){ 
          use_results = the_svm_computations()
          thecolor = "red"
        }
        if (method_used == "forest"){ 
          use_results = the_forest_computations()
          thecolor = "green"
        }
        
        if (hit_data_chosen == "Estimation Data"){
          probs = use_results$estimation_Probability_class1
          actual_class = all_inputs$estimation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Validation Data"){ 
          probs = use_results$validation_Probability_class1
          actual_class = all_inputs$validation_data[,all_inputs$dependent_variable]
        }
        if (hit_data_chosen == "Test Data") { 
          probs = use_results$test_Probability_class1
          actual_class = all_inputs$test_data[,all_inputs$dependent_variable]
        }
        
        xxxaxis = sort(unique(c(0,1,probs)), decreasing = TRUE)
        the_profit = Reduce(cbind,lapply(xxxaxis, function(prob){
          useonly = which(probs >= prob)
          predict_class = 1*(probs >= prob)
          theprofit = Profit_Matrix[1,1]*sum(predict_class==1 & actual_class ==1)+
            Profit_Matrix[1,2]*sum(predict_class==0 & actual_class ==1)+
            Profit_Matrix[2,1]*sum(predict_class==1 & actual_class ==0)+
            Profit_Matrix[2,2]*sum(predict_class==0 & actual_class ==0)
          
          c(100*length(useonly)/length(actual_class), theprofit)
        }))
        
        #the_pred = prediction(probs, actual_class)     
        list( theperf = the_profit,
              thecolor = thecolor
        )
      })
    }
    
    if (length(res) == 1000) { 
      plot(res, main = "No method estimated or selected")
    } else {
      if(length(available_methods) > 1){
        for (iter in 1:length(res)){
          theperf = res[[iter]]$theperf
          thecolor = res[[iter]]$thecolor          
          plot(theperf[1,], theperf[2,], col=thecolor,type='l', lty=1, main="Profit Curve")          
          if(iter == 1){
            grid()
            par(new=TRUE)
          }else if(iter != 1 && iter != length(res)){
            par(new=TRUE)
          }else{
            par(new=FALSE)
          }
        }
      } else {
        theperf = res[[1]]$theperf
        thecolor = res[[1]]$thecolor        
        plot(theperf[1,], theperf[2,], col=thecolor,type='l', lty=1, main="Profit Curve")
      }      
    }    
  })
  
  # Now the report and slides  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_slides_and_report <-reactive({
    input$datafile_name_coded
    input$dependent_variable
    input$independent_variables
    input$estimation_data_percent
    input$validation_data_percent
    input$random_sampling
    input$Probability_Threshold
    input$actual_1_predict_1
    input$actual_0_predict_1
    input$actual_0_predict_0
    input$actual_1_predict_0
    
    all_inputs <- user_inputs()
    
    #############################################################
    # A list of all the (SAME) parameters that the report takes from RunStudy.R
    list(
      ProjectData = all_inputs$ProjectData,
      dependent_variable = all_inputs$dependent_variable,
      independent_variables = all_inputs$independent_variables,
      estimation_data_percent = all_inputs$estimation_data_percent,
      validation_data_percent = all_inputs$validation_data_percent,
      test_data_percent = all_inputs$test_data_percent,
      random_sampling = all_inputs$random_sampling,
      Probability_Threshold = all_inputs$Probability_Threshold,
      Profit_Matrix = all_inputs$Profit_Matrix,
      CART_control = input$tree_cp,
      max_data_report = max_data_report
    )    
  })
  
  # The new report 
  
  output$report = downloadHandler(
    filename <- function() {paste(paste('Report_s67',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Report_s67.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Report_s67.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Report_s67.html', sep="/")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      dependent_variable = reporting_data$dependent_variable
      independent_variables = reporting_data$independent_variables
      estimation_data_percent = reporting_data$estimation_data_percent
      validation_data_percent = reporting_data$validation_data_percent
      test_data_percent = reporting_data$test_data_percent
      random_sampling = reporting_data$random_sampling
      Probability_Threshold = reporting_data$Probability_Threshold
      Profit_Matrix = reporting_data$Profit_Matrix
      CART_control = reporting_data$tree_cp
      max_data_report = reporting_data$max_data_report
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Report_s67.Rmd",sep="/"),filename.Rmd,overwrite=T)
      out = knit2html(filename.Rmd,quiet=TRUE)
      
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      file.remove(filename.Rmd)
      file.remove(filename.md)
      
      file.rename(out, file) # move pdf to file for downloading
    },    
    contentType = 'application/pdf'
  )
  
  # The new slides 
  
  output$slide = downloadHandler(
    filename <- function() {paste(paste('Slides_s67',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Slides_s67.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Slides_s67.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Slides_s67.html', sep="/")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      dependent_variable = reporting_data$dependent_variable
      independent_variables = reporting_data$independent_variables
      estimation_data_percent = reporting_data$estimation_data_percent
      validation_data_percent = reporting_data$validation_data_percent
      test_data_percent = reporting_data$test_data_percent
      random_sampling = reporting_data$random_sampling
      Probability_Threshold = reporting_data$Probability_Threshold
      Profit_Matrix = reporting_data$Profit_Matrix
      CART_control = reporting_data$tree_cp
      max_data_report = reporting_data$max_data_report
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figure', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Slides_s67.Rmd",sep="/"),filename.Rmd,overwrite=T)
      slidify(filename.Rmd)
      
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figure', sep="/"), recursive=TRUE)
      file.remove(filename.Rmd)
      file.remove(filename.md)
      file.rename(filename.html, file) # move pdf to file for downloading      
    },    
    contentType = 'application/pdf'
  )
  
})
