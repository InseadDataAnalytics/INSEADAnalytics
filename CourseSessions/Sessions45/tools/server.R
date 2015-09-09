
#local_directory <- "YOURDIRECTORY/INSEADAnalytics/CourseSessions/Sessions45"
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
    
    updateSelectInput(session, "segmentation_attributes_used","Segmentation variables used",  colnames(ProjectData), selected=colnames(ProjectData)[1])
    updateSelectInput(session, "profile_attributes_used","Profiling variables used",  colnames(ProjectData), selected=colnames(ProjectData)[1])
    
    ProjectData
  })
  
  user_inputs <- reactive({
    input$datafile_name_coded
    input$segmentation_attributes_used
    input$profile_attributes_used
    input$numb_clusters_used
    input$distance_used
    input$hclust_method
    input$kmeans_method
    input$MIN_VALUE
    
    ProjectData = read_dataset()
    
    ProjectData_segment = ProjectData[,input$segmentation_attributes_used,drop=F]
    ProjectData_profile = ProjectData[,input$profile_attributes_used,drop=F]
    
    list(ProjectData = read_dataset(), 
         ProjectData_segment = ProjectData_segment,
         ProjectData_profile = ProjectData_profile,
         segmentation_attributes_used = input$segmentation_attributes_used, 
         profile_attributes_used = input$profile_attributes_used,
         numb_clusters_used = min(nrow(ProjectData_segment), max(2,input$numb_clusters_used)),
         distance_used = input$distance_used,
         hclust_method = input$hclust_method,
         kmeans_method = input$kmeans_method,
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
    input$segmentation_attributes_used
    input$profile_attributes_used
    input$numb_clusters_used
    input$distance_used
    input$hclust_method
    input$kmeans_method
    input$MIN_VALUE
    input$action_parameters
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData 
    ProjectData_segment = all_inputs$ProjectData_segment
    ProjectData_profile = all_inputs$ProjectData_profile
    segmentation_attributes_used = all_inputs$segmentation_attributes_used 
    profile_attributes_used = all_inputs$profile_attributes_used
    numb_clusters_used = all_inputs$numb_clusters_used
    distance_used = all_inputs$distance_used
    hclust_method = all_inputs$hclust_method
    kmeans_method = all_inputs$kmeans_method
    MIN_VALUE = all_inputs$MIN_VALUE                    
    
    
    allparameters=c(nrow(ProjectData), ncol(ProjectData),
                    ncol(ProjectData_segment), ncol(ProjectData_profile),
                    numb_clusters_used, distance_used,hclust_method,kmeans_method,
                    segmentation_attributes_used,profile_attributes_used
    )
    allparameters<-matrix(allparameters,ncol=1)    
    theparameter_names <- c("Total number of observations", "Total number of attributes", 
                            "Number of segmentation attributes used", "Number of profiling attributes used", 
                            "Number of clusters to get", "Distance Metric", "Hclust Method", "Kmeans Method",
                            paste("SEGMENTATION Attribute:",1:length(segmentation_attributes_used), sep=" "),
                            paste("PROFILING Attrbute:",1:length(profile_attributes_used), sep=" ")
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
    
    my_summary(ProjectData)
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
    input$var_chosen
    input$action_histograms
    
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
  
  
  ########## The pairwise distances Tab
  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_pairwise_dist_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$segmentation_attributes_used
    input$dist_chosen
    input$obs_shown
    input$action_pairwise
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    ProjectData_segment = all_inputs$ProjectData_segment
    ProjectData_profile = all_inputs$ProjectData_profile
    
    pairwise_dist=as.matrix(dist(ProjectData_segment,method=input$dist_chosen))
    pairwise_dist=pairwise_dist*lower.tri(pairwise_dist)+pairwise_dist*diag(pairwise_dist)+10e10*upper.tri(pairwise_dist)
    pairwise_dist[pairwise_dist==10e10]<- NA
    
    pairwise_dist
  })
  
  # Now pass to ui.R what it needs to display this tab
  output$dist_histogram <- renderPlot({  
    hist(the_pairwise_dist_tab(), main = NULL, 
         xlab=paste(paste("Histogram of all pairwise Distances for",input$dist_chosen,sep=" "),"distance between observtions",sep=" "), ylab="Frequency")
  })
  
  output$pairwise_dist<-renderTable({
    the_pairwise_dist_tab()[1:input$obs_shown, 1:input$obs_shown]
  })  
  
  
  ########## The next few tabs use the same "heavy computation" results for Hclust, so we do these only once
  
  the_hclust_computations<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$segmentation_attributes_used
    input$numb_clusters_used
    input$distance_used
    input$MIN_VALUE    
    input$hclust_method
    input$kmeans_method
    
    input$action_dendrogram
    input$action_heights
    
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    ProjectData_profile = all_inputs$ProjectData_profile
    ProjectData_segment = all_inputs$ProjectData_segment
    distance_used = all_inputs$distance_used
    numb_clusters_used = all_inputs$numb_clusters_used
    hclust_method = all_inputs$hclust_method
    kmeans_method = input$kmeans_method
    
    Hierarchical_Cluster_distances<-dist(ProjectData_segment,method=distance_used)
    Hierarchical_Cluster <- hclust(Hierarchical_Cluster_distances, method=hclust_method)
    
    
    cluster_memberships <- as.vector(cutree(Hierarchical_Cluster, k=numb_clusters_used)) # cut tree into 3 clusters
    cluster_ids <- unique(cluster_memberships)
    
    ProjectData_with_hclust_membership <- cbind(cluster_memberships, ProjectData)
    colnames(ProjectData_with_hclust_membership)<-c("Cluster_Membership",colnames(ProjectData))
    
    Cluster_Profile_mean <- sapply(cluster_ids, function(i) apply(ProjectData_profile[(cluster_memberships==i), ,drop=F], 2, mean))
    if (ncol(ProjectData_profile) <2)
      Cluster_Profile_mean=t(Cluster_Profile_mean)
    colnames(Cluster_Profile_mean) <- paste("Segment (AVG)", 1:length(cluster_ids), sep=" ")
    
    list(
      ProjectData_segment = ProjectData_segment,
      Hierarchical_Cluster = Hierarchical_Cluster,
      cluster_memberships = cluster_memberships,
      cluster_ids = cluster_ids,
      Cluster_Profile_mean = Cluster_Profile_mean,
      ProjectData_with_hclust_membership = ProjectData_with_hclust_membership
    )
  })
  
  ########## The Hcluster related Tabs now
  
  output$dendrogram <- renderPlot({  
    input$action_dendrogram
    data_used = the_hclust_computations()
    
    plot(data_used$Hierarchical_Cluster,main = NULL, sub=NULL,labels = 1:nrow(data_used$ProjectData_segment), xlab="Our Observations", cex.lab=1, cex.axis=1) 
    rect.hclust(data_used$Hierarchical_Cluster, k=input$numb_clusters_used, border="red") 
  })
  
  output$dendrogram_heights <- renderPlot({  
    input$action_heights
    data_used = the_hclust_computations()
    
    plot(data_used$Hierarchical_Cluster$height[length(data_used$Hierarchical_Cluster$height):1],type="l")
  })
  
  
  ########## The  Hcluster Membership Tab  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_Hcluster_member_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$hclust_obs_chosen
    input$action_hclustmemb
    data_used = the_hclust_computations()    
    
    hclust_obs_chosen=matrix(data_used$ProjectData_with_hclust_membership[input$hclust_obs_chosen,"Cluster_Membership"],ncol=1)
    rownames(hclust_obs_chosen)<-"Cluster Membership"
    colnames(hclust_obs_chosen)<-input$hclust_obs_chosen
    hclust_obs_chosen
  })
  
  output$hclust_membership<-renderTable({
    data_used = the_Hcluster_member_tab()
    data_used    
  })  
  
  
  ########## The next few tabs use the same "heavy computation" results for kmeans, so we do these only once
  
  the_kmeans_tab<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$datafile_name_coded
    input$segmentation_attributes_used
    input$numb_clusters_used
    input$distance_used
    input$MIN_VALUE    
    input$hclust_method
    input$kmeans_method
    input$action_kmeansmemb
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    ProjectData_profile = all_inputs$ProjectData_profile
    ProjectData_segment = all_inputs$ProjectData_segment
    distance_used = all_inputs$distance_used
    numb_clusters_used = all_inputs$numb_clusters_used
    hclust_method = all_inputs$hclust_method
    kmeans_method = input$kmeans_method
    
    kmeans_clusters <- kmeans(ProjectData_segment,centers= numb_clusters_used, iter.max=1000, algorithm=kmeans_method)
    
    ProjectData_with_kmeans_membership <- cbind(kmeans_clusters$cluster, ProjectData)
    colnames(ProjectData_with_kmeans_membership)<-c("Cluster_Membership", colnames(ProjectData))
    
    cluster_memberships <- kmeans_clusters$cluster 
    cluster_ids <- unique(cluster_memberships)
    
    Cluster_Profile_mean <- sapply(cluster_ids, function(i) apply(ProjectData_profile[(cluster_memberships==i), ,drop=F], 2, mean))
    if (ncol(ProjectData_profile) <2)
      Cluster_Profile_mean=t(Cluster_Profile_mean)
    colnames(Cluster_Profile_mean) <- paste("Segment (AVG)", 1:length(cluster_ids), sep=" ")
    
    
    list(
      kmeans_clusters = kmeans_clusters,
      cluster_memberships = cluster_memberships,
      Cluster_Profile_mean = Cluster_Profile_mean,
      ProjectData_with_kmeans_membership = ProjectData_with_kmeans_membership
    )
  })
  
  ########## The Kmeans related Tabs now
  
  kmeans_membership<-reactive({
    # list the user inputs the tab depends on (easier to read the code)
    input$action_kmeansmemb
    input$kmeans_obs_chosen
    data_used = the_kmeans_tab()    
    
    kmeans_obs_chosen=matrix(data_used$ProjectData_with_kmeans_membership[input$kmeans_obs_chosen,"Cluster_Membership"],ncol=1)
    rownames(kmeans_obs_chosen)<-"Cluster Membership"
    colnames(kmeans_obs_chosen)<-input$kmeans_obs_chosen
    kmeans_obs_chosen
  })
  
  output$kmeans_membership<-renderTable({
    data_used = kmeans_membership()
    data_used    
  })  
  
  output$kmeans_profiling<-renderTable({
    input$action_profile
    
    #data_used = the_kmeans_tab()  
    data_used = the_hclust_computations()
    # Must also show the standard deviations...!
    data_used$Cluster_Profile_mean
  })  
  
  
  ### Now do the snake plot tab. first the reactive
  
  snake_plot_tab <- reactive({  
    input$clust_method_used
    input$action_snake
    
    all_inputs <- user_inputs()
    ProjectData = all_inputs$ProjectData
    ProjectData_profile = all_inputs$ProjectData_profile
    
    data_used_kmeans = the_kmeans_tab()    
    data_used_hclust = the_hclust_computations()
    
    ProjectData_scaled_profile=apply(ProjectData_profile,2, function(r) {if (sd(r)!=0) res=(r-mean(r))/sd(r) else res=0*r; res})
    if (input$clust_method_used == "hclust"){ 
      cluster_memberships = data_used_hclust$cluster_memberships
    } else {
      cluster_memberships = data_used_kmeans$cluster_memberships      
    }
    
    cluster_ids = unique(cluster_memberships)
    Cluster_Profile_standar_mean <- sapply(cluster_ids, function(i) apply(ProjectData_scaled_profile[(cluster_memberships==i), ,drop=F], 2, mean))
    if (ncol(ProjectData_scaled_profile) < 2)
      Cluster_Profile_standar_mean = t(Cluster_Profile_standar_mean)
    colnames(Cluster_Profile_standar_mean) <- paste("Segment (AVG)", 1:length(cluster_ids), sep=" ")
    
    list(Cluster_Profile_standar_mean = Cluster_Profile_standar_mean,
         cluster_ids = cluster_ids)
  })
  
  # now pass it to ui.R
  output$snake_plot <- renderPlot({  
    data_used=snake_plot_tab()
    Cluster_Profile_standar_mean = data_used$Cluster_Profile_standar_mean
    cluster_ids = data_used$cluster_ids
    
    plot(Cluster_Profile_standar_mean[, 1,drop=F], type="l", col="red", main="Snake plot for each cluster", ylab="mean of cluster", xlab="profiling variables (standardized)",ylim=c(min(Cluster_Profile_standar_mean),max(Cluster_Profile_standar_mean))) 
    for(i in 2:ncol(Cluster_Profile_standar_mean))
      lines(Cluster_Profile_standar_mean[, i], col="blue")
  })  
  
  # Now the report and slides  
  # first the reactive function doing all calculations when the related inputs were modified by the user
  
  the_slides_and_report <-reactive({
    input$datafile_name_coded
    input$segmentation_attributes_used
    input$profile_attributes_used
    input$numb_clusters_used
    input$distance_used
    input$hclust_method
    input$kmeans_method
    input$MIN_VALUE
    
    all_inputs <- user_inputs()
    
    #############################################################
    # A list of all the (SAME) parameters that the report takes from RunStudy.R
    list(
      ProjectData = all_inputs$ProjectData,
      ProjectData_segment = all_inputs$ProjectData_segment,
      ProjectData_profile = all_inputs$ProjectData_profile,
      segmentation_attributes_used = all_inputs$segmentation_attributes_used, 
      profile_attributes_used = all_inputs$profile_attributes_used,
      numb_clusters_used = all_inputs$numb_clusters_used,
      distance_used = all_inputs$distance_used,
      hclust_method = all_inputs$hclust_method,
      kmeans_method = all_inputs$kmeans_method,
      MIN_VALUE = all_inputs$MIN_VALUE
    )    
  })
  
  # The new report 
  
  output$report = downloadHandler(
    filename <- function() {paste(paste('Report_s45',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Report_s45.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Report_s45.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Report_s45.html', sep="/")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      segmentation_attributes_used = reporting_data$segmentation_attributes_used
      profile_attributes_used = reporting_data$profile_attributes_used
      numb_clusters_used = reporting_data$numb_clusters_used
      distance_used = reporting_data$distance_used
      hclust_method = reporting_data$hclust_method
      kmeans_method = reporting_data$kmeans_method
      MIN_VALUE = reporting_data$MIN_VALUE
      ProjectData_segment = reporting_data$ProjectData_segment
      ProjectData_profile = reporting_data$ProjectData_profile            
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figures', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Report_s45.Rmd",sep="/"),filename.Rmd,overwrite=T)
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
    filename <- function() {paste(paste('Slides_s45',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste(local_directory, 'tools/Slides_s45.Rmd', sep="/")
      filename.md <- paste(local_directory, 'tools/Slides_s45.md', sep="/")
      filename.html <- paste(local_directory, 'tools/Slides_s45.html', sep="/")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      reporting_data<- the_slides_and_report()
      
      ProjectData = reporting_data$ProjectData
      segmentation_attributes_used = reporting_data$segmentation_attributes_used
      profile_attributes_used = reporting_data$profile_attributes_used
      numb_clusters_used = reporting_data$numb_clusters_used
      distance_used = reporting_data$distance_used
      hclust_method = reporting_data$hclust_method
      kmeans_method = reporting_data$kmeans_method
      MIN_VALUE = reporting_data$MIN_VALUE
      ProjectData_segment = reporting_data$ProjectData_segment
      ProjectData_profile = reporting_data$ProjectData_profile            
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(paste(local_directory, 'tools/.cache', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/assets', sep="/"), recursive=TRUE)
      unlink(paste(local_directory, 'tools/figure', sep="/"), recursive=TRUE)
      
      file.copy(paste(local_directory,"doc/Slides_s45.Rmd",sep="/"),filename.Rmd,overwrite=T)
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


