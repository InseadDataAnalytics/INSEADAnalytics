
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
    
    new_values$numb_factors_used<-reactive({
      input$numb_factors_used
    }) 
    new_values$rotation_used<-reactive({
      input$rotation_used
    })  
    new_values$MIN_VALUE<-reactive({
      input$MIN_VALUE
    })    
    
    new_values$attributes_used<-reactive({
      eval(parse(text=paste("c(",input$attributes_used,")",sep="")))
    })    
    
    ############################################################
    # STEP 3: Create the new dataset that will be used in Step 3, using 
    # the new inputs. Note that it uses only input$ variables
    
    new_values$ProjectData <- ProjectData
    tmp_attributes_used<-eval(parse(text=paste("c(",input$attributes_used,")",sep="")))  
    new_values$tmp_attributes_used <- tmp_attributes_used
    new_values$ProjectDataFactor <- new_values$ProjectData[,tmp_attributes_used]
    
    ############################################################
    # STEP 4: Compute all the variables used in the Report and Slides: this
    # is more or less a "cut-and-paste" from the R chunks of the reports
    
    # MOTE: again, for the input variables we must use input$ on the right hand side, 
    # and not the new_values$ !
    
    correl<-corstars(new_values$ProjectDataFactor)
    
    Unrotated_Results<-principal(new_values$ProjectDataFactor, nfactors=ncol(new_values$ProjectDataFactor), rotate="none")
    Unrotated_Factors<-Unrotated_Results$loadings
    Unrotated_Factors<-as.data.frame(unclass(Unrotated_Factors))
    colnames(Unrotated_Factors)<-paste("Component",1:ncol(Unrotated_Factors),sep=" ")
    Unrotated_Factors[abs(Unrotated_Factors) < input$MIN_VALUE]<-NA
    
    Variance_Explained_Table_results<-PCA(new_values$ProjectDataFactor, graph=FALSE)
    Variance_Explained_Table<-Variance_Explained_Table_results$eig
    
    eigenvalues<-Unrotated_Results$values
    
    Rotated_Results<-principal(new_values$ProjectDataFactor, nfactors=ncol(new_values$ProjectDataFactor), rotate=input$rotation_used,score=TRUE)
    Rotated_Factors<-Rotated_Results$loadings
    Rotated_Factors<-as.data.frame(unclass(Rotated_Factors))
    colnames(Rotated_Factors)<-paste("Component",1:ncol(Rotated_Factors),sep=" ")
    
    Rotated_Factors[abs(Rotated_Factors) < input$MIN_VALUE]<-NA
    if (sum(eigenvalues>=1) >=1){
      NEW_ProjectData <- Rotated_Results$scores[,1:sum(eigenvalues>=1),drop=F]
      colnames(NEW_ProjectData)<-paste("Derived Variable (Factor)",1:ncol(NEW_ProjectData),sep=" ")
    } else {
      NEW_ProjectData <- Rotated_Results$scores[,1,drop=F]
      colnames(NEW_ProjectData)<-"Derived Variable (Factor) eigenvalue <1"
    }
    
    ############################################################
    # STEP 5: Store all new calculated variables in new_values$ so that the tabs 
    # read them directly. 
    # NOTE: the tabs below do not do many calculations as they are all done in Step 4
    
    new_values$correl <- correl
    new_values$Unrotated_Results <- Unrotated_Results
    new_values$Unrotated_Factors <- Unrotated_Factors
    new_values$Variance_Explained_Table_results <- Variance_Explained_Table_results
    new_values$Variance_Explained_Table <- Variance_Explained_Table
    new_values$eigenvalues <- eigenvalues
    new_values$Rotated_Results <- Rotated_Results
    new_values$Rotated_Factors <- Rotated_Factors
    new_values$NEW_ProjectData <- NEW_ProjectData
    
    #############################################################
    # STEP 5b: Print whatever basic information about the selected data needed. 
    # THese will show in the first tab of the application (called "parameters")
    
    allparameters=c(nrow(new_values$ProjectData), ncol(new_values$ProjectData),
                    nrow(new_values$ProjectDataFactor), ncol(new_values$ProjectDataFactor),
                    input$numb_factors_used, input$rotation_used,
                    colnames(new_values$ProjectData)[new_values$tmp_attributes_used])
    allparameters<-matrix(allparameters,ncol=1)    
    rownames(allparameters)<-c("Total number of observations", "Total number of attributes", 
                               "Number of observations used", "Number of attributes used", 
                               "Number of factors", "Rotation",
                               paste("Attrbute Used for Factors:",1:length(new_values$tmp_attributes_used)))
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
  
  output$correlation<-renderTable({
    corstars(new_values$ProjectDataFactor)
  })  
  
  output$Unrotated_Factors<-renderTable({
    new_values$Unrotated_Factors
  })
  
  output$Variance_Explained_Table<-renderTable({
    new_values$Variance_Explained_Table
  })
  
  output$Rotated_Factors<-renderTable({
    new_values$Rotated_Factors
  })
  
  output$scree <- renderPlot({  
    plot(new_values$eigenvalues)
  })
  
  output$NEW_ProjectData<-renderPlot({   
    NEW_ProjectData <- new_values$NEW_ProjectData
    if (ncol(NEW_ProjectData)>=2){
      plot(NEW_ProjectData[,1],NEW_ProjectData[,2], 
           main="Data Visualization Using the top 2 Derived Attributes (Factors)",
           xlab="Derived Variable (Factor) 1", 
           ylab="Derived Variable (Factor) 2")
    } else {
      plot(NEW_ProjectData[,1],ProjectData[,2], 
           main="Only 1 Derived Variable: Using Initial Variable",
           xlab="Derived Variable (Factor) 1", 
           ylab="Initial Variable (Factor) 2")    
    }
  })
  
  ############################################################
  # STEP 7: There are again outputs, but they are "special" one as
  # they produce the reports and slides. See the internal structure 
  # for both of them - which is the same for both.
  
  # The new report 
  
  output$report = downloadHandler(
    filename <- function() {paste(paste('Report_s23',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste('Report_s23', 'Rmd', sep=".")
      filename.md <- paste('Report_s23', 'md', sep=".")
      filename.html <- paste('Report_s23', 'html', sep=".")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      ProjectData<-new_values$ProjectData
      ProjectDataFactor<- new_values$ProjectDataFactor
      numb_factors_used<-input$numb_factors_used
      rotation_used <- input$rotation_used
      attributes_used <- new_values$tmp_attributes_used
      MIN_VALUE<- input$MIN_VALUE
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(".cache", recursive=TRUE)      
      unlink("assets", recursive=TRUE)      
      unlink("figures", recursive=TRUE)      
      
      file.copy("../doc/Report_s23.rmd",filename.Rmd,overwrite=T)
      file.copy("../doc/All3.png","All3.png",overwrite=T)
      out = knit2html(filename.Rmd,quiet=TRUE)
      
      unlink(".cache", recursive=TRUE)      
      unlink("assets", recursive=TRUE)      
      unlink("figures", recursive=TRUE)      
      file.remove(filename.Rmd)
      file.remove(filename.md)
      file.remove("All3.png")
      
      file.rename(out, file) # move pdf to file for downloading
    },    
    contentType = 'application/pdf'
  )
  
  # The new slide 
  
  output$slide = downloadHandler(
    filename <- function() {paste(paste('Slides_s23',Sys.time() ),'.html')},
    
    content = function(file) {
      
      filename.Rmd <- paste('Slides_s23', 'Rmd', sep=".")
      filename.md <- paste('Slides_s23', 'md', sep=".")
      filename.html <- paste('Slides_s23', 'html', sep=".")
      
      #############################################################
      # All the (SAME) parameters that the report takes from RunStudy.R
      ProjectData<-new_values$ProjectData
      ProjectDataFactor<- new_values$ProjectDataFactor
      numb_factors_used<-input$numb_factors_used
      rotation_used <- input$rotation_used
      attributes_used <- new_values$tmp_attributes_used
      MIN_VALUE<- input$MIN_VALUE
      #############################################################
      
      if (file.exists(filename.html))
        file.remove(filename.html)
      unlink(".cache", recursive=TRUE)     
      unlink("assets", recursive=TRUE)    
      unlink("figures", recursive=TRUE)      
      
      file.copy("../doc/Slides_s23.Rmd",filename.Rmd,overwrite=T)
      file.copy("../doc/All3.png","All3.png",overwrite=T)
      slidify(filename.Rmd)
      
      unlink(".cache", recursive=TRUE)     
      unlink("assets", recursive=TRUE)    
      unlink("figures", recursive=TRUE)      
      file.remove(filename.Rmd)
      file.remove(filename.md)
      file.remove("All3.png")
      file.rename(filename.html, file) # move pdf to file for downloading      
    },    
    contentType = 'application/pdf'
  )
  
})


