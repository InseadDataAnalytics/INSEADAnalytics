---
title: "A Market Segmentation and Purchase Drivers Process"
author: "T. Evgeniou"
output:
  html_document:
    css: ../../AnalyticsStyles/default.css
    theme: paper
    toc: yes
    toc_float:
      collapsed: no
      smooth_scroll: yes
  pdf_document:
    includes:
      in_header: ../../AnalyticsStyles/default.sty
always_allow_html: yes
---

<!-- **Note:** Assuming the working directory is "MYDIRECTORY/INSEADAnalytics" (where you have cloned the course material), you can create an html file by running in your console the command rmarkdown::render("CourseSessions/InClassProcess/MarketSegmentationProcessInClass.Rmd") -->

> **IMPORTANT**: Please make sure you create a copy of this file with a customized name, so that your work (e.g. answers to the questions) is not over-written when you pull the latest content from the course github. 
This is a **template process for market segmentation based on survey data**, using the  [Boats cases A](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-A-prerelease.pdf) and  [B](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-B-prerelease.pdf).

All material and code is available at the INSEAD Data Science for Business website and GitHub. Before starting, make sure you have pulled the [course files](https://github.com/InseadDataAnalytics/INSEADAnalytics) on your GitHub repository. As always, you can use the `help` command in Rstudio to find out about any R function (e.g. type `help(list.files)` to learn what the R function `list.files` does).

**Note:** you can create an html file by running in your console the command 
rmarkdown::render("CourseSessions/InClassProcess/MarketSegmentationProcessInClass.Rmd") 
(see also a [potential issue with plots](https://github.com/InseadDataAnalytics/INSEADAnalytics/issues/75))

<hr>\clearpage

# The Business Questions

This process can be used as a (starting) template for projects like the one described in the [Boats cases A](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-A-prerelease.pdf) and  [B](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-B-prerelease.pdf). For example (but not only), in this case some of the business questions were: 

- What are the main purchase drivers of the customers (and prospects) of this company? 

- Are there different market segments? Which ones? Do the purchase drivers differ across segments? 

- What (possibly market segment specific) product development or brand positioning strategy should the company follow in order to increase its sales? 

See for example some of the analysis of this case in  these slides: <a href="http://inseaddataanalytics.github.io/INSEADAnalytics/Sessions2_3 Handouts.pdf"  target="_blank"> part 1</a> and <a href="http://inseaddataanalytics.github.io/INSEADAnalytics/Sessions4_5 Handouts.pdf"  target="_blank"> part 2</a>.

<hr>\clearpage

# The Process

The "high level" process template is split in 3 parts, corresponding to the course sessions 7-8, 9-10, and an optional last part: 

1. *Part 1*: We use some of the survey questions (e.g. in this case the first 29 "attitude" questions) to find **key customer descriptors** ("factors") using *dimensionality reduction* techniques described in the [Dimensionality Reduction](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions23/FactorAnalysisReading.html) reading of Sessions 7-8.

2. *Part 2*: We use the selected customer descriptors to **segment the market** using *cluster analysis* techniques described in the [Cluster Analysis ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions45/ClusterAnalysisReading.html) reading of Sessions 9-10.

3. *Part 3*: For the market segments we create, we will use *classification analysis* to classify people based on whether or not they have purchased a product and find what are the **key purchase drivers per segment**. For this part we will use [classification analysis ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/ClassificationProcessCreditCardDefault.html) techniques.

Finally, we will use the results of this analysis to make business decisions, e.g. about brand positioning, product development, etc., depending on our market segments and key purchase drivers we find at the end of this process.


```
## Error in eval(ei, envir): object 'tags' not found
```

```
## Error in ggthemr("fresh"): could not find function "ggthemr"
```

<hr>\clearpage

# The Data

First we load the data to use (see the raw .Rmd file to change the data file as needed):


```r
# Please ENTER the name of the file with the data used. The file should be a
# .csv with one row per observation (e.g. person) and one column per
# attribute. Do not add .csv at the end, make sure the data are numeric.
datafile_name = "../Sessions23/data/Boats.csv"

# Please enter the minimum number below which you would like not to print -
# this makes the readability of the tables easier. Default values are either
# 10e6 (to print everything) or 0.5. Try both to see the difference.
MIN_VALUE = 0.5

# Please enter the maximum number of observations to show in the report and
# slides.  DEFAULT is 10. If the number is large the report may be slow.
max_data_report = 10
```



<hr>\clearpage

# Part 1: Key Customer Characteristics

The code used here is along the lines of the code in the reading  [FactorAnalysisReading.Rmd](https://github.com/InseadDataAnalytics/INSEADAnalytics/blob/master/CourseSessions/Sessions23/FactorAnalysisReading.Rmd). We follow the process described in the [Dimensionality Reduction ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions23/FactorAnalysisReading.html) reading. 

In this part we also become familiar with:

1. Some visualization tools;
2. Principal Component Analysis and Factor Analysis;
3. Introduction to machine learning methods.

(All user inputs for this part should be selected in the code chunk in the raw .Rmd file) 


```r
# Please ENTER the original raw attributes to use.  Please use numbers, not
# column names, e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
factor_attributes_used = c(2:30)

# Please ENTER the selection criteria for the factors to use.  Choices:
# 'eigenvalue', 'variance', 'manual'
factor_selectionciterion = "eigenvalue"

# Please ENTER the desired minumum variance explained (Only used in case
# 'variance' is the factor selection criterion used).
minimum_variance_explained = 65  # between 1 and 100

# Please ENTER the number of factors to use (Only used in case 'manual' is
# the factor selection criterion used).
manual_numb_factors_used = 15

# Please ENTER the rotation eventually used (e.g. 'none', 'varimax',
# 'quatimax', 'promax', 'oblimin', 'simplimax', and 'cluster' - see
# help(principal)). Default is 'varimax'
rotation_used = "varimax"
```



## Steps 1-2: Check the Data 

Start by some basic visual exploration of, say, a few data:


```
## Error in color_bar(rgb(238, 238, 238, max = 255), normalize.abs, min = 0.1, : could not find function "color_bar"
```

The data we use here have the following descriptive statistics: 


```
## Error in color_bar(rgb(238, 238, 238, max = 255), normalize.abs, min = 0.1, : could not find function "color_bar"
```

## Step 3: Check Correlations

This is the correlation matrix of the customer responses to the 29 attitude questions - which are the only questions that we will use for the segmentation (see the case):


```
## Error in color_bar(rgb(238, 238, 238, max = 255), normalize.abs, min = 0.1, : could not find function "color_bar"
```

**Questions**

1. Do you see any high correlations between the responses? Do they make sense? 
2. What do these correlations imply?

**Answers:**

*
*
*
*
*
*
*
*
*
*


## Step 4: Choose number of factors

Clearly the survey asked many redundant questions (can you think some reasons why?), so we may be able to actually "group" these 29 attitude questions into only a few "key factors". This not only will simplify the data, but will also greatly facilitate our understanding of the customers.

To do so, we use methods called [Principal Component Analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) and [factor analysis](https://en.wikipedia.org/wiki/Factor_analysis) as also discussed in the [Dimensionality Reduction readings](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions23/FactorAnalysisReading.html). We can use two different R commands for this (they make slightly different information easily available as output): the command `principal` (check `help(principal)` from R package [psych](http://personality-project.org/r/psych/)), and the command `PCA` from R package [FactoMineR](http://factominer.free.fr) - there are more packages and commands for this, as these methods are very widely used.  


```
## Error in principal(ProjectDataFactor, nfactors = ncol(ProjectDataFactor), : could not find function "principal"
```

```
## Error in eval(expr, envir, enclos): object 'UnRotated_Results' not found
```

```
## Error in as.data.frame(unclass(UnRotated_Factors)): object 'UnRotated_Factors' not found
```

```
## Error in ncol(UnRotated_Factors): object 'UnRotated_Factors' not found
```


```
## Error in PCA(ProjectDataFactor, graph = FALSE): could not find function "PCA"
```

```
## Error in eval(expr, envir, enclos): object 'Variance_Explained_Table_results' not found
```

```
## Error in eval(expr, envir, enclos): object 'Variance_Explained_Table' not found
```

```
## Error in nrow(Variance_Explained_Table): object 'Variance_Explained_Table' not found
```

```
## Error in colnames(Variance_Explained_Table) <- c("Eigenvalue", "Pct of explained variance", : object 'Variance_Explained_Table' not found
```

Let's look at the **variance explained** as well as the **eigenvalues** (see session readings):


```
## Error in iprint.df(round(Variance_Explained_Table, 2)): object 'Variance_Explained_Table' not found
```


```
## Error in eval(expr, envir, enclos): object 'Variance_Explained_Table' not found
```

```
## Error in as.data.frame(eigenvalues): object 'eigenvalues' not found
```

```
## Error in `colnames<-`(`*tmp*`, value = c("eigenvalues", "components", : attempt to set 'colnames' on an object with less than two dimensions
```

```
## Error in c3(df, x = x, y = y, group = v, width = "100%", height = "480px"): could not find function "c3"
```

**Questions:**

1. Can you explain what this table and the plot are? What do they indicate? What can we learn from these?
2. Why does the plot have this specific shape? Could the plotted line be increasing? 
3. What characteristics of these results would we prefer to see? Why?

**Answers**

*
*
*
*
*
*
*
*
*
*

## Step 5: Interpret the factors

Let's now see how the "top factors" look like. 


```
## Error in eval(expr, envir, enclos): object 'Variance_Explained_Table_copy' not found
```









































































