Data Analytics Course Session: 
---------------------------------------------------------
Sessions 2-3 of INSEAD Data Analytics for Business Course: Dimensionality Reduction and Derived Attributes 
---------------------------------------------------------


**Organization:** INSEAD

**Industry:** Education

**Project Description:** Introduction to Data Analytics for Business (INSEAD COURSE)

**Data Description:** Basic Example Data

**Author(s):** T. Evgeniou

**Author(s)' Affiliations:** INSEAD

INSTRUCTIONS FOR PROJECT
---------------------------------------------------------

(*NOTE: The very first time you run the project it may take a couple of minutes as it will also install all necessary R libraries. These are listed in the library.R file in the R_code directory*).


[1] Please open and source the file RunStudy.R 

This will reproduce the default report and slides of this project, as well as  start the web-application for this project

You can then click on the generated HTML files in the doc directory to view the report or the slides.

**MODIFYING AND RE-RUNNING**

[2] To modify the project parameters, please edit them in the file 

RunStudy.R

and source this file again. A new report, slides, and (if needed) web application will be launched. 

(NOTE: if the web application is running, you will need to first stop that by clicking on the "stop" button in the concole window of your Rstudio)


[3] To modify the text of the report or the slides, please edit the .Rmd files in the Reports_Slides directory. To modify the Web Application please edit the ui.R and server.R files in the tools directory. After any modifications please repeat step 2 to generate the new report, slides, and launch the new Web application. 

[4] You can modify the parameters of the project and generate new customized reports through the web application. 

**Note:** Please press the stop button in the Console window to stop running the web application when needed.

**Note:** Sourcing the RunStudy.R file will create 2 new html file in the doc directory (one for the report and one for the slides). If you want to publish those online, you will need to move them to a gh-pages branch and delete them from the master branch afterwards. To do so please follow the following steps:

1. commit the files in your master branch

2. switch to the gh-pages branch (from the *Shell* (under the *Tools* menu), type *git checkout gh-pages*)

3. Once in the gh-pages branch, you can copy the html files from the master branch by typing in the shell file the command *git checkout master doc/Report_s23.html* and *git checkout master doc/Slides_s23.html*. Your report and slides are now available online through gh-pages.

4. You should now go back to the master branch (in the *Shell* type *git checkout master*) and delete the 2 html files from the doc directory (before pushing any new material back on your master branch on github).
