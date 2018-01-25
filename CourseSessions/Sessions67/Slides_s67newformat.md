Session 7-8, Discriminant Analysis and Classification (Technical Slides)
========================================================
author : T. Evgeniou, A. Ovchinnikov, INSEAD
title : Data Analytics for Business





Example Applications
========================================================

- Which molecules are most likely to succeed for the drug?
- Whose DNA is most likely to indicate future health problems of a particular type?
- Who are the most likely clients/companies/countries to default on their debt?
- Who are most likely to click on an ad? 
- To whom should we offer a particular promotion?
- How are satisfied customers different from dissatisfied customers in terms of their demographics and attitudes towards your products??? characteristics?
- Which transaction is most likely a fraud?
- Which applicants are most likely to fit in our organization and succeed?
- Which investments are most likely to succeed?



What is common to these problems?
========================================================

1. There is a dependent variable which is categorical e.g. success vs failure (fit vs. non-fit; fraud vs. non-fraud, response vs. non-response, etc.)

2. There are some independent variables which we can use to explain membership in the different categories



Example: Boats Purchase Drivers
========================================================

Who would be the most likely customers to purchase a boat in the future or to recommend their brand?

What would be the **key drivers** that affect people's decision to purchase or recommend?


Various Methods
========================================================

- Logistic regression
- Classification trees
- Boosted Trees
- Nearest Neighbors
- Neural Networks
- Bayesian methods
- Support Vector Machines
- Deep learning methods
- others...




Classification: A Process
========================================================

1. Create an estimation and two validation samples in a balanced way 
2. Setup the dependent variable (what is a success?)
3. Assess and select the independent variables
4. Estimate model (many methods, we consider only 2 here)
5. Assess performance on first validation data, repeat steps 2-5 as necessary
6. Assess performance on second validation data once



Data Splits: Example Split
========================================================

Estimation Data: 80% of the data

Validation Data: 10% of the data

Test Data: 10% of the data





Example: Some Data
========================================================
<style>
.wrapper{


width: 100%;

overflow-x: scroll;

}
.wrapper1{

height:450px;
overflow-y: scroll;
}
</style>
<div class="wrapper wrapper1">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Number of Observations per class in the Estimation Sample </caption>
<tr> <th>  </th> <th> Variables </th> <th> Q16.1 </th> <th> Q16.2 </th> <th> Q16.3 </th> <th> Q16.4 </th> <th> Q16.5 </th> <th> Q16.6 </th> <th> Q16.7 </th> <th> Q16.8 </th> <th> Q16.9 </th> <th> Q16.10 </th> <th> Q16.11 </th> <th> Q16.12 </th> <th> Q16.13 </th> <th> Q16.14 </th> <th> Q16.15 </th> <th> Q16.16 </th> <th> Q16.17 </th> <th> Q16.18 </th> <th> Q16.19 </th> <th> Q16.20 </th> <th> Q16.21 </th> <th> Q16.22 </th> <th> Q16.23 </th> <th> Q16.24 </th> <th> Q16.25 </th> <th> Q16.26 </th> <th> Q16.27 </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> 1 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 2 </td> <td> 2 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 3 </td> <td> 3 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 4 </td> <td> 4 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 5 </td> <td> 5 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 1.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 6 </td> <td> 6 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 7 </td> <td> 7 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 8 </td> <td> 8 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 9 </td> <td> 9 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 10 </td> <td> 10 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 2.0 </td> <td align="right"> 2.0 </td> <td align="right"> 1.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 11 </td> <td> 11 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 12 </td> <td> 12 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 13 </td> <td> 13 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 14 </td> <td> 14 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 15 </td> <td> 15 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 16 </td> <td> 16 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 17 </td> <td> 17 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 18 </td> <td> 18 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 19 </td> <td> 19 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 20 </td> <td> 20 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 21 </td> <td> 21 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 22 </td> <td> 22 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 23 </td> <td> 23 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 24 </td> <td> 24 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 25 </td> <td> 25 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 26 </td> <td> 26 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 27 </td> <td> 27 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 28 </td> <td> 28 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 29 </td> <td> 29 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 30 </td> <td> 30 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 31 </td> <td> 31 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 32 </td> <td> 32 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 33 </td> <td> 33 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 34 </td> <td> 34 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 35 </td> <td> 35 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 36 </td> <td> 36 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> </tr>
  <tr> <td align="right"> 37 </td> <td> 37 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 38 </td> <td> 38 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 39 </td> <td> 39 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 40 </td> <td> 40 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 41 </td> <td> 41 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 42 </td> <td> 42 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 43 </td> <td> 43 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 44 </td> <td> 44 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 3.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 45 </td> <td> 45 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 46 </td> <td> 46 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> <td align="right"> 3.0 </td> </tr>
  <tr> <td align="right"> 47 </td> <td> 47 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 48 </td> <td> 48 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 2.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> </tr>
  <tr> <td align="right"> 49 </td> <td> 49 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
  <tr> <td align="right"> 50 </td> <td> 50 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 5.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 3.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> <td align="right"> 4.0 </td> </tr>
   </table>
</div>



CART: Classification Trees
========================================================



<center>
![plot of chunk unnamed-chunk-5](Slides_s67newformat-figure/unnamed-chunk-5-1.png)
</center>



Another Classification Tree
========================================================

<center>
![plot of chunk unnamed-chunk-6](Slides_s67newformat-figure/unnamed-chunk-6-1.png)
</center>



KEY QUESTION: Model Complexity
========================================================

Do we want a "large" or a "small" tree? 

How complex should our classifier be?








Logistic Regression
========================================================

<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:400px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Logistic Regression: Estimated Coefficients </caption>
<tr> <th>  </th> <th> Estimate </th> <th> Std. Error </th> <th> z value </th> <th> Pr(&gt;|z|) </th>  </tr>
  <tr> <td align="right"> (Intercept) </td> <td align="right"> -0.8 </td> <td align="right"> 0.4 </td> <td align="right"> -2.1 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.1 </td> <td align="right"> 0.0 </td> <td align="right"> 0.0 </td> <td align="right"> 0.4 </td> <td align="right"> 0.7 </td> </tr>
  <tr> <td align="right"> Q16.2 </td> <td align="right"> -0.2 </td> <td align="right"> 0.1 </td> <td align="right"> -3.4 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.3 </td> <td align="right"> 0.0 </td> <td align="right"> 0.1 </td> <td align="right"> 0.2 </td> <td align="right"> 0.9 </td> </tr>
  <tr> <td align="right"> Q16.4 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -0.9 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.5 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.1 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.6 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -1.3 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.7 </td> <td align="right"> -0.0 </td> <td align="right"> 0.1 </td> <td align="right"> -0.1 </td> <td align="right"> 1.0 </td> </tr>
  <tr> <td align="right"> Q16.8 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.8 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.9 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 2.1 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.10 </td> <td align="right"> 0.2 </td> <td align="right"> 0.1 </td> <td align="right"> 3.3 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.11 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -2.0 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.12 </td> <td align="right"> 0.2 </td> <td align="right"> 0.1 </td> <td align="right"> 3.2 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.13 </td> <td align="right"> -0.2 </td> <td align="right"> 0.1 </td> <td align="right"> -2.4 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.14 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -1.4 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.15 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.3 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.16 </td> <td align="right"> -0.3 </td> <td align="right"> 0.1 </td> <td align="right"> -4.4 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.17 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -1.7 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.18 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -1.0 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.19 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.8 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.20 </td> <td align="right"> 0.0 </td> <td align="right"> 0.1 </td> <td align="right"> 0.3 </td> <td align="right"> 0.8 </td> </tr>
  <tr> <td align="right"> Q16.21 </td> <td align="right"> 0.2 </td> <td align="right"> 0.1 </td> <td align="right"> 2.2 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.22 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 0.9 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.23 </td> <td align="right"> -0.0 </td> <td align="right"> 0.1 </td> <td align="right"> -0.5 </td> <td align="right"> 0.6 </td> </tr>
  <tr> <td align="right"> Q16.24 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.5 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.25 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> -1.1 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.26 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.6 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.27 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 1.8 </td> <td align="right"> 0.1 </td> </tr>
   </table>
</div>





Drivers Analysis
========================================================

<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:400px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Logistic Regression: Estimated Coefficients </caption>
<tr> <th>  </th> <th> CART 1 </th> <th> CART 2 </th> <th> Logistic Regr. </th>  </tr>
  <tr> <td align="right"> Q16.1 </td> <td align="right"> 0.0 </td> <td align="right"> 0.0 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.2 </td> <td align="right"> -1.0 </td> <td align="right"> -0.9 </td> <td align="right"> -0.8 </td> </tr>
  <tr> <td align="right"> Q16.3 </td> <td align="right"> 0.2 </td> <td align="right"> 0.4 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.4 </td> <td align="right"> -0.3 </td> <td align="right"> -0.8 </td> <td align="right"> -0.2 </td> </tr>
  <tr> <td align="right"> Q16.5 </td> <td align="right"> 0.2 </td> <td align="right"> 0.7 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.6 </td> <td align="right"> -0.1 </td> <td align="right"> -0.1 </td> <td align="right"> -0.3 </td> </tr>
  <tr> <td align="right"> Q16.7 </td> <td align="right"> -0.0 </td> <td align="right"> -0.1 </td> <td align="right"> -0.0 </td> </tr>
  <tr> <td align="right"> Q16.8 </td> <td align="right"> 0.1 </td> <td align="right"> 0.7 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.9 </td> <td align="right"> 0.0 </td> <td align="right"> 0.0 </td> <td align="right"> 0.5 </td> </tr>
  <tr> <td align="right"> Q16.10 </td> <td align="right"> 0.0 </td> <td align="right"> 0.5 </td> <td align="right"> 0.7 </td> </tr>
  <tr> <td align="right"> Q16.11 </td> <td align="right"> -0.3 </td> <td align="right"> -0.2 </td> <td align="right"> -0.5 </td> </tr>
  <tr> <td align="right"> Q16.12 </td> <td align="right"> 0.1 </td> <td align="right"> 0.7 </td> <td align="right"> 0.7 </td> </tr>
  <tr> <td align="right"> Q16.13 </td> <td align="right"> -0.2 </td> <td align="right"> -0.3 </td> <td align="right"> -0.5 </td> </tr>
  <tr> <td align="right"> Q16.14 </td> <td align="right"> -0.2 </td> <td align="right"> -0.2 </td> <td align="right"> -0.3 </td> </tr>
  <tr> <td align="right"> Q16.15 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.16 </td> <td align="right"> -0.6 </td> <td align="right"> -0.6 </td> <td align="right"> -1.0 </td> </tr>
  <tr> <td align="right"> Q16.17 </td> <td align="right"> -0.5 </td> <td align="right"> -0.8 </td> <td align="right"> -0.4 </td> </tr>
  <tr> <td align="right"> Q16.18 </td> <td align="right"> -0.1 </td> <td align="right"> -0.4 </td> <td align="right"> -0.2 </td> </tr>
  <tr> <td align="right"> Q16.19 </td> <td align="right"> 0.3 </td> <td align="right"> 0.3 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.20 </td> <td align="right"> 0.3 </td> <td align="right"> 0.3 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.21 </td> <td align="right"> 1.0 </td> <td align="right"> 1.0 </td> <td align="right"> 0.5 </td> </tr>
  <tr> <td align="right"> Q16.22 </td> <td align="right"> 0.6 </td> <td align="right"> 0.7 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.23 </td> <td align="right"> -0.4 </td> <td align="right"> -0.4 </td> <td align="right"> -0.1 </td> </tr>
  <tr> <td align="right"> Q16.24 </td> <td align="right"> 0.5 </td> <td align="right"> 0.4 </td> <td align="right"> 0.3 </td> </tr>
  <tr> <td align="right"> Q16.25 </td> <td align="right"> -0.2 </td> <td align="right"> -0.9 </td> <td align="right"> -0.2 </td> </tr>
  <tr> <td align="right"> Q16.26 </td> <td align="right"> 0.3 </td> <td align="right"> 0.2 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.27 </td> <td align="right"> 0.0 </td> <td align="right"> 0.7 </td> <td align="right"> 0.4 </td> </tr>
   </table>
</div>



Hit Ratio: Validation Data
========================================================
<div class="row">
<div class="col-md-6">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Validation Data Hit Ratios for different classifiers tested </caption>
<tr> <th>  </th> <th> Hit Ratio </th>  </tr>
  <tr> <td align="right"> First CART </td> <td align="right"> 60.1 </td> </tr>
  <tr> <td align="right"> Second CART </td> <td align="right"> 55.9 </td> </tr>
  <tr> <td align="right"> Logistic Regression </td> <td align="right"> 54.4 </td> </tr>
   </table>
</div>
</div>



Hit Ratio: Estimation Data
========================================================
<div class="row">
<div class="col-md-6">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Estimation Data Hit Ratios for different classifiers tested </caption>
<tr> <th>  </th> <th> Hit Ratio </th>  </tr>
  <tr> <td align="right"> First CART </td> <td align="right"> 59.6 </td> </tr>
  <tr> <td align="right"> Second CART </td> <td align="right"> 64.0 </td> </tr>
  <tr> <td align="right"> Logistic Regression </td> <td align="right"> 59.7 </td> </tr>
   </table>
</div>
</div>



Fit versus Prediction

========================================================
Should the performance of our model be similar in the estimation and validation data? 

How about when we deploy the model?

Why should performance be different? Why should it not? What can we do about it?




Hit Ratios: Test Data for best validation hit rate method
========================================================
<div class="row">
<div class="col-md-6">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Test Data Hit Ratios for different classifiers tested </caption>
<tr> <th>  </th> <th> Hit Ratio </th>  </tr>
  <tr> <td align="right"> First CART </td> <td align="right"> 56.0 </td> </tr>
  <tr> <td align="right"> Second CART </td> <td align="right"> 54.3 </td> </tr>
  <tr> <td align="right"> Logistic Regression </td> <td align="right"> 58.5 </td> </tr>
   </table>
</div>
</div>



Confusion Matrix: Test Data
========================================================
<div class="row">
<div class="col-md-6">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Confusion Matrix for test data </caption>
<tr> <th>  </th> <th> Predicted 1 </th> <th> Predicted 0 </th>  </tr>
  <tr> <td align="right"> Actual 1 </td> <td align="right"> 48.8 </td> <td align="right"> 51.2 </td> </tr>
  <tr> <td align="right"> Actual 0 </td> <td align="right"> 61.8 </td> <td align="right"> 38.2 </td> </tr>
   </table>
</div>
</div>



ROC Curves: Test Data
========================================================

(black: CART 1; red: CART 2; blue: logistic regression):





![plot of chunk unnamed-chunk-17](Slides_s67newformat-figure/unnamed-chunk-17-1.png)



Lift Curves: Test Data
========================================================


<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:450px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">

<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f96cb67395 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
100,
100
],
[
98.58156028,
98.4
],
[
98.58156028,
98.4
],
[
98.58156028,
98.4
],
[
42.90780142,
48.8
],
[
42.90780142,
48.8
],
[
42.90780142,
48.8
],
[
0,
0
],
[
0,
0
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f96cb67395() {
var data = gvisDataLineChartIDe9f96cb67395();
var options = {};
options["allowHtml"] = true;
options["title"] = "Lift Curve for test data CART";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent of data', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:' Percent of Class 1'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f96cb67395')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f96cb67395);
})();
function displayChartLineChartIDe9f96cb67395() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f96cb67395"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f96cb67395" 
  style="width: 600; height: 400;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f93e5e72f5 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
100,
100
],
[
99.29078014,
99.2
],
[
92.90780142,
94.4
],
[
92.90780142,
94.4
],
[
79.07801418,
82.4
],
[
79.07801418,
82.4
],
[
79.07801418,
82.4
],
[
51.77304965,
56.8
],
[
45.74468085,
52
],
[
45.74468085,
52
],
[
45.74468085,
52
],
[
45.74468085,
52
],
[
3.546099291,
4.8
],
[
3.546099291,
4.8
],
[
3.546099291,
4.8
],
[
0.7092198582,
0.8
],
[
0.7092198582,
0.8
],
[
0.7092198582,
0.8
],
[
0,
0
],
[
0,
0
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f93e5e72f5() {
var data = gvisDataLineChartIDe9f93e5e72f5();
var options = {};
options["allowHtml"] = true;
options["title"] = "Lift Curve for test data CART large";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent of data', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Percent of Class 1'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f93e5e72f5')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f93e5e72f5);
})();
function displayChartLineChartIDe9f93e5e72f5() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f93e5e72f5"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f93e5e72f5" 
  style="width: 600; height: 400;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f92acd52d0 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
100,
100
],
[
100,
100
],
[
100,
100
],
[
100,
100
],
[
100,
100
],
[
99.29078014,
100
],
[
99.29078014,
100
],
[
99.29078014,
100
],
[
98.58156028,
100
],
[
98.58156028,
100
],
[
97.87234043,
99.2
],
[
97.87234043,
99.2
],
[
97.16312057,
98.4
],
[
97.16312057,
98.4
],
[
97.16312057,
98.4
],
[
97.16312057,
98.4
],
[
97.16312057,
98.4
],
[
97.16312057,
98.4
],
[
96.45390071,
98.4
],
[
95.74468085,
97.6
],
[
95.74468085,
97.6
],
[
95.03546099,
96.8
],
[
93.97163121,
96
],
[
93.61702128,
95.2
],
[
93.61702128,
95.2
],
[
92.90780142,
94.4
],
[
91.4893617,
93.6
],
[
90.07092199,
92.8
],
[
89.71631206,
92
],
[
89.36170213,
91.2
],
[
89.36170213,
91.2
],
[
89.36170213,
91.2
],
[
89.0070922,
90.4
],
[
87.94326241,
89.6
],
[
87.23404255,
88.8
],
[
87.23404255,
88.8
],
[
86.5248227,
88
],
[
86.5248227,
88
],
[
86.5248227,
88
],
[
86.5248227,
88
],
[
85.81560284,
88
],
[
85.81560284,
88
],
[
85.81560284,
88
],
[
85.81560284,
88
],
[
85.81560284,
88
],
[
83.33333333,
86.4
],
[
83.33333333,
86.4
],
[
83.33333333,
86.4
],
[
82.62411348,
86.4
],
[
82.62411348,
86.4
],
[
82.62411348,
86.4
],
[
80.85106383,
84.8
],
[
79.43262411,
83.2
],
[
79.07801418,
83.2
],
[
79.07801418,
83.2
],
[
78.72340426,
83.2
],
[
78.72340426,
83.2
],
[
78.36879433,
82.4
],
[
77.30496454,
81.6
],
[
76.95035461,
80.8
],
[
76.95035461,
80.8
],
[
76.95035461,
80.8
],
[
76.59574468,
80
],
[
76.59574468,
80
],
[
76.59574468,
80
],
[
75.53191489,
79.2
],
[
74.82269504,
77.6
],
[
74.82269504,
77.6
],
[
74.46808511,
76.8
],
[
74.46808511,
76.8
],
[
74.46808511,
76.8
],
[
73.04964539,
76.8
],
[
73.04964539,
76.8
],
[
72.34042553,
76.8
],
[
72.34042553,
76.8
],
[
72.34042553,
76.8
],
[
72.34042553,
76.8
],
[
71.27659574,
75.2
],
[
71.27659574,
75.2
],
[
69.85815603,
74.4
],
[
69.14893617,
74.4
],
[
69.14893617,
74.4
],
[
69.14893617,
74.4
],
[
69.14893617,
74.4
],
[
69.14893617,
74.4
],
[
69.14893617,
74.4
],
[
68.43971631,
72.8
],
[
68.43971631,
72.8
],
[
65.95744681,
70.4
],
[
65.60283688,
69.6
],
[
64.89361702,
69.6
],
[
64.89361702,
69.6
],
[
64.89361702,
69.6
],
[
64.53900709,
69.6
],
[
64.53900709,
69.6
],
[
64.53900709,
69.6
],
[
64.53900709,
69.6
],
[
64.53900709,
69.6
],
[
64.53900709,
69.6
],
[
64.18439716,
69.6
],
[
64.18439716,
69.6
],
[
63.12056738,
68.8
],
[
63.12056738,
68.8
],
[
63.12056738,
68.8
],
[
62.76595745,
68
],
[
62.41134752,
68
],
[
61.34751773,
68
],
[
60.9929078,
68
],
[
60.9929078,
68
],
[
60.9929078,
68
],
[
60.63829787,
67.2
],
[
59.57446809,
66.4
],
[
58.86524823,
65.6
],
[
58.86524823,
65.6
],
[
58.15602837,
65.6
],
[
57.80141844,
65.6
],
[
57.80141844,
65.6
],
[
57.09219858,
64.8
],
[
56.73758865,
64.8
],
[
53.54609929,
62.4
],
[
53.54609929,
62.4
],
[
52.83687943,
62.4
],
[
52.4822695,
62.4
],
[
52.4822695,
62.4
],
[
52.4822695,
62.4
],
[
52.4822695,
62.4
],
[
52.12765957,
62.4
],
[
51.77304965,
62.4
],
[
51.41843972,
62.4
],
[
50.70921986,
60.8
],
[
50,
60.8
],
[
50,
60.8
],
[
50,
60.8
],
[
49.64539007,
60
],
[
48.93617021,
58.4
],
[
48.93617021,
58.4
],
[
48.58156028,
58.4
],
[
47.5177305,
57.6
],
[
47.5177305,
57.6
],
[
45.39007092,
52.8
],
[
45.39007092,
52.8
],
[
45.03546099,
52.8
],
[
44.68085106,
52
],
[
44.32624113,
51.2
],
[
42.90780142,
48.8
],
[
42.55319149,
48
],
[
42.55319149,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.84397163,
48
],
[
41.4893617,
48
],
[
41.13475177,
47.2
],
[
41.13475177,
47.2
],
[
40.42553191,
45.6
],
[
40.07092199,
45.6
],
[
40.07092199,
45.6
],
[
39.36170213,
44
],
[
39.36170213,
44
],
[
39.0070922,
43.2
],
[
39.0070922,
43.2
],
[
39.0070922,
43.2
],
[
38.65248227,
42.4
],
[
37.58865248,
42.4
],
[
37.23404255,
41.6
],
[
37.23404255,
41.6
],
[
37.23404255,
41.6
],
[
36.87943262,
40.8
],
[
36.5248227,
40
],
[
35.46099291,
38.4
],
[
35.46099291,
38.4
],
[
35.46099291,
38.4
],
[
34.75177305,
38.4
],
[
32.62411348,
36
],
[
31.56028369,
34.4
],
[
31.56028369,
34.4
],
[
31.20567376,
33.6
],
[
30.85106383,
32.8
],
[
30.85106383,
32.8
],
[
30.85106383,
32.8
],
[
30.85106383,
32.8
],
[
30.14184397,
32
],
[
30.14184397,
32
],
[
28.0141844,
31.2
],
[
28.0141844,
31.2
],
[
27.65957447,
31.2
],
[
27.65957447,
31.2
],
[
27.65957447,
31.2
],
[
27.65957447,
31.2
],
[
26.95035461,
30.4
],
[
26.95035461,
30.4
],
[
26.95035461,
30.4
],
[
25.53191489,
27.2
],
[
25.53191489,
27.2
],
[
24.82269504,
27.2
],
[
24.82269504,
27.2
],
[
24.82269504,
27.2
],
[
24.82269504,
27.2
],
[
23.75886525,
26.4
],
[
23.04964539,
24.8
],
[
23.04964539,
24.8
],
[
22.69503546,
24
],
[
22.69503546,
24
],
[
22.69503546,
24
],
[
21.63120567,
23.2
],
[
20.56737589,
21.6
],
[
20.21276596,
21.6
],
[
20.21276596,
21.6
],
[
20.21276596,
21.6
],
[
19.85815603,
21.6
],
[
19.14893617,
20
],
[
18.43971631,
18.4
],
[
18.08510638,
17.6
],
[
18.08510638,
17.6
],
[
18.08510638,
17.6
],
[
18.08510638,
17.6
],
[
17.73049645,
17.6
],
[
17.73049645,
17.6
],
[
17.73049645,
17.6
],
[
17.73049645,
17.6
],
[
17.73049645,
17.6
],
[
16.66666667,
16
],
[
16.66666667,
16
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
15.60283688,
14.4
],
[
13.82978723,
12.8
],
[
13.82978723,
12.8
],
[
12.41134752,
12
],
[
12.41134752,
12
],
[
11.70212766,
11.2
],
[
11.70212766,
11.2
],
[
11.34751773,
11.2
],
[
11.34751773,
11.2
],
[
10.9929078,
10.4
],
[
9.929078014,
10.4
],
[
9.574468085,
10.4
],
[
9.219858156,
10.4
],
[
9.219858156,
10.4
],
[
9.219858156,
10.4
],
[
9.219858156,
10.4
],
[
8.865248227,
10.4
],
[
8.865248227,
10.4
],
[
8.865248227,
10.4
],
[
8.865248227,
10.4
],
[
8.510638298,
10.4
],
[
8.510638298,
10.4
],
[
7.80141844,
9.6
],
[
7.446808511,
8.8
],
[
7.446808511,
8.8
],
[
7.446808511,
8.8
],
[
7.092198582,
8
],
[
7.092198582,
8
],
[
6.382978723,
7.2
],
[
6.382978723,
7.2
],
[
6.028368794,
6.4
],
[
6.028368794,
6.4
],
[
3.90070922,
4.8
],
[
3.90070922,
4.8
],
[
3.191489362,
3.2
],
[
3.191489362,
3.2
],
[
2.482269504,
2.4
],
[
2.482269504,
2.4
],
[
1.418439716,
1.6
],
[
1.418439716,
1.6
],
[
0,
0
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f92acd52d0() {
var data = gvisDataLineChartIDe9f92acd52d0();
var options = {};
options["allowHtml"] = true;
options["title"] = "Lift Curve for test data CART large";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent of data', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Percent of Class 1'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f92acd52d0')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f92acd52d0);
})();
function displayChartLineChartIDe9f92acd52d0() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f92acd52d0"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f92acd52d0" 
  style="width: 600; height: 400;">
</div>
</div>



Profit Matrix
========================================================
<div class="row">
<div class="col-md-6">
<table class='table table-striped table-hover table-bordered'>
<caption align="top"> Assumed Profits and Costs </caption>
<tr> <th>  </th> <th> Predict 1 </th> <th> Predict 0 </th>  </tr>
  <tr> <td align="right"> Actual 1 </td> <td align="right"> 100.0 </td> <td align="right"> -75.0 </td> </tr>
  <tr> <td align="right"> Actual 0 </td> <td align="right"> -50.0 </td> <td align="right"> 0.0 </td> </tr>
   </table>
</div>
</div>



Profit Curves: Test Data
========================================================

<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:450px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">

<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f9eb65bc5 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
5.673758865,
-8375
],
[
31.91489362,
-3975
],
[
42.90780142,
-1700
],
[
54.60992908,
-650
],
[
86.5248227,
4300
],
[
98.58156028,
4400
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f9eb65bc5() {
var data = gvisDataLineChartIDe9f9eb65bc5();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data CART 1";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 600;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f9eb65bc5')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f9eb65bc5);
})();
function displayChartLineChartIDe9f9eb65bc5() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f9eb65bc5"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f9eb65bc5" 
  style="width: 600; height: 600;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f96642ea0e () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
0.7092198582,
-9250
],
[
2.127659574,
-8550
],
[
3.546099291,
-8525
],
[
9.219858156,
-7525
],
[
35.46099291,
-3125
],
[
45.74468085,
-1200
],
[
51.77304965,
-700
],
[
63.82978723,
2100
],
[
66.31205674,
2200
],
[
78.36879433,
2300
],
[
79.07801418,
2650
],
[
84.75177305,
3200
],
[
90.07092199,
3575
],
[
92.90780142,
4075
],
[
93.61702128,
4425
],
[
95.03546099,
4675
],
[
99.29078014,
4525
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f96642ea0e() {
var data = gvisDataLineChartIDe9f96642ea0e();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data CART 2";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f96642ea0e')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f96642ea0e);
})();
function displayChartLineChartIDe9f96642ea0e() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f96642ea0e"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f96642ea0e" 
  style="width: 600; height: 400;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:22 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f933147195 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
0.3546099291,
-9425
],
[
0.7092198582,
-9250
],
[
1.063829787,
-9075
],
[
1.418439716,
-9125
],
[
1.773049645,
-9175
],
[
2.127659574,
-9000
],
[
2.482269504,
-9050
],
[
2.836879433,
-9100
],
[
3.191489362,
-8925
],
[
3.546099291,
-8750
],
[
3.90070922,
-8575
],
[
4.255319149,
-8625
],
[
4.609929078,
-8450
],
[
4.964539007,
-8500
],
[
5.319148936,
-8550
],
[
5.673758865,
-8375
],
[
6.028368794,
-8425
],
[
6.382978723,
-8250
],
[
6.737588652,
-8300
],
[
7.092198582,
-8125
],
[
7.446808511,
-7950
],
[
7.80141844,
-7775
],
[
8.156028369,
-7825
],
[
8.510638298,
-7650
],
[
8.865248227,
-7700
],
[
9.219858156,
-7750
],
[
9.574468085,
-7800
],
[
9.929078014,
-7850
],
[
10.28368794,
-7900
],
[
10.63829787,
-7950
],
[
10.9929078,
-8000
],
[
11.34751773,
-7825
],
[
11.70212766,
-7875
],
[
12.05673759,
-7700
],
[
12.41134752,
-7750
],
[
12.76595745,
-7800
],
[
13.12056738,
-7850
],
[
13.4751773,
-7675
],
[
13.82978723,
-7725
],
[
14.18439716,
-7775
],
[
14.53900709,
-7825
],
[
14.89361702,
-7875
],
[
15.24822695,
-7700
],
[
15.60283688,
-7525
],
[
15.95744681,
-7350
],
[
16.31205674,
-7400
],
[
16.66666667,
-7225
],
[
17.0212766,
-7050
],
[
17.37588652,
-6875
],
[
17.73049645,
-6925
],
[
18.08510638,
-6975
],
[
18.43971631,
-6800
],
[
18.79432624,
-6625
],
[
19.14893617,
-6450
],
[
19.5035461,
-6275
],
[
19.85815603,
-6100
],
[
20.21276596,
-6150
],
[
20.56737589,
-6200
],
[
20.92198582,
-6025
],
[
21.27659574,
-5850
],
[
21.63120567,
-5900
],
[
21.9858156,
-5950
],
[
22.34042553,
-5775
],
[
22.69503546,
-5825
],
[
23.04964539,
-5650
],
[
23.40425532,
-5475
],
[
23.75886525,
-5300
],
[
24.11347518,
-5350
],
[
24.46808511,
-5400
],
[
24.82269504,
-5225
],
[
25.17730496,
-5275
],
[
25.53191489,
-5325
],
[
25.88652482,
-5150
],
[
26.24113475,
-4975
],
[
26.59574468,
-4800
],
[
26.95035461,
-4625
],
[
27.30496454,
-4450
],
[
27.65957447,
-4500
],
[
28.0141844,
-4550
],
[
28.36879433,
-4600
],
[
28.72340426,
-4650
],
[
29.07801418,
-4700
],
[
29.43262411,
-4750
],
[
29.78723404,
-4575
],
[
30.14184397,
-4625
],
[
30.4964539,
-4450
],
[
30.85106383,
-4500
],
[
31.20567376,
-4325
],
[
31.56028369,
-4150
],
[
31.91489362,
-3975
],
[
32.26950355,
-3800
],
[
32.62411348,
-3850
],
[
32.9787234,
-3900
],
[
33.33333333,
-3725
],
[
33.68794326,
-3775
],
[
34.04255319,
-3600
],
[
34.39716312,
-3425
],
[
34.75177305,
-3475
],
[
35.10638298,
-3525
],
[
35.46099291,
-3575
],
[
35.81560284,
-3400
],
[
36.17021277,
-3225
],
[
36.5248227,
-3275
],
[
36.87943262,
-3100
],
[
37.23404255,
-2925
],
[
37.58865248,
-2750
],
[
37.94326241,
-2800
],
[
38.29787234,
-2850
],
[
38.65248227,
-2900
],
[
39.0070922,
-2725
],
[
39.36170213,
-2550
],
[
39.71631206,
-2375
],
[
40.07092199,
-2200
],
[
40.42553191,
-2250
],
[
40.78014184,
-2075
],
[
41.13475177,
-1900
],
[
41.4893617,
-1725
],
[
41.84397163,
-1775
],
[
42.19858156,
-1825
],
[
42.55319149,
-1875
],
[
42.90780142,
-1700
],
[
43.26241135,
-1525
],
[
43.61702128,
-1350
],
[
43.97163121,
-1175
],
[
44.32624113,
-1225
],
[
44.68085106,
-1050
],
[
45.03546099,
-875
],
[
45.39007092,
-925
],
[
47.5177305,
125
],
[
47.87234043,
300
],
[
48.22695035,
250
],
[
48.58156028,
200
],
[
48.93617021,
150
],
[
49.29078014,
325
],
[
49.64539007,
500
],
[
50,
675
],
[
50.35460993,
625
],
[
50.70921986,
575
],
[
51.06382979,
750
],
[
51.41843972,
925
],
[
51.77304965,
875
],
[
52.12765957,
825
],
[
52.4822695,
775
],
[
52.83687943,
725
],
[
53.19148936,
675
],
[
53.54609929,
625
],
[
53.90070922,
800
],
[
54.60992908,
700
],
[
54.96453901,
875
],
[
55.31914894,
1050
],
[
55.67375887,
1000
],
[
56.02836879,
950
],
[
56.38297872,
900
],
[
56.73758865,
850
],
[
57.09219858,
800
],
[
57.44680851,
975
],
[
57.80141844,
925
],
[
58.15602837,
875
],
[
58.5106383,
825
],
[
58.86524823,
775
],
[
59.21985816,
950
],
[
59.57446809,
900
],
[
59.92907801,
850
],
[
60.28368794,
1025
],
[
60.63829787,
975
],
[
60.9929078,
1150
],
[
61.34751773,
1100
],
[
61.70212766,
1050
],
[
62.05673759,
1000
],
[
62.41134752,
950
],
[
62.76595745,
900
],
[
63.12056738,
1075
],
[
63.4751773,
1250
],
[
63.82978723,
1200
],
[
64.18439716,
1150
],
[
64.53900709,
1100
],
[
64.89361702,
1050
],
[
65.24822695,
1000
],
[
65.60283688,
950
],
[
65.95744681,
1125
],
[
67.37588652,
1150
],
[
67.73049645,
1325
],
[
68.08510638,
1500
],
[
68.43971631,
1450
],
[
68.79432624,
1625
],
[
69.14893617,
1800
],
[
69.5035461,
1750
],
[
69.85815603,
1700
],
[
70.21276596,
1650
],
[
70.56737589,
1600
],
[
70.92198582,
1550
],
[
71.27659574,
1725
],
[
71.63120567,
1675
],
[
71.9858156,
1850
],
[
72.34042553,
2025
],
[
72.69503546,
1975
],
[
73.04964539,
1925
],
[
73.40425532,
1875
],
[
73.75886525,
1825
],
[
74.11347518,
1775
],
[
74.46808511,
1725
],
[
74.82269504,
1900
],
[
75.17730496,
2075
],
[
75.53191489,
2250
],
[
75.88652482,
2200
],
[
76.24113475,
2375
],
[
76.59574468,
2325
],
[
76.95035461,
2500
],
[
77.30496454,
2675
],
[
77.65957447,
2850
],
[
78.0141844,
2800
],
[
78.36879433,
2750
],
[
78.72340426,
2925
],
[
79.07801418,
2875
],
[
79.43262411,
2825
],
[
79.78723404,
3000
],
[
80.14184397,
2950
],
[
80.4964539,
3125
],
[
80.85106383,
3075
],
[
81.20567376,
3250
],
[
81.56028369,
3200
],
[
81.91489362,
3375
],
[
82.26950355,
3325
],
[
82.62411348,
3275
],
[
82.9787234,
3225
],
[
83.33333333,
3175
],
[
83.68794326,
3350
],
[
84.04255319,
3300
],
[
84.39716312,
3250
],
[
84.75177305,
3425
],
[
85.10638298,
3375
],
[
85.46099291,
3325
],
[
85.81560284,
3275
],
[
86.17021277,
3225
],
[
86.5248227,
3175
],
[
86.87943262,
3350
],
[
87.23404255,
3300
],
[
87.58865248,
3250
],
[
87.94326241,
3425
],
[
88.29787234,
3600
],
[
89.0070922,
3500
],
[
89.36170213,
3675
],
[
89.71631206,
3850
],
[
90.07092199,
4025
],
[
90.42553191,
3975
],
[
90.78014184,
3925
],
[
91.13475177,
4100
],
[
91.4893617,
4050
],
[
91.84397163,
4000
],
[
92.19858156,
3950
],
[
92.55319149,
4125
],
[
92.90780142,
4075
],
[
93.26241135,
4025
],
[
93.61702128,
4200
],
[
93.97163121,
4375
],
[
94.32624113,
4550
],
[
94.68085106,
4500
],
[
95.03546099,
4450
],
[
95.39007092,
4400
],
[
95.74468085,
4575
],
[
96.09929078,
4750
],
[
96.45390071,
4700
],
[
96.80851064,
4650
],
[
97.16312057,
4600
],
[
97.5177305,
4550
],
[
97.87234043,
4725
],
[
98.22695035,
4675
],
[
98.58156028,
4850
],
[
98.93617021,
4800
],
[
99.29078014,
4750
],
[
99.64539007,
4700
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f933147195() {
var data = gvisDataLineChartIDe9f933147195();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data logistic regression";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f933147195')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f933147195);
})();
function displayChartLineChartIDe9f933147195() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f933147195"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f933147195" 
  style="width: 600; height: 400;">
</div>
</div>



Segment Specific Drivers Analysis
========================================================


What if we do the same analysis but for each segment separately? 

Does it make sense to do so? Why?



Segment Specific Drivers Analysis
========================================================

<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:400px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">
<table class='table table-striped table-hover table-bordered'>
<caption align="top">  </caption>
<tr> <th>  </th> <th> Segment 1 </th> <th> Segment 2 </th> <th> Segment 3 </th> <th> Segment 4 </th> <th> Segment 5 </th>  </tr>
  <tr> <td align="right"> Q16.2 </td> <td align="right"> -0.4 </td> <td align="right"> -0.8 </td> <td align="right"> -0.1 </td> <td align="right"> -0.2 </td> <td align="right"> -0.8 </td> </tr>
  <tr> <td align="right"> Q16.3 </td> <td align="right"> 0.1 </td> <td align="right"> -0.1 </td> <td align="right"> 0.2 </td> <td align="right"> -0.0 </td> <td align="right"> -0.2 </td> </tr>
  <tr> <td align="right"> Q16.4 </td> <td align="right"> -0.5 </td> <td align="right"> -0.3 </td> <td align="right"> 0.3 </td> <td align="right"> -0.0 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.5 </td> <td align="right"> 0.7 </td> <td align="right"> 0.4 </td> <td align="right"> -0.5 </td> <td align="right"> -0.2 </td> <td align="right"> 0.6 </td> </tr>
  <tr> <td align="right"> Q16.6 </td> <td align="right"> -0.3 </td> <td align="right"> -0.2 </td> <td align="right"> 0.1 </td> <td align="right"> 0.2 </td> <td align="right"> -0.2 </td> </tr>
  <tr> <td align="right"> Q16.7 </td> <td align="right"> -0.1 </td> <td align="right"> 0.5 </td> <td align="right"> -0.0 </td> <td align="right"> -0.2 </td> <td align="right"> -0.4 </td> </tr>
  <tr> <td align="right"> Q16.8 </td> <td align="right"> 0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 0.2 </td> <td align="right"> 0.3 </td> <td align="right"> 0.9 </td> </tr>
  <tr> <td align="right"> Q16.9 </td> <td align="right"> 0.5 </td> <td align="right"> 0.1 </td> <td align="right"> 0.4 </td> <td align="right"> 0.6 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.10 </td> <td align="right"> 0.2 </td> <td align="right"> 0.9 </td> <td align="right"> 0.1 </td> <td align="right"> -0.0 </td> <td align="right"> 0.7 </td> </tr>
  <tr> <td align="right"> Q16.11 </td> <td align="right"> -0.3 </td> <td align="right"> -0.4 </td> <td align="right"> 0.3 </td> <td align="right"> -0.6 </td> <td align="right"> 0.2 </td> </tr>
  <tr> <td align="right"> Q16.12 </td> <td align="right"> 0.6 </td> <td align="right"> 0.6 </td> <td align="right"> 1.0 </td> <td align="right"> 0.2 </td> <td align="right"> -0.3 </td> </tr>
  <tr> <td align="right"> Q16.13 </td> <td align="right"> -0.1 </td> <td align="right"> -0.4 </td> <td align="right"> -0.5 </td> <td align="right"> 0.0 </td> <td align="right"> -0.0 </td> </tr>
  <tr> <td align="right"> Q16.14 </td> <td align="right"> -0.3 </td> <td align="right"> -0.6 </td> <td align="right"> 0.2 </td> <td align="right"> -0.1 </td> <td align="right"> -0.4 </td> </tr>
  <tr> <td align="right"> Q16.15 </td> <td align="right"> 0.5 </td> <td align="right"> -0.1 </td> <td align="right"> 0.1 </td> <td align="right"> 0.2 </td> <td align="right"> 0.4 </td> </tr>
  <tr> <td align="right"> Q16.16 </td> <td align="right"> -0.4 </td> <td align="right"> -0.6 </td> <td align="right"> -0.2 </td> <td align="right"> -0.5 </td> <td align="right"> -0.7 </td> </tr>
  <tr> <td align="right"> Q16.17 </td> <td align="right"> 0.0 </td> <td align="right"> -0.2 </td> <td align="right"> -0.5 </td> <td align="right"> -0.4 </td> <td align="right"> 0.0 </td> </tr>
  <tr> <td align="right"> Q16.18 </td> <td align="right"> -0.4 </td> <td align="right"> 0.2 </td> <td align="right"> -0.4 </td> <td align="right"> -0.3 </td> <td align="right"> -0.3 </td> </tr>
  <tr> <td align="right"> Q16.19 </td> <td align="right"> 0.1 </td> <td align="right"> 0.4 </td> <td align="right"> -0.0 </td> <td align="right"> 1.0 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.20 </td> <td align="right"> -0.0 </td> <td align="right"> -0.2 </td> <td align="right"> 0.1 </td> <td align="right"> 0.0 </td> <td align="right"> -0.1 </td> </tr>
  <tr> <td align="right"> Q16.21 </td> <td align="right"> -0.0 </td> <td align="right"> 1.0 </td> <td align="right"> -0.0 </td> <td align="right"> 0.4 </td> <td align="right"> 0.6 </td> </tr>
  <tr> <td align="right"> Q16.22 </td> <td align="right"> -0.2 </td> <td align="right"> -0.1 </td> <td align="right"> 0.3 </td> <td align="right"> 1.0 </td> <td align="right"> -0.3 </td> </tr>
  <tr> <td align="right"> Q16.23 </td> <td align="right"> -0.1 </td> <td align="right"> 0.2 </td> <td align="right"> 0.1 </td> <td align="right"> -0.8 </td> <td align="right"> 0.1 </td> </tr>
  <tr> <td align="right"> Q16.24 </td> <td align="right"> 0.3 </td> <td align="right"> 0.8 </td> <td align="right"> -0.3 </td> <td align="right"> 0.1 </td> <td align="right"> 0.6 </td> </tr>
  <tr> <td align="right"> Q16.25 </td> <td align="right"> 0.2 </td> <td align="right"> -0.8 </td> <td align="right"> -0.2 </td> <td align="right"> -0.8 </td> <td align="right"> 1.0 </td> </tr>
  <tr> <td align="right"> Q16.26 </td> <td align="right"> 0.7 </td> <td align="right"> 0.3 </td> <td align="right"> -0.1 </td> <td align="right"> 0.7 </td> <td align="right"> -0.0 </td> </tr>
  <tr> <td align="right"> Q16.27 </td> <td align="right"> 1.0 </td> <td align="right"> 0.3 </td> <td align="right"> -0.0 </td> <td align="right"> 0.3 </td> <td align="right"> 0.7 </td> </tr>
   </table>
</div>




Segment Specific Profit Curves: Test Data
========================================================

Expected revenues can increase by 15% in this case: Is that a good number?

<style>
.wrapper{
            
            
            width: 100%;
           
            overflow-x: scroll;
             
          }
.wrapper1{
            
           height:450px;
             overflow-y: scroll;
          }
</style>
<div class="wrapper wrapper1">

<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:23 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f940c004b1 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
2.482269504,
-9050
],
[
8.156028369,
-8275
],
[
10.9929078,
-7325
],
[
11.70212766,
-7200
],
[
12.76595745,
-6900
],
[
13.12056738,
-6725
],
[
13.82978723,
-6600
],
[
14.18439716,
-6650
],
[
14.53900709,
-6475
],
[
15.60283688,
-6400
],
[
19.85815603,
-5650
],
[
20.92198582,
-5575
],
[
28.36879433,
-4150
],
[
42.90780142,
100
],
[
43.61702128,
0
],
[
44.68085106,
75
],
[
48.22695035,
700
],
[
57.80141844,
2500
],
[
58.15602837,
2450
],
[
60.9929078,
2950
],
[
67.37588652,
3625
],
[
69.5035461,
4000
],
[
70.92198582,
4475
],
[
73.40425532,
4350
],
[
74.11347518,
4250
],
[
80.85106383,
4650
],
[
81.20567376,
4600
],
[
84.04255319,
4650
],
[
84.39716312,
4600
],
[
84.75177305,
4550
],
[
86.17021277,
4575
],
[
90.78014184,
4600
],
[
94.32624113,
4550
],
[
95.74468085,
4575
],
[
96.80851064,
4650
],
[
98.22695035,
4675
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f940c004b1() {
var data = gvisDataLineChartIDe9f940c004b1();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data CART 1";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 600;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f940c004b1')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f940c004b1);
})();
function displayChartLineChartIDe9f940c004b1() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f940c004b1"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f940c004b1" 
  style="width: 600; height: 600;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:23 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f97e7421ac () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
2.482269504,
-9050
],
[
8.156028369,
-8275
],
[
10.9929078,
-7325
],
[
11.70212766,
-7200
],
[
12.76595745,
-6900
],
[
13.12056738,
-6725
],
[
13.82978723,
-6600
],
[
14.18439716,
-6650
],
[
14.53900709,
-6475
],
[
15.60283688,
-6400
],
[
19.85815603,
-5650
],
[
20.92198582,
-5575
],
[
28.36879433,
-4150
],
[
42.90780142,
100
],
[
43.61702128,
0
],
[
44.68085106,
75
],
[
48.22695035,
700
],
[
57.80141844,
2500
],
[
58.15602837,
2450
],
[
60.9929078,
2950
],
[
67.37588652,
3625
],
[
69.5035461,
4000
],
[
70.92198582,
4475
],
[
73.40425532,
4350
],
[
74.11347518,
4250
],
[
80.85106383,
4650
],
[
81.20567376,
4600
],
[
84.04255319,
4650
],
[
84.39716312,
4600
],
[
84.75177305,
4550
],
[
86.17021277,
4575
],
[
90.78014184,
4600
],
[
94.32624113,
4550
],
[
95.74468085,
4575
],
[
96.80851064,
4650
],
[
98.22695035,
4675
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f97e7421ac() {
var data = gvisDataLineChartIDe9f97e7421ac();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data CART 2";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f97e7421ac')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f97e7421ac);
})();
function displayChartLineChartIDe9f97e7421ac() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f97e7421ac"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f97e7421ac" 
  style="width: 600; height: 400;">
</div>
<!-- LineChart generated in R 3.3.1 by googleVis 0.6.2 package -->
<!-- Thu Jan 18 17:28:23 2018 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataLineChartIDe9f97a4ee40f () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
0,
-9375
],
[
0.3546099291,
-9200
],
[
0.7092198582,
-9025
],
[
1.063829787,
-9075
],
[
1.418439716,
-9125
],
[
1.773049645,
-8950
],
[
2.127659574,
-9000
],
[
2.482269504,
-9050
],
[
2.836879433,
-9100
],
[
3.191489362,
-9150
],
[
3.546099291,
-8975
],
[
3.90070922,
-8800
],
[
4.255319149,
-8850
],
[
4.609929078,
-8675
],
[
4.964539007,
-8725
],
[
5.319148936,
-8550
],
[
5.673758865,
-8600
],
[
6.028368794,
-8425
],
[
6.382978723,
-8250
],
[
6.737588652,
-8075
],
[
7.092198582,
-7900
],
[
7.446808511,
-7725
],
[
7.80141844,
-7550
],
[
8.156028369,
-7600
],
[
8.510638298,
-7425
],
[
8.865248227,
-7475
],
[
9.219858156,
-7300
],
[
9.574468085,
-7125
],
[
9.929078014,
-7175
],
[
10.28368794,
-7225
],
[
10.63829787,
-7050
],
[
10.9929078,
-7100
],
[
11.34751773,
-7150
],
[
11.70212766,
-7200
],
[
12.05673759,
-7025
],
[
12.41134752,
-6850
],
[
12.76595745,
-6900
],
[
13.12056738,
-6725
],
[
13.4751773,
-6550
],
[
13.82978723,
-6375
],
[
14.18439716,
-6200
],
[
14.53900709,
-6250
],
[
14.89361702,
-6300
],
[
15.24822695,
-6125
],
[
15.60283688,
-6175
],
[
15.95744681,
-6225
],
[
16.31205674,
-6050
],
[
16.66666667,
-6100
],
[
17.0212766,
-5925
],
[
17.37588652,
-5750
],
[
17.73049645,
-5575
],
[
18.08510638,
-5625
],
[
18.43971631,
-5450
],
[
18.79432624,
-5275
],
[
19.14893617,
-5325
],
[
19.5035461,
-5150
],
[
19.85815603,
-4975
],
[
20.21276596,
-4800
],
[
20.56737589,
-4625
],
[
20.92198582,
-4450
],
[
21.27659574,
-4500
],
[
21.63120567,
-4550
],
[
21.9858156,
-4600
],
[
22.34042553,
-4650
],
[
22.69503546,
-4700
],
[
23.04964539,
-4750
],
[
23.40425532,
-4800
],
[
23.75886525,
-4850
],
[
24.11347518,
-4900
],
[
24.46808511,
-4725
],
[
24.82269504,
-4775
],
[
25.17730496,
-4600
],
[
25.53191489,
-4425
],
[
25.88652482,
-4475
],
[
26.24113475,
-4525
],
[
26.59574468,
-4350
],
[
26.95035461,
-4400
],
[
27.30496454,
-4225
],
[
27.65957447,
-4275
],
[
28.0141844,
-4325
],
[
28.36879433,
-4375
],
[
28.72340426,
-4425
],
[
29.07801418,
-4250
],
[
29.43262411,
-4300
],
[
29.78723404,
-4350
],
[
30.14184397,
-4400
],
[
30.4964539,
-4225
],
[
30.85106383,
-4275
],
[
31.20567376,
-4325
],
[
31.56028369,
-4150
],
[
31.91489362,
-3975
],
[
32.26950355,
-4025
],
[
32.62411348,
-3850
],
[
32.9787234,
-3900
],
[
33.33333333,
-3950
],
[
33.68794326,
-4000
],
[
34.04255319,
-4050
],
[
34.39716312,
-4100
],
[
34.75177305,
-3925
],
[
35.10638298,
-3975
],
[
35.46099291,
-3800
],
[
35.81560284,
-3850
],
[
36.17021277,
-3675
],
[
36.5248227,
-3725
],
[
36.87943262,
-3775
],
[
37.23404255,
-3600
],
[
37.58865248,
-3650
],
[
37.94326241,
-3700
],
[
38.29787234,
-3525
],
[
38.65248227,
-3575
],
[
39.0070922,
-3400
],
[
39.71631206,
-3050
],
[
40.42553191,
-2700
],
[
40.78014184,
-2750
],
[
41.13475177,
-2575
],
[
41.4893617,
-2625
],
[
41.84397163,
-2450
],
[
42.19858156,
-2275
],
[
42.55319149,
-2100
],
[
42.90780142,
-1925
],
[
43.26241135,
-1975
],
[
43.61702128,
-1800
],
[
43.97163121,
-1625
],
[
44.32624113,
-1675
],
[
44.68085106,
-1725
],
[
45.03546099,
-1775
],
[
45.39007092,
-1600
],
[
45.74468085,
-1650
],
[
46.09929078,
-1700
],
[
46.45390071,
-1525
],
[
46.80851064,
-1575
],
[
47.16312057,
-1400
],
[
47.5177305,
-1450
],
[
47.87234043,
-1275
],
[
48.22695035,
-1325
],
[
48.58156028,
-1375
],
[
48.93617021,
-1425
],
[
49.29078014,
-1250
],
[
49.64539007,
-1075
],
[
50,
-900
],
[
50.35460993,
-725
],
[
50.70921986,
-775
],
[
51.06382979,
-825
],
[
51.41843972,
-875
],
[
51.77304965,
-700
],
[
52.12765957,
-750
],
[
52.4822695,
-575
],
[
52.83687943,
-625
],
[
53.19148936,
-675
],
[
53.54609929,
-500
],
[
53.90070922,
-325
],
[
54.25531915,
-150
],
[
54.60992908,
25
],
[
54.96453901,
-25
],
[
55.31914894,
-75
],
[
56.38297872,
-225
],
[
56.73758865,
-50
],
[
57.09219858,
-100
],
[
57.44680851,
-150
],
[
57.80141844,
-200
],
[
58.15602837,
-25
],
[
58.5106383,
150
],
[
58.86524823,
100
],
[
59.21985816,
50
],
[
59.57446809,
0
],
[
59.92907801,
175
],
[
60.28368794,
125
],
[
60.63829787,
300
],
[
60.9929078,
250
],
[
61.34751773,
425
],
[
61.70212766,
600
],
[
62.05673759,
550
],
[
62.41134752,
500
],
[
62.76595745,
450
],
[
63.12056738,
625
],
[
63.4751773,
800
],
[
63.82978723,
750
],
[
64.18439716,
700
],
[
64.53900709,
875
],
[
64.89361702,
825
],
[
65.24822695,
775
],
[
65.60283688,
950
],
[
65.95744681,
900
],
[
66.31205674,
850
],
[
66.66666667,
800
],
[
67.0212766,
975
],
[
67.37588652,
1150
],
[
67.73049645,
1325
],
[
68.08510638,
1500
],
[
68.43971631,
1450
],
[
68.79432624,
1625
],
[
69.14893617,
1800
],
[
69.5035461,
1750
],
[
69.85815603,
1700
],
[
70.21276596,
1875
],
[
70.56737589,
2050
],
[
70.92198582,
2000
],
[
71.27659574,
1950
],
[
71.63120567,
2125
],
[
71.9858156,
2300
],
[
72.34042553,
2475
],
[
72.69503546,
2650
],
[
73.04964539,
2825
],
[
73.40425532,
2775
],
[
73.75886525,
2725
],
[
74.11347518,
2900
],
[
74.46808511,
2850
],
[
74.82269504,
3025
],
[
75.17730496,
2975
],
[
75.53191489,
2925
],
[
75.88652482,
2875
],
[
76.24113475,
3050
],
[
76.59574468,
3000
],
[
76.95035461,
2950
],
[
77.30496454,
3125
],
[
77.65957447,
3300
],
[
78.0141844,
3250
],
[
78.36879433,
3200
],
[
78.72340426,
3150
],
[
79.07801418,
3100
],
[
79.43262411,
3275
],
[
79.78723404,
3450
],
[
80.14184397,
3625
],
[
80.4964539,
3800
],
[
80.85106383,
3750
],
[
81.20567376,
3700
],
[
81.56028369,
3650
],
[
81.91489362,
3825
],
[
82.26950355,
4000
],
[
82.62411348,
4175
],
[
82.9787234,
4350
],
[
83.33333333,
4525
],
[
83.68794326,
4700
],
[
84.04255319,
4650
],
[
84.39716312,
4600
],
[
84.75177305,
4550
],
[
85.10638298,
4725
],
[
85.46099291,
4675
],
[
85.81560284,
4625
],
[
86.17021277,
4575
],
[
86.5248227,
4750
],
[
86.87943262,
4700
],
[
87.23404255,
4650
],
[
87.58865248,
4825
],
[
87.94326241,
5000
],
[
88.29787234,
4950
],
[
88.65248227,
5125
],
[
89.0070922,
5075
],
[
89.36170213,
5025
],
[
89.71631206,
5200
],
[
90.07092199,
5375
],
[
90.42553191,
5325
],
[
90.78014184,
5275
],
[
91.13475177,
5225
],
[
91.4893617,
5175
],
[
91.84397163,
5125
],
[
92.19858156,
5075
],
[
92.55319149,
5250
],
[
92.90780142,
5200
],
[
93.26241135,
5150
],
[
93.61702128,
5100
],
[
93.97163121,
5050
],
[
94.32624113,
5000
],
[
94.68085106,
4950
],
[
95.03546099,
4900
],
[
95.39007092,
4850
],
[
95.74468085,
4800
],
[
96.09929078,
4750
],
[
96.45390071,
4700
],
[
96.80851064,
4650
],
[
97.16312057,
4600
],
[
97.5177305,
4775
],
[
97.87234043,
4725
],
[
98.22695035,
4675
],
[
98.58156028,
4625
],
[
98.93617021,
4575
],
[
99.29078014,
4750
],
[
99.64539007,
4700
],
[
100,
4650
],
[
100,
4650
] 
];
data.addColumn('number','xaxis');
data.addColumn('number','yaxis');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartLineChartIDe9f97a4ee40f() {
var data = gvisDataLineChartIDe9f97a4ee40f();
var options = {};
options["allowHtml"] = true;
options["title"] = "Profit Curve for test data logistic regression";
options["legend"] = "right";
options["width"] = 600;
options["height"] = 400;
options["hAxis"] = {title:'Percent Selected', titleTextStyle:{color:'black'}};
options["vAxes"] = [{title:'Estimated Profit'}];
options["series"] = [{color:'green',pointSize:3, targetAxisIndex: 0}];

    var chart = new google.visualization.LineChart(
    document.getElementById('LineChartIDe9f97a4ee40f')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartLineChartIDe9f97a4ee40f);
})();
function displayChartLineChartIDe9f97a4ee40f() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartLineChartIDe9f97a4ee40f"></script>
 
<!-- divChart -->
  
<div id="LineChartIDe9f97a4ee40f" 
  style="width: 600; height: 400;">
</div>
</div>



Iterative Data Analytics Processes
========================================================

Does segment specific analysis help for our business decisions? 

Which solution should we use? 

Should we explore a different solution? 

Should we re-start from data collection, factor analysis, segmentation, or classification and drivers' analysis? 

How can the company use the final solution?



Observations and Lessons
========================================================

- Fitting data is very easy: prediction is the challenge
- Beware of overfitting: key risk
- Beware of changes in the statistics of the data
- Defining what "success" is can be crucial
- Segment specific analysis must be considered when data are heterogeneous (15% increase in revenues in this case)
- Contextual knowledge is absolutely necessary
- Many performance metrics available
- Deployment of classification models requires a number of managerial decisions
- Iterations are necessary: Efficiency, Replicability, Reusability are key
- Data Analytics requires a balance between quantitative and qualitative criteria: it is "Art AND Science"

 

