shinyUI(pageWithSidebar(
  
  ##########################################
  # STEP 1: The name of the application
  ##########################################
  
  headerPanel("Factor Analysis Web App"),
  
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
    selectInput('datafile_name_coded', '',
                c("MBAadmin","Boats"),multiple = FALSE),
    
    ###########################################################
    # STEP 2.2: read the INPUTS. 
    # THESE ARE THE *SAME* AS THE NECESSARY INPUT PARAMETERS IN RunStudy.R
    
    HTML("<hr>"),
    HTML("<h4>Select the variables to use</h4>"),
    HTML("(<strong>Press 'ctrl' or 'shift'</strong> to select multiple  variables)"),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("factor_attributes_used","Variables used for Factor Analysis",  choices=c("attributes used"),selected=NULL, multiple=TRUE),
    HTML("<br>"),
    selectInput("rotation_used", "Select rotation method:", 
                choices = c("varimax", "quatimax","promax","oblimin","simplimax","cluster")),
    numericInput("MIN_VALUE", "Select the threshold below which numbers in the factors tables do not appear in the report:", 0.5),
    numericInput("manual_numb_factors_used", "Select Number of Factors to use in the Reports:", 2),
    
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
               actionButton("action_histogram", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('histograms'))), 
      tabPanel("Correlations",
               selectInput("show_colnames", "Show column names? (0 or 1):", choices=c("0","1"),selected=1, multiple=FALSE),               
               actionButton("action_correlations", "Show/Update Results"),
               HTML("<br>"),
               tableOutput('correlation')),
      tabPanel("Variance Explained",
               actionButton("action_variance", "Show/Update Results"),
               HTML("<br>"),
               tableOutput('Variance_Explained_Table')),
      tabPanel("Scree Plot", 
               actionButton("action_scree", "Show/Update Results"),
               HTML("<br>"),
               htmlOutput("scree")), 
      tabPanel("Unotated Factors",
               numericInput("unrot_number", "Select the the number of factors to see:",3),
               selectInput("show_colnames_unrotate", "Show variable names? (0 or 1):", choices=c("0","1"),selected=1, multiple=FALSE),               
               actionButton("action_unrotated", "Show/Update Results"),
               HTML("<br>"),
               HTML("<br>"),
               tableOutput('Unrotated_Factors')),
      tabPanel("Rotated Factors",
               selectInput("show_colnames_rotate", "Show variable names? (0 or 1):", choices=c("0","1"),selected=1, multiple=FALSE),               
               actionButton("action_rotated", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",h5("Showing Factors for the number of factors you selected in the right pane")),
               tableOutput('Rotated_Factors')),
      tabPanel("Factors Visualization", 
               numericInput("factor1", "Select the the x-axis factors to use:",1),
               numericInput("factor2", "Select the the y-axis factors to use:",2),             
               actionButton("action_visual", "Show/Update Results"),
               HTML("<br>"),
               plotOutput("NEW_ProjectData")) 
    )
    
  )
))
