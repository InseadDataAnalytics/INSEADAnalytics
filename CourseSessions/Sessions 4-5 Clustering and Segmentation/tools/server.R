
# To be able to upload data up to 30MB
options(shiny.maxRequestSize=30*1024^2)

shinyServer(function(input, output,session) {
  
  ############################################################
  # STEP 1: Create the place to keep track of all the new variables 
  # based on the inputs of the user 
  
  new_values<-reactiveValues()  
  
  ############################################################
  # STEP 2:  Read all the input variables, which are the SAME as in RunStudy.R
  # Note: When we use these variables we need to take them from input$ and
  # NOT from new_values$ !
  
  output$parameters<-renderTable({
    
    inFile <- input$datafile_name
    if (is.null(inFile))
      return(NULL)    
    load(inFile$datapath)
    
    new_values$numb_clusters_used<-reactive({
      input$numb_factors_used
    }) 
    new_values$distance_used<-reactive({
      input$rotation_used
    })  
    new_values$MIN_VALUE<-reactive({
      input$MIN_VALUE
    })    
    
    new_values$segmentation_attributes_used<-reactive({
      eval(parse(text=paste("c(",input$segmentation_attributes_used,")",sep="")))
    })    
    
    new_values$profile_attributes_used<-reactive({
      eval(parse(text=paste("c(",input$profile_attributes_used,")",sep="")))
    })    
    
    ############################################################
    # STEP 3: Create the new dataset that will be used in Step 3, using 
    # the new inputs. Note that it uses only input$ variables
    
    new_values$ProjectData <- ProjectData
    tmp_segmentation_attributes_used<-eval(parse(text=paste("c(",input$segmentation_attributes_used,")",sep="")))  
    tmp_profile_attributes_used<-eval(parse(text=paste("c(",input$profile_attributes_used,")",sep="")))  
    new_values$tmp_segmentation_attributes_used <- tmp_segmentation_attributes_used
    new_values$tmp_profile_attributes_used <- tmp_profile_attributes_used    
    
    new_values$ProjectData_segment=new_values$ProjectData[,tmp_segmentation_attributes_used]
    new_values$ProjectData_profile=new_values$ProjectData[,tmp_profile_attributes_used]
    
    
    ############################################################
    # STEP 4: Compute all the variables used in the Report and Slides: this
    # is more or less a "cut-and-paste" from the R chunks of the reports
    
    # MOTE: again, for the input variables we must use input$ on the right hand side, 
    # and not the new_values$ !
    
    euclidean_pairwise=as.matrix(dist(head(new_values$ProjectData_segment,5),method="euclidean"))
    euclidean_pairwise=euclidean_pairwise*lower.tri(euclidean_pairwise)+euclidean_pairwise*diag(euclidean_pairwise)+10e10*upper.tri(euclidean_pairwise)
    euclidean_pairwise[euclidean_pairwise==10e10]<- NA
    
    manhattan_pairwise=as.matrix(dist(head(new_values$ProjectData_segment,5),method="manhattan"))
    manhattan_pairwise=manhattan_pairwise*lower.tri(manhattan_pairwise)+manhattan_pairwise*diag(manhattan_pairwise)+10e10*upper.tri(manhattan_pairwise)
    manhattan_pairwise[manhattan_pairwise==10e10]<- NA
    
    Pairwise_Distances <- dist(new_values$ProjectData, method = input$distance_used) # distance matrix
    
    Hierarchical_Cluster_distances<-dist(new_values$ProjectData_segment,method=input$distance_used)
    Hierarchical_Cluster <- hclust(Hierarchical_Cluster_distances, method="ward")
    
    cluster_memberships_hclust <- as.vector(cutree(Hierarchical_Cluster, k=input$numb_clusters_used)) # cut tree into 3 clusters
    cluster_ids_hclust=unique(cluster_memberships_hclust)
    ProjectData_with_hclust_membership <- cbind(new_values$ProjectData,cluster_memberships_hclust)
    colnames(ProjectData_with_hclust_membership)<-c(colnames(new_values$ProjectData),"Cluster_Membership")
    
    kmeans_clusters <- kmeans(new_values$ProjectData_segment,centers= input$numb_clusters_used, iter.max=1000, algorithm="Lloyd")
    ProjectData_with_kmeans_membership <- cbind(new_values$ProjectData,kmeans_clusters$cluster)
    colnames(ProjectData_with_kmeans_membership)<-c(colnames(new_values$ProjectData),"Cluster_Membership")
    
    cluster_memberships_kmeans <- kmeans_clusters$cluster 
    cluster_ids_kmeans=unique(cluster_memberships_kmeans)
    cluster_memberships=cluster_memberships_kmeans
    cluster_ids = cluster_ids_kmeans
    Cluster_Profile_mean=sapply(cluster_ids,function(i) apply(new_values$ProjectData_profile[(cluster_memberships==i),],2,mean))
    colnames(Cluster_Profile_mean)<- paste("Segment",1:length(cluster_ids),sep=" ")
    Cluster_Profile_sd=sapply(cluster_ids,function(i) apply(new_values$ProjectData_profile[cluster_memberships==i,],2,sd))
    colnames(Cluster_Profile_sd)<- paste("Segment",1:length(cluster_ids),sep=" ")
    
    ############################################################
    # STEP 5: Store all new calculated variables in new_values$ so that the tabs 
    # read them directly. 
    # NOTE: the tabs below do not do many calculations as they are all done in Step 4
    
    new_values$euclidean_pairwise <- euclidean_pairwise
    new_values$manhattan_pairwise <- manhattan_pairwise
    new_values$Pairwise_Distances <- Pairwise_Distances
    new_values$Hierarchical_Cluster <- Hierarchical_Cluster
    new_values$cluster_memberships_hclust <- cluster_memberships_hclust
    new_values$cluster_ids_hclust <- cluster_ids_hclust
    new_values$ProjectData_with_hclust_membership <- ProjectData_with_hclust_membership
    new_values$kmeans_clusters <- kmeans_clusters
    new_values$ProjectData_with_kmeans_membership <- ProjectData_with_kmeans_membership
    new_values$Cluster_Profile_mean <- Cluster_Profile_mean
    new_values$Cluster_Profile_sd <- Cluster_Profile_sd
    
    #############################################################
    # STEP 5b: Print whatever basic information about the selected data needed. 
    # THese will show in the first tab of the application (called "parameters")
    
    allparameters=c(nrow(new_values$ProjectData), ncol(new_values$ProjectData),
                    ncol(new_values$ProjectData_segment), ncol(new_values$ProjectData_profile),
                    input$numb_clusters_used, input$distance_used,
                    colnames(new_values$ProjectData)[new_values$tmp_segmentation_attributes_used],
                    colnames(new_values$ProjectData)[new_values$tmp_profile_attributes_used]
    )
    allparameters<-matrix(allparameters,ncol=1)    
    rownames(allparameters)<-c("Total number of observations", "Total number of attributes", 
                               "Number of segmentation used", "Number of profiling attributes used", 
                               "Number of clusters to get", "Distance Metric",
                               paste("Attrbute Used for Segmentation:",1:length(new_values$tmp_segmentation_attributes_used)),
                               paste("Attrbute Used for Profiling:",1:length(new_values$tmp_profile_attributes_used))
    )
    colnames(allparameters)<-NULL
    allparameters<-as.data.frame(allparameters)
    return(allparameters)   
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


