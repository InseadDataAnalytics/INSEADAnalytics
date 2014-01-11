
shinyUI(pageWithSidebar(
  ##########################################
  # STEP 1: The name of the application

  headerPanel("Factor Analysis Web App"),
  
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

    textInput("attributes_used","Check attributes to use (consecutive e.g 1:5 or separate e.g 8,11) separated with comma","1:2,4"),
    numericInput("numb_factors_used", "Select Number of Factors to use):", 2),
    selectInput("rotation_used", "Select rotation method:", 
                choices = c("varimax", "quatimax","promax","oblimin","simplimax","cluster")),
    numericInput("MIN_VALUE", "Select the threshold below which numbers in tables do not appear:", 0.5),

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
      tabPanel("Correlations",tableOutput('correlation')),
      tabPanel("Variance Explained",tableOutput('Variance_Explained_Table')),
      tabPanel("Scree Plot", plotOutput("scree")), 
      tabPanel("Unotated Factors",tableOutput('Unrotated_Factors')),
      tabPanel("Rotated Factors",tableOutput('Rotated_Factors')),
      tabPanel("Top 2 Factors Visualization", plotOutput("NEW_ProjectData")) 
    )
    
  )
))

