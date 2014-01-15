
shinyUI(pageWithSidebar(
  ##########################################
  # STEP 1: The name of the application
  
  headerPanel("Classification Analysis Web App"),

  ##########################################
  # STEP 2: The left menu, which reads the data as
  # well as all the inputs exactly like the inputs in RunStudy.R
  
  # STEP 2.1: read the data
  
  sidebarPanel(
    HTML("<center><h3>Data Upload </h3>
         <strong> Note: File must contain data matrix named ProjectData</strong>
         </center>"),
    fileInput('datafile_name', 'Choose File (R data)'),
    #tags$hr(),
    HTML("<hr>"),
    HTML("<center><strong> Note:Please go to the Parameters Tab when you change the parameters below </strong>
         </center>"),    
    HTML("<hr>"),
    
    ###########################################################
    # STEP 2.2: read the INPUTS. 
    # THESE ARE THE *SAME* INPUT PARAMETERS AS IN THE RunStudy.R

    textInput("dependent_variable","Enter the name of the dependent variable","Visit"),
    textInput("attributes_used","Enter the attributes to use as independent variables (consecutive e.g 1:5 or separate e.g 8,11) separated with comma","1:2,4"),
    numericInput("estimation_data_percent", "Enter % of data to use for estimation", 80),
    numericInput("validation1_data_percent", "Enter % of data to use for first validation set:", 20),
    numericInput("Probability_Threshold", "Enter the Probability Threshold for classfication (default is 50):", 50),
    selectInput("classification_method", "Select the classification method to use:", 
                choices = c("WORK IN PROGRESS", "WORK IN PROGRESS", "WORK IN PROGRESS")),

    ###########################################################
    # STEP 2.3: buttons to download the new report and new slides 
    
    HTML("<hr>"),
    HTML("<h4>Download the new report </h4>"),
    downloadButton('report', label = "Download"),
    HTML("<hr>"),
    HTML("<h4>Download the new slides </h4>"),
    downloadButton('slide', label = "Download"),
    HTML("<hr>")
    
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
      tabPanel("Parameters", tableOutput('parameters')),      
      tabPanel("Summary", tableOutput('summary')),
      
      tabPanel("Euclidean Pairwise Distances",tableOutput('euclidean_pairwise')),
      tabPanel("Manhattan Pairwise Distance",tableOutput('manhattan_pairwise')),
      tabPanel("Histograms", 
               numericInput("var_chosen", "Select the attribute to see the Histogram for:", 1),
               plotOutput('histograms')),
      tabPanel("Pairwise Distances Histogram", plotOutput("dist_histogram")), 
      tabPanel("The Dendrogram", plotOutput("dendrogram")), 
      tabPanel("The Dendrogram Heights Plot", plotOutput("dendrogram_heights")), 
      tabPanel("Hclust Membership", 
               numericInput("hclust_obs_chosen", "Select the observation to see the Hclust cluster membership for:", 1),
               tableOutput('hclust_membership')),
      tabPanel("Kmeans Membership", 
               numericInput("kmeans_obs_chosen", "Select the observation to see the Kmeans cluster membership for:", 1),
               tableOutput('kmeans_membership')),
      tabPanel("Kmeans Profiling", tableOutput('kmeans_profiling')),
      tabPanel("The Snake Plot", plotOutput("snake_plot"))      
      
    )
    
  )
))

