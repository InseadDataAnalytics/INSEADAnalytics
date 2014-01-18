
if (!exists("local_directory")) {  
  local_directory <- "~/INSEADjan2014/CourseSessions/Sessions67"
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
    input$action_parameters
    
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
    input$action_summary
    
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
    input$action_histogram
    
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
  
  ############################################################
  # STEP 6: These are now just the outputs of the various tabs. There
  # is one output per tab, plot or table or... (type help(renredPlot) for example
  # to see various options) 
  
  output$summary<-renderTable({
    t(summary(new_values$ProjectData))
  })  
  
  output$euclidean_pairwise<-renderTable({
    new_values$euclidean_pairwise
  })  
  
  output$manhattan_pairwise<-renderTable({
    new_values$manhattan_pairwise
  })
  
  output$histograms <- renderPlot({  
    hist(new_values$ProjectData[,input$var_chosen], main = NULL, xlab="Histogram of Variable 1", ylab="Frequency", cex.lab=0.7, cex.axis=0.7)
  })
  
  output$dist_histogram <- renderPlot({  
    hist(new_values$Pairwise_Distances, main = NULL, 
         xlab=paste(paste("Histogram of all pairwise histogram of all pairwise Distances for",input$distance_used,sep=" "),"distance between observtions",sep=" "), ylab="Frequency")
  })
  
  output$dendrogram <- renderPlot({  
    plot(new_values$Hierarchical_Cluster,main = NULL, sub=NULL,labels = 1:nrow(new_values$ProjectData_segment), xlab="Our Observations", cex.lab=1, cex.axis=1) 
    rect.hclust(new_values$Hierarchical_Cluster, k=input$numb_clusters_used, border="red") 
  })
  
  output$dendrogram_heights <- renderPlot({  
    plot(new_values$Hierarchical_Cluster$height[length(new_values$Hierarchical_Cluster$height):1],type="l")
  })
  
  output$hclust_membership<-renderTable({
    tmp=matrix(new_values$ProjectData_with_hclust_membership[input$hclust_obs_chosen,"Cluster_Membership"],ncol=1)
    rownames(tmp)<-"Cluster Membership"
    colnames(tmp)<-input$hclust_obs_chosen
    tmp    
  })  
  
  output$kmeans_membership<-renderTable({
    tmp=matrix(new_values$ProjectData_with_kmeans_membership[input$kmeans_obs_chosen,"Cluster_Membership"],ncol=1)
    rownames(tmp)<-"Cluster Membership"
    colnames(tmp)<-input$kmeans_obs_chosen
    tmp    
  })  
  
  output$kmeans_profiling<-renderTable({
    # Must also show the standard deviations...!
    new_values$Cluster_Profile_mean
  })  
  
  output$snake_plot <- renderPlot({  
    plot(new_values$Cluster_Profile_mean[,1],type="l")
    for(i in 2:ncol(new_values$Cluster_Profile_mean)) lines(new_values$Cluster_Profile_mean[,i])
  })  
  
  
  ############################################################
  # STEP 7: There are again outputs, but they are "special" one as
  # they produce the reports and slides. See the internal structure 
  # for both of them - which is the same for both.
  
  # The new report 
  
  output$report = downloadHandler(
    filename <- function() {paste(paste('Report_s23',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste('Report_s45', 'Rmd', sep=".")
      filename.md <- paste('Report_s45', 'md', sep=".")
      filename.html <- paste('Report_s45', 'html', sep=".")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      ProjectData<-new_values$ProjectData
      ProjectData_segment<- new_values$ProjectData_segment
      ProjectData_profile <- new_values$ProjectData_profile
      numb_clusters_used<-input$numb_clusters_used
      distance_used <- input$distance_used
      MIN_VALUE<- input$MIN_VALUE
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(".cache", recursive=TRUE)      
      unlink("assets", recursive=TRUE)      
      unlink("figures", recursive=TRUE)      
      
      file.copy("../doc/Report_s45.rmd",filename.Rmd,overwrite=T)
      out = knit2html(filename.Rmd,quiet=TRUE)
      
      unlink(".cache", recursive=TRUE)      
      unlink("assets", recursive=TRUE)      
      unlink("figures", recursive=TRUE)      
      file.remove(filename.Rmd)
      file.remove(filename.md)
      
      file.rename(out, file) # move pdf to file for downloading
    },    
    contentType = 'application/pdf'
  )
  
  # The new slide 
  
  output$slide = downloadHandler(
    filename <- function() {paste(paste('Slides_s45',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste('Slides_s45', 'Rmd', sep=".")
      filename.md <- paste('Slides_s45', 'md', sep=".")
      filename.html <- paste('Slides_s45', 'html', sep=".")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      ProjectData<-new_values$ProjectData
      ProjectData_segment<- new_values$ProjectData_segment
      ProjectData_profile <- new_values$ProjectData_profile
      numb_clusters_used<-input$numb_clusters_used
      distance_used <- input$distance_used
      MIN_VALUE<- input$MIN_VALUE
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(".cache", recursive=TRUE)     
      unlink("assets", recursive=TRUE)    
      unlink("figures", recursive=TRUE)      
      
      file.copy("../doc/Slides_s45.Rmd",filename.Rmd,overwrite=T)
      slidify(filename.Rmd)
      
      unlink(".cache", recursive=TRUE)     
      unlink("assets", recursive=TRUE)    
      unlink("figures", recursive=TRUE)      
      file.remove(filename.Rmd)
      file.remove(filename.md)
      file.rename(filename.html, file) # move pdf to file for downloading      
    },    
    contentType = 'application/pdf'
  )
  
})


