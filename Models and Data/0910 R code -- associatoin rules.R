#install.packages("arules")
library(arules)

data("Groceries")

inspect(Groceries[1:10,]) #look at the data

rules <- apriori(Groceries, parameter = list(supp = 0.01, conf = 0.3, target = "rules"))

inspect(head(rules,40, by = "lift")) #lets see which rules were identified

quality(rules) #table with quality measures for the identified rules

#install.packages("arulesViz")
library(arulesViz)

plot(rules[1:40,], method = "graph") #plot top 40 rules thus far (ordered by lift)

#append the quality table by the conviction measure
quality(rules) <- cbind(quality(rules),
                        conviction = interestMeasure(rules, measure = "conviction", transactions = Groceries))

inspect(head(rules,100, by = "conviction")) 

plot(rules[1:40,], method = "graph") #re plot top 40 rules thus far (now ordered by conviction)
