# this script goes through some basic data manipulations using dplyr for T1
# data used: "T1_Sales_Data_part2.csv"

# --------------------------------------
#     Load and Inspect Data
# --------------------------------------

# Load "T1_Sales_Data_part2.csv"
rawdata <- read.csv(file.choose(), header=TRUE, sep=",")

# Check the structure of the data
str(rawdata)

# Look at first few rows in the data
head(rawdata)


# --------------------------------------
#     Install package dplyr
# --------------------------------------

install.packages("dplyr")

# installations need to be done only once. The library is then locally 
# available on your computer after the installation. You only need to load it
# after that point. Even in other scripts. 

library(dplyr)




# --------------------------------------
#     Data Manipulations
# --------------------------------------

# Say we want to create a variable diff.sales = Sales - test.sales 
# Base R method
rawdata$diff.sales.base <- rawdata$sales - rawdata$test.sales

# dplyr Method (use of pipe %>% allows you to not define name of df every time!)
rawdata %>% mutate(diff.sales.dplyr = sales - test.sales)

# this outputs new column but does not assign it to data. it's missing from our data:
head(rawdata)

# now assign it
rawdata <- rawdata %>% mutate(diff.sales.dplyr = sales - test.sales)
head(rawdata)

# check that both columns are identical
identical(rawdata$diff.sales.base, rawdata$diff.sales.dplyr)

# let's drop one of these and rename the other
rawdata$diff.sales.base <- NULL
rawdata <- rawdata %>% rename(diff.sales = diff.sales.dplyr)
head(rawdata)



# --------------------------------------
#     Group-based Variables
# --------------------------------------

# What is the average of test and final sales for each animal in our dataset? 
rawdata <- rawdata %>% 
  group_by(animal) %>% 
  mutate(test.avg = mean(test.sales),
         sales.avg = mean(sales)) %>%
  ungroup()

# note: if data had NAs, would write as: mean(test.sales, na.rm = TRUE)

head(rawdata)


# --------------------------------------
#     Pivot Tables
# --------------------------------------

# make a pivot table where we have:
# the count per animal type,
# sorted in descending order of counts, and
# is based on only animals that made it to final production (sales > 0)

counts <- rawdata %>% filter(sales>0) %>%       # only incude those with sales > 0
  group_by(animal) %>%                          # group by the animal column
  summarise(animal.count = n()) %>%             # get the distinct counts per animal
  arrange(desc(animal.count))                   # sort them into descending order
  
counts


# --------------------------------------
#     Merging Tables
# --------------------------------------

# merge counts with our rawdata
rawdata <- rawdata %>%
  left_join(counts, by = "animal")

head(rawdata) # notice elephants have NA because counts filtered out sales > 0 so did not include this animal

# --------------------------------------
#     Create Some New Variables
# --------------------------------------

## combine animals with missing or small number of counts into one group

rawdata$animal <- as.character(rawdata$animal)

rawdata <- rawdata %>% mutate(newcat = if_else(animal.count < 400 | is.na(animal.count),
                                               "combined",
                                               animal))

head(rawdata)

# Let's create a new feature based on the hemisphere
unique(rawdata$animal)
south.animals = c('penguin','kangaroo')
rawdata  <- rawdata %>% 
  mutate(hemisphere = if_else(animal %in% south.animals,
                                                   'southern','northern'))

head(rawdata)

# Finally, let's assign the right data types to each column
str(rawdata)
rawdata <- rawdata %>% mutate(animal = factor(animal),
                              newcat = factor(newcat),
                             hemisphere = factor(hemisphere))
str(rawdata)
