shinyUI(pageWithSidebar(
  
  ##########################################
  # STEP 1: The name of the application
  ##########################################
  
  headerPanel("Cluster Analysis App"),
  
  ##########################################
  # STEP 2: The left menu, which reads the data as
  # well as all the inputs exactly like the inputs in RunStudy.R
  
  sidebarPanel(
    
    HTML("Please reload the web page any time the app crashes. <strong> When it crashes the whole screen turns into grey.</strong> If it only stops reacting it may be because of 
heavy computation or traffic on the server, in which case you should simply wait. Plots may at times fade: you do <strong>not</strong> 
         need to reload the app when this happens, simply continue using the app.This is a test version. </h4>"),
    
    ###########################################################    
    # STEP 2.1: read the data
    
    HTML("<hr>"),    
    
    HTML("<center><h4>Choose a data file:<h4>"),    
    HTML("<br>"),
    selectInput('datafile_name_coded', '',
                c("Mall_Visits","Boats"),multiple = FALSE),
    
    ###########################################################
    # STEP 2.2: read the INPUTS. 
    # THESE ARE THE *SAME* INPUT PARAMETERS AS IN THE RunStudy.R
    
    HTML("<hr>"),
    HTML("<h4>Select the variables to use</h4>"),
    HTML("(<strong>Press 'ctrl' or 'shift'</strong> to select multiple  variables)"),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("segmentation_attributes_used","Segmentation variables used",  choices=c("Segmentation Variables"),selected=NULL, multiple=TRUE),
    HTML("<br>"),
    selectInput("profile_attributes_used","Profiling variables used",  choices = c("Profiling Variables"), selected=NULL, multiple=TRUE),
    HTML("<hr>"),
    
    numericInput("numb_clusters_used", "Select Number of clusters to find):", 2),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("hclust_method", "Select the Hierarchical Clustering method to use:", 
                choices = c("ward", "single", "complete", "average", "mcquitty", "median", "centroid"), selected="ward", multiple=FALSE),    
    HTML("<br>"),
    HTML("<br>"),
    selectInput("distance_used", "Select the distance metric to use for Hclust:", 
                choices = c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"), selected="euclidean", multiple=FALSE),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("kmeans_method", "Select the K-means Clustering method to use:", 
                choices = c("Hartigan-Wong", "Lloyd", "Forgy", "MacQueen"), selected="Lloyd", multiple=FALSE),    
    HTML("<br>"),
    HTML("<br>"),
    numericInput("MIN_VALUE", "Select the threshold below which numbers in tables do not appear:", 0.5),
    HTML("<center><hr>"),

    
    ###########################################################
    # STEP 2.3: buttons to download the new report and new slides 
        
    HTML("<hr>"),
    HTML("<h4>Download the new HTML report </h4>"),
    HTML("<br>"),
    HTML("<br>"),
    downloadButton('report', label = "Download"),
    HTML("<br>"),
    HTML("<br>"),
    HTML("<h4>Download the new HTML5 slides </h4>"),
    HTML("<br>"),
    HTML("(Only for small Data (not Boats!). Slides are not visible otherwise!)"),
    HTML("<br>"),
    HTML("<br>"),
    downloadButton('slide', label = "Download"),
    HTML("<hr></center>")
  ),
  
  ###########################################################
  # STEP 3: The output tabs (these follow more or less the 
  # order of the Rchunks in the report and slides)
  mainPanel(
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    # Now these are the taps one by one. 
    # NOTE: each tab has a name that appears in the web app, as well as a
    # "variable" which has exactly the same name as the variables in the 
    # output$ part of code in the server.R file 
    # (e.g. tableOutput('parameters') corresponds to output$parameters in server.r)
    
    tabsetPanel(
      tabPanel("Parameters", 
               actionButton("action_parameters", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",tableOutput('parameters'))), 
      tabPanel("Summary", 
               actionButton("action_summary", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",tableOutput('summary'))), 
      tabPanel("Histograms", 
               numericInput("var_chosen", "Select the attribute to see the Histogram for:", 1),
               actionButton("action_histograms", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('histograms'))), 
      tabPanel("Pairwise Distances",
               selectInput("dist_chosen", "Select the distance metric:",  c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"),selected="euclidean"),
               numericInput("obs_shown", "How many observations to show? First:", 5),
               actionButton("action_pairwise", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",h4("Histogram of Pairwise Distances")),
               div(class="span12",plotOutput('dist_histogram')), 
               div(class="span12",tableOutput('pairwise_dist'))), 
      tabPanel("The Dendrogram", 
               actionButton("action_dendrogram", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('dendrogram'))), 
      tabPanel("The Dendrogram Heights Plot", 
               actionButton("action_heights", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('dendrogram_heights'))), 
      tabPanel("Hclust Membership", 
               actionButton("action_hclustmemb", "Show/Update Results"),
               HTML("<br>"),
               numericInput("hclust_obs_chosen", "Select the observation to see the Hclust cluster membership for:", 1),
               div(class="span12",tableOutput('hclust_membership'))), 
      tabPanel("Kmeans Membership", 
               actionButton("action_kmeansmemb", "Show/Update Results"),
               HTML("<br>"),
               numericInput("kmeans_obs_chosen", "Select the observation to see the Kmeans cluster membership for:", 1),
               div(class="span12",tableOutput('kmeans_membership'))), 
      tabPanel("Hclust Profiling",
               actionButton("action_profile", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",tableOutput('kmeans_profiling'))), 
      tabPanel("Snake Plots", 
               selectInput("clust_method_used", "Select cluster method (kmeans or hclust):", 
                           choices = c("kmeans","hclust"), selected = "kmeans", multiple=FALSE),
               actionButton("action_snake", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('snake_plot')))
    )    
  )
))