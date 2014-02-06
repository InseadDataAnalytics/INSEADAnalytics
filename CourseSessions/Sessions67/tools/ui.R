shinyUI(pageWithSidebar(
  
  ##########################################
  # STEP 1: The name of the application
  ##########################################
  
  headerPanel("Classification App"),
  
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
                c("Resort_Visits","Boats"),multiple = FALSE),
    
    ###########################################################
    # STEP 2.2: read the INPUTS. 
    # THESE ARE THE *SAME* INPUT PARAMETERS AS IN THE RunStudy.R
    
    HTML("<hr>"),
    HTML("<h4>Select the variables to use</h4>"),
    HTML("(<strong>Press 'ctrl' or 'shift'</strong> to select multiple  variables)"),
    HTML("<br>"),
    HTML("<br>"),
    selectInput("dependent_variable","Dependent Variable",  choices=c("Dependent Variable"),selected="Dependent Variable", multiple=FALSE),
    HTML("<br>"),
    selectInput("independent_variables","Independent Variables",  choices = c("Independent Variables"), selected="Independent Variables", multiple=TRUE),
    HTML("<hr>"),
    
    HTML("<h4>Select the Classification method(s) to consider</h4>"),
    HTML("<br>"),
    selectInput("use_tree", "CART (Classification Tree)", choices = c("0","1"), selected="0", multiple=FALSE),
    selectInput("use_log", "Logistic Regression", choices = c("0","1"), selected="0", multiple=FALSE),
    #selectInput("use_svm", "Support Vector Machine (may be slow)", choices = c("0","1"), selected="0", multiple=FALSE),
    selectInput("use_forest", "Random Forest", choices = c("0","1"), selected="0", multiple=FALSE),
    HTML("<hr>"),
    
    HTML("<h4>Select the data parameters used</h4>"),
    HTML("<br>"),
    numericInput("estimation_data_percent", "Percent of Data used for Estimation:", 80),
    HTML("<br>"),
    numericInput("validation_data_percent", "Percent of Data used for Validation 1:", 10),
    HTML("<br>"),
    selectInput("random_sampling","Random Data Sampling?",  choices=c("0","1"),selected="0", multiple=FALSE),
    HTML("<br>"),
    numericInput("Probability_Threshold", "Probability Threshold (0 to 100)", 50),
    HTML("<br>"),        
    numericInput("actual_1_predict_1", "Profit/cost for correct positive", 100),
    HTML("<br>"),    
    numericInput("actual_0_predict_1", "Profit/cost for false positive", -50),
    HTML("<br>"),    
    numericInput("actual_0_predict_0", "Profit/cost for correct negative", 0),
    HTML("<br>"),    
    numericInput("actual_1_predict_0", "Profit/cost for false negative", -75),
    HTML("<br>"),    
    HTML("<br>"),
    
    HTML("<center><hr>"),
    
    
    ###########################################################
    # STEP 2.3: buttons to download the new report and new slides 
    
    #HTML("<hr>"),
    #HTML("<h4>Download the new HTML report </h4>"),
    #HTML("<br>"),
    #HTML("<br>"),
    #downloadButton('report', label = "Download"),
    #HTML("<br>"),
    #HTML("<br>"),
    #HTML("<h4>Download the new HTML5 slides </h4>"),
    HTML("<br>"),
    HTML("<br>"),
    #downloadButton('slide', label = "Download"),
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
      tabPanel("Summary (Estimation Data Only)", 
               actionButton("action_summary", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",tableOutput('summary'))), 
      tabPanel("Histograms (Estimation Data Only)", 
               selectInput("hist_chosen","Independent Variable",  choices = c("Histogram Variable"), selected="Histogram Variable", multiple=FALSE),
               actionButton("action_histograms", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",plotOutput('histograms'))), 
      tabPanel("Box Plots (Estimation Data Only)",
               selectInput("box_chosen","Independent Variable",  choices = c("Box Variables"), selected="Box Variables", multiple=FALSE),
               actionButton("action_box", "Show/Update Results"),
               HTML("<br>"),
               div(class="span12",h4("Box Plot")),
               div(class="span12",plotOutput('box_plots'))), 
      
      tabPanel("Classification Parameters", 
               HTML("<h4>Select the Parameters of the Methods used</h4>"),
               HTML("<br>"),
               numericInput("tree_cp", "Type the Tree Complexity (e.g. 0.001 to 0.02)", 0.005),
               HTML("<br>"),    
               numericInput("svm_lambda", "SVM lambda (e.g. 100)", 100),
               HTML("<br>"),    
               selectInput("svm_kernel","SVM Kernel",  choices = c("linear","polynomial", "radial basis", "sigmoid"), selected="linear", multiple=FALSE),
               HTML("<br>"),    
               numericInput("svm_kernel_param","Type the SVM Kernel parameter (e.g. degree of polynomial or gamma of radial basis or sigmoid", 1),
               HTML("<br>"),    
               numericInput("forest_ntree", "Forest: Type the number of trees (e.g. 500)", 500),
               HTML("<br>"),    
               numericInput("forest_maxnodes", "Forest: Type the max number of terminal nodes (e.g. 5)", 5)               
      ), 
      
      tabPanel("Key Independent Variables", 
               
               selectInput("drivers_method_chosen","Method available to see",  choices = c("no choice"), selected="no choice", multiple=FALSE),
               HTML("<br><strong>(This may take some time, please wait...) </strong><br>"),
               HTML("<br>"),
               actionButton("action_drivers", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",tableOutput('drivers'))),
      tabPanel("The Tree (if selected)", 
               actionButton("action_tree", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",plotOutput('tree'))), 
      tabPanel("Hit Ratios", 
               selectInput("hit_data_chosen","Data Used",  choices = c("Estimation Data","Validation Data", "Test Data"), selected="Estimation Data", multiple=FALSE),
               selectInput("hit_method_chosen","Method(s) available to see",  choices = c("no choice"), selected="no choice", multiple=TRUE),
               HTML("<br>"),
               actionButton("action_hit", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",tableOutput('hit_rates'))), 
      tabPanel("ROC Curves", 
               selectInput("roc_data_chosen","Data Used",  choices = c("Estimation Data","Validation Data", "Test Data"), selected="Estimation Data", multiple=FALSE),
               selectInput("roc_method_chosen","Method(s) available to see",  choices = c("no choice"), selected="no choice", multiple=TRUE),
               HTML("<br>"),
               actionButton("action_roc", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",plotOutput('roc_curve'))), 
      tabPanel("Lift Curves", 
               selectInput("lift_data_chosen","Data Used",  choices = c("Estimation Data","Validation Data", "Test Data"), selected="Estimation Data", multiple=FALSE),
               selectInput("lift_method_chosen","Method(s) available to see",  choices = c("no choice"), selected="no choice", multiple=TRUE),
               HTML("<br>"),
               actionButton("action_lift", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",plotOutput('lift_curve'))), 
      tabPanel("Profit Curves", 
               selectInput("profit_data_chosen","Data Used",  choices = c("Estimation Data","Validation Data", "Test Data"), selected="Estimation Data", multiple=FALSE),
               selectInput("profit_method_chosen","Method(s) available to see",  choices = c("no choice"), selected="no choice", multiple=TRUE),
               HTML("<br>"),
               actionButton("action_profit", "Show/Update Results"),
               HTML("<hr>"),
               div(class="span12",plotOutput('profit_curve')))
    )    
  )
  ))