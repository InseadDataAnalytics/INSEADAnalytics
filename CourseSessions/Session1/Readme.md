Data Analytics Course Session: 
---------------------------------------------------------

"Session 1 of INSEAD Data Analytics for Business Course: "Introduction to Data Analytics"
---------------------------------------------------------

**Organization:** INSEAD

**Industry:** Education

**Project Description:** Introduction to Data Analytics for Business (INSEAD COURSE)

**Data Description:** Only Slides, No Data

**Author(s):** T. Evgeniou

**Author(s)' Affiliations:** INSEAD

INSTRUCTIONS FOR PROJECT
---------------------------------------------------------

(*NOTE: The very first time you run the project it may take a couple of minutes as it will also install all necessary R libraries. These are listed in the library.R file in the R_code directory*).


This will reproduce the default report and slides of this session project. You can then click on the generated HTML files in the doc directory to view the report or the slides.

To modify the text of the report or the slides, please edit the .Rmd files in the doc directory.  After any modifications please source file RunStudy.R again to generate the new slides

**Note:** Sourcing the RunStudy.R file will create a new html file in the doc directory (for the slides). If you want to publish that online, you will need to move it to a gh-pages branch and delete it from the master branch afterwards. To do so please follow the following steps:

1. commit the files in your master branch

2. switch to the gh-pages branch (from the *Shell* (under the *Tools* menu), type *git checkout gh-pages*)

3. Once in the gh-pages branch, you can copy the html files from the master branch by typing in the shell file the command *git checkout master doc/Slides_s1.html*. Your slides are now available online through gh-pages.

4. You should now go back to the master branch (in the *Shell* type *git checkout master*) and delete the html file from the doc directory (before pushing any new material back on your master branch on github).
