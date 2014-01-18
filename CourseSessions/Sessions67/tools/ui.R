shinyUI(pageWithSidebar(
  
  ##########################################
  # STEP 1: The name of the application
  ##########################################
  
  headerPanel("Classification Analysis App"),
  
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
                c("Resort_Visits","Boat_Purchase"),multiple = FALSE),
    
    ###########################################################
    # STEP 2.2: read the INPUTS. 
    # THESE ARE THE *SAME* INPUT PARAMETERS AS IN THE RunStudy.R
    
    HTML("<hr>"),
    HTML("<h4>Select the variables to use</h4>"),
    HTML("(<strong>Press 'ctrl' or 'shift'</strong> to select multiple  variables)"),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("dependent_variable","Dependent variable",  choices=c("Dependent Variables"),selected=NULL, multiple=FALSE),
    HTML("<br>"),
    selectInput("attributes_used","Attributes to use as independent variables ",  choices = c("Independent Variables"), selected=NULL, multiple=TRUE),
    HTML("<hr>"),
    
    numericInput("estimation_data_percent", "Enter % of data to use for estimation", 70),
    HTML("<br>"),
    numericInput("validation1_data_percent", "Enter % of data to use for first validation set:", 15),
    HTML("<br>"),
    numericInput("Probability_Threshold", "Enter the Probability Threshold for classfication (default is 50):", 50),
    HTML("<br>"),
    selectInput("classification_method", "Select the classification method to use:", 
                choices = c("logistic Regression", "CART", "SVM", "Your Own")),
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
      tabPanel("Correlations",
               actionButton("action_correlations", "Show/Update Results"),
               HTML("<br>"),
               tableOutput('correlation')),
      
      tabPanel("Scatter Plots", 
               div(class="row-fluid",
                   HTML("<h5>Select the names of the variables to plot (<strong>must be variables in your dataset</strong>)</h5>"),                   
                   textInput("scatter1", "x-axis:", "PRICE"),
                   tags$hr(),
                   textInput("scatter2", "y-axis:", "SALES"),
                   tags$hr(),
                   actionButton("action_scatterplots", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("The Scatter Plot")),
                   div(class="span12",plotOutput('scatter'))
               )
      ),
      
      tabPanel("Confusion Matrices", 
               div(class="row-fluid",
                   actionButton("action_confusion", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("Estimation Data")),
                   div(class="span12",tableOutput('Confusion_Estimate')),
                   div(class="span12",h4("First Validation Data")),
                   div(class="span12",tableOutput('Confusion_Validate1')),
               )
      ),
      
      tabPanel("ROC Curves", 
               div(class="row-fluid",
                   actionButton("action_roc", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("Estimation Data")),
                   div(class="span12",plotOutput('ROC_Estimate')),
                   div(class="span12",h4("First Validation Data")),
                   div(class="span12",plotOutput('ROC_Validate1')),
               )
      ),
      
      tabPanel("Lift Curves", 
               div(class="row-fluid",
                   actionButton("action_lift", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("Estimation Data")),
                   div(class="span12",plotOutput('Lift_Estimate')),
                   div(class="span12",h4("First Validation Data")),
                   div(class="span12",plotOutput('Lift_Validate1')),
               )
      ),
      
      tabPanel("Profit Curves", 
               div(class="row-fluid",
                   numericInput("Profit11", "Enter $ value of correct positive prediction", 100),
                   HTML("<br>"),
                   numericInput("Profit01", "Enter $ cost of false positive prediction", -10),
                   HTML("<br>"),
                   numericInput("Profit00", "Enter $ value of correct negative prediction", 0),
                   HTML("<br>"),
                   numericInput("Profit01", "Enter $ cost of false negative prediction", -100),
                   HTML("<hr>"),
                   actionButton("action_profit", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("Estimation Data")),
                   div(class="span12",plotOutput('Profit_Estimate')),
                   div(class="span12",h4("First Validation Data")),
                   div(class="span12",plotOutput('Profit_Validate1')),
               )
      ),
      
      tabPanel("Test Data Performances", 
               div(class="row-fluid",
                   actionButton("action_test", "Show/Update Results"),
                   HTML("<br>"),
                   div(class="span12",h4("Test Data Confusion Matrix")),
                   div(class="span12",tableOutput('Confusion_Test')),
                   div(class="span12",h4("Test Data ROC Curve")),
                   div(class="span12",plotOutput('ROC_test')),
                   div(class="span12",h4("Test Data Lift Curve")),
                   div(class="span12",plotOutput('Lift_test')),
                   div(class="span12",h4("Test Data Profit Curve")),
                   div(class="span12",plotOutput('Profit_Test')),
               )
      )
      
    )
    
  )
))

