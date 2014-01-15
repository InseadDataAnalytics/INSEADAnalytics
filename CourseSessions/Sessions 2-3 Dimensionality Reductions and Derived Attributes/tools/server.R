if (!exists("local_directory")) {  
  local_directory <- "~/CourseSessions/Sessions 2-3 Dimensionality Reductions and Derived Attributes"
  source(paste(local_directory,"R/library.R",sep="/"))
  source(paste(local_directory,"R/heatmapOutput.R",sep="/"))
} 

# To be able to upload data up to 30MB
options(shiny.maxRequestSize=30*1024^2)
options(rgl.useNULL=TRUE)
options(scipen = 50)

# Please enter the maximum number of observations to show in the report and slides (DEFAULT is 100)
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
    
    updateSelectInput(session, "factor_attributes_used","Variables used for Factor Analysis",  colnames(ProjectData), selected=colnames(ProjectData)[1])
    
    ProjectData
  })
  
  user_inputs <- reactive({
    input$datafile_name_coded
    input$factor_attributes_used
    input$manual_numb_factors_used
    input$rotation_used
    input$MIN_VALUE
    
    ProjectData = read_dataset()
    ProjectDataFactor = as.matrix(ProjectData[,input$factor_attributes_used, drop=F])
    
    list(ProjectData = read_dataset(), 
         ProjectDataFactor = ProjectDataFactor,
         factor_attributes_used = input$factor_attributes_used, 
         manual_numb_factors_used = max(1,min(input$manual_numb_factors_used,length(input$factor_attributes_used))),
         rotation_used = input$rotation_used,
         MIN_VALUE = input$MIN_VALUE
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
    input$factor_attributes_used
    input$manual_numb_factors_used
    input$rotation_used
    input$MIN_VALUE
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData 
    ProjectDataFactor = all_inputs$ProjectDataFactor
    factor_attributes_used = all_inputs$factor_attributes_used
    manual_numb_factors_used = all_inputs$manual_numb_factors_used
    rotation_used = all_inputs$rotation_used
    MIN_VALUE = all_inputs$MIN_VALUE
    
    
    allparameters=c(nrow(ProjectData), ncol(ProjectData),
                    ncol(ProjectDataFactor),
                    manual_numb_factors_used, rotation_used,factor_attributes_used
    )
    allparameters<-matrix(allparameters,ncol=1)    
    theparameter_names <- c("Total number of observations", "Total number of attributes", 
                            "Number of attrubutes used",  
                            "Number of factors to get", "Rotation used",
                            paste("Used Attribute:",1:length(factor_attributes_used), sep=" ")
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
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    ProjectDataFactor = all_inputs$ProjectDataFactor
    factor_attributes_used = all_inputs$factor_attributes_used
    
    my_summary(ProjectDataFactor)
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$summary <- renderTable({        
    the_summary_tab()
  })
  
  
  ########## The hisotgrams Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_histogram_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$var_chosen
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    
    var_chosen = max(0,min(input$var_chosen,ncol(ProjectData)))
    ProjectData[,var_chosen,drop=F]
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$histograms <- renderPlot({  
    data_used = unlist(the_histogram_tab())
    numb_of_breaks = ifelse(length(unique(data_used)) < 10, length(unique(data_used)), length(data_used)/5)
    hist(data_used, breaks=numb_of_breaks,main = NULL, xlab=paste("Histogram of Variable: ",colnames(data_used)), ylab="Frequency", cex.lab=1.2, cex.axis=1.2)
  })
  
  ########## The next few tabs use the same "heavy computation" results for Hclust, so we do these only once
  
  the_computations<-reactive({
    # list the user inputs the tab depends on (easier to read the code)    
    input$datafile_name_coded
    input$factor_attributes_used
    input$manual_numb_factors_used
    input$rotation_used
    input$unrot_number
    input$MIN_VALUE
    input$show_colnames_unrotate    
    input$show_colnames_rotate
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData 
    ProjectDataFactor = all_inputs$ProjectDataFactor
    factor_attributes_used = all_inputs$factor_attributes_used
    manual_numb_factors_used = all_inputs$manual_numb_factors_used
    rotation_used = all_inputs$rotation_used
    MIN_VALUE = all_inputs$MIN_VALUE
    
    
    unrot_number = max(1, min(input$unrot_number, length(factor_attributes_used)))
    
    correl<-cor(ProjectDataFactor)
    
    Unrotated_Results<-principal(ProjectDataFactor, nfactors=ncol(ProjectDataFactor), rotate="none")
    Unrotated_Factors<-Unrotated_Results$loadings[,1:unrot_number,drop=F]
    
    Unrotated_Factors<-as.data.frame(unclass(Unrotated_Factors))
    colnames(Unrotated_Factors)<-paste("Component",1:ncol(Unrotated_Factors),sep=" ")
    rownames(Unrotated_Factors) <- colnames(ProjectDataFactor)
    
    if (input$show_colnames_unrotate==0)
      rownames(Unrotated_Factors)<- NULL
    
    Variance_Explained_Table_results<-PCA(ProjectDataFactor, graph=FALSE)
    Variance_Explained_Table<-Variance_Explained_Table_results$eig
    
    eigenvalues<-Unrotated_Results$values
    
    
    Rotated_Results<-principal(ProjectDataFactor, nfactors=manual_numb_factors_used, rotate=rotation_used,score=TRUE)
    Rotated_Factors<-round(Rotated_Results$loadings,2)
    Rotated_Factors<-as.data.frame(unclass(Rotated_Factors))
    colnames(Rotated_Factors)<-paste("Component",1:ncol(Rotated_Factors),sep=" ")
    
    sorted_rows <- sort(Rotated_Factors[,1], decreasing = TRUE, index.return = TRUE)$ix
    Rotated_Factors <- Rotated_Factors[sorted_rows,]
    
    Rotated_Factors<-as.data.frame(unclass(Rotated_Factors))
    colnames(Rotated_Factors)<-paste("Component",1:ncol(Rotated_Factors),sep=" ")
    rownames(Rotated_Factors) <- colnames(ProjectDataFactor)
    
    if (input$show_colnames_rotate==0)
      rownames(Rotated_Factors)<- NULL
    
    NEW_ProjectData <- Rotated_Results$scores
    colnames(NEW_ProjectData)<-paste("Derived Variable (Factor)",1:ncol(NEW_ProjectData),sep=" ")
    
    list( 
      correl = correl,
      Unrotated_Results = Unrotated_Results,
      Unrotated_Factors = Unrotated_Factors,
      Variance_Explained_Table_results = Variance_Explained_Table_results,
      Variance_Explained_Table = Variance_Explained_Table,
      eigenvalues = eigenvalues,
      Rotated_Results = Rotated_Results,
      Rotated_Factors = Rotated_Factors,
      NEW_ProjectData = NEW_ProjectData
    )
  })
  
  # Now get the rest of the tabs
  
  the_correlation_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)    
    input$datafile_name_coded
    input$factor_attributes_used
    input$show_colnames
    
    data_used = the_computations()    
    the_data = data_used$correl
    if (input$show_colnames == "0"){
      colnames(the_data) <- NULL
      rownames(the_data) <- NULL
    }
    round(the_data,2)
  })
  
  output$correlation <- renderHeatmap({  
    round(the_correlation_tab(),2)   
  })
  
  output$Variance_Explained_Table<-renderTable({
    data_used = the_computations()    
    round(data_used$Variance_Explained_Table,2)
  })
  
  output$Unrotated_Factors<-renderHeatmap({
    
    data_used = the_computations()        
    
    the_data = round(data_used$Unrotated_Factors,2)
    the_data[abs(the_data) < input$MIN_VALUE] <- 0
    the_data
  })
  
  output$Rotated_Factors<-renderHeatmap({
    data_used = the_computations()        
    
    the_data = round(data_used$Rotated_Factors,2)
    the_data[abs(the_data) < input$MIN_VALUE] <- 0
    the_data
  })
  
  output$scree <- renderPlot({  
    data_used = the_computations()    
    plot(data_used$eigenvalues, type="l")
  })
  
  output$NEW_ProjectData<-renderPlot({  
    input$factor1
    input$factor
    data_used = the_computations()    
    NEW_ProjectData <- data_used$NEW_ProjectData
    
    factor1 = max(1,min(input$factor1,ncol(NEW_ProjectData)))
    factor2 = max(1,min(input$factor2,ncol(NEW_ProjectData)))
    
    if (ncol(NEW_ProjectData)>=2 ){
      plot(NEW_ProjectData[,factor1],NEW_ProjectData[,factor2], 
           main="Data Visualization Using the Derived Attributes (Factors)",
           xlab=colnames(NEW_ProjectData)[factor1], 
           ylab=colnames(NEW_ProjectData)[factor2])
    } else {
      plot(NEW_ProjectData[,1],ProjectData[,1], 
           main="Only 1 Derived Variable: Using Initial Variable",
           xlab="Derived Variable (Factor) 1", 
           ylab="Initial Variable (Factor) 2")    
    }
  })
  
  # Now the report and slides  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_slides_and_report <-reactive({
    input$datafile_name_coded
    input$factor_attributes_used
    input$manual_numb_factors_used
    input$rotation_used
    input$MIN_VALUE
    
    all_inputs <- user_inputs()
    
    #############################################################
    # A list of all the (SAME) parameters that the report takes from RunStudy.R
    list(
      ProjectData = all_inputs$ProjectData,
      ProjectDataFactor = all_inputs$ProjectDataFactor,
      factor_attributes_used = all_inputs$factor_attributes_used,
      manual_numb_factors_used = all_inputs$manual_numb_factors_used,
      rotation_used = all_inputs$rotation_used,
      MIN_VALUE = all_inputs$MIN_VALUE
    )    
  })
  
  # The new report 
  
  output$report = downloadHandler(
    filename <- function() {paste(paste('Report_s23',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Report_s23.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Report_s23.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Report_s23.html', sep="/")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      ProjectDataFactor = reporting_data$ProjectDataFactor
      factor_attributes_used = reporting_data$factor_attributes_used
      manual_numb_factors_used = reporting_data$manual_numb_factors_used
      rotation_used = reporting_data$rotation_used
      MIN_VALUE = reporting_data$MIN_VALUE
      
      minimum_variance_explained = 65 # it is not used in the app anyway
      factor_selectionciterion = "manual" # this is manual as the user defines everything via the app
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Report_s23.Rmd",sep="/"),filename.Rmd,overwrite=T)
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
    filename <- function() {paste(paste('Slides_s23',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Slides_s23.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Slides_s23.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Slides_s23.html', sep="/")
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      ProjectDataFactor = reporting_data$ProjectDataFactor
      factor_attributes_used = reporting_data$factor_attributes_used
      manual_numb_factors_used = reporting_data$manual_numb_factors_used
      rotation_used = reporting_data$rotation_used
      MIN_VALUE = reporting_data$MIN_VALUE
      
      minimum_variance_explained = 65 # it is not used in the app anyway
      factor_selectionciterion = "manual" # this is manual as the user defines everything via the app
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Slides_s23.Rmd",sep="/"),filename.Rmd,overwrite=T)
      slidify(filename.Rmd)
      
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      file.remove(filename.Rmd)
      file.remove(filename.md)
      file.rename(filename.html, file) # move pdf to file for downloading      
    },    
    contentType = 'application/pdf'
  )
  
})





