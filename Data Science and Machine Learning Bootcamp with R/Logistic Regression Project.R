
setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Machine Learning Projects/CSV files for ML Projects")


adult <- read.csv('adult_sal.csv')
head(adult)

# the index was repeated... drop it
library(plyr)
library(dplyr)
adult <- select(adult, -X)
head(adult)
str(adult)
summary(adult)
table(adult$type_employer)
sum(is.null(adult$type_employer))
sum(is.na(adult$type_employer))
sapply(adult,function(x) sum(is.na(x)))
sapply(adult,function(x) sum(is.null(x)))

#no nulls/NAs
# combine 2 smallest groups (Without-pay and Never-worked) into "Unemployed"
#library(plyr)
#library(dplyr)
adult$type_employer <- revalue(adult$type_employer, c('Never-worked'='Unemployed', 'Without-pay'='Unemployed'))
table(adult$type_employer)

# combine state and local gov jobs into SL-gov and combine all self-employed jobs into self-emp
adult$type_employer <- revalue(adult$type_employer, c('Local-gov'='SL-gov', 'State-gov'='SL-gov', 'Self-emp-inc'='self-emp', 'Self-emp-not-inc'='self-emp'))
table(adult$type_employer)

# look at the marital column...
table(adult$marital)

# reduce to Married, Not-Married, and Never-Married (apparently this guy thinks that Separated = Not-Married)
adult$marital <- revalue(adult$marital, c('Divorced'='Not-Married', 'Widowed'='Not-Married', 'Married-spouse-absent'='Married', 'Married-AF-spouse'='Married', 'Married-civ-spouse'='Married', 'Separated'='Not-Married'))
table(adult$marital)

# check out country column...
table(adult$country)
# merge them by continent...
levels(adult$country)
# help type out a template faster..
cat(paste(levels(adult$country), collapse='"="", "'))
adult$country <- revalue(adult$country, c(
  "?"="Other", 
  "Cambodia"="Asia", 
  "Canada"="North.America", 
  "China"="Asia", 
  "Columbia"="Latin.and.South.America", 
  "Cuba"="Latin.and.South.America", 
  "Dominican-Republic"="Latin.and.South.America", 
  "Ecuador"="Latin.and.South.America", 
  "El-Salvador"="Latin.and.South.America", 
  "England"="Europe", 
  "France"="Europe", 
  "Germany"="Europe", 
  "Greece"="Europe", 
  "Guatemala"="Latin.and.South.America", 
  "Haiti"="Latin.and.South.America", 
  "Holand-Netherlands"="Europe", 
  "Honduras"="Latin.and.South.America", 
  "Hong"="Asia", 
  "Hungary"="Europe", 
  "India"="Asia", 
  "Iran"="Asia", 
  "Ireland"="Europe", 
  "Italy"="Europe", 
  "Jamaica"="Latin.and.South.America", 
  "Japan"="Asia", 
  "Laos"="Asia", 
  "Mexico"="Latin.and.South.America", 
  "Nicaragua"="Latin.and.South.America", 
  "Outlying-US(Guam-USVI-etc)"="Latin.and.South.America", 
  "Peru"="Latin.and.South.America", 
  "Philippines"="Asia", 
  "Poland"="Europe", 
  "Portugal"="Europe", 
  "Puerto-Rico"="North.America", 
  "Scotland"="Europe", 
  "South"="Other", 
  "Taiwan"="Asia", 
  "Thailand"="Asia", 
  "Trinadad&Tobago"="Latin.and.South.America", 
  "United-States"="North.America", 
  "Vietnam"="Asia", 
  "Yugoslavia"="Europe"))
table(adult$country)

str(adult)
levels(adult$type_employer)
levels(adult$marital)
levels(adult$country)

library(Amelia)

# look for '?'
sapply(adult,function(x) sum(x=='?'))
# type_employer and occupation...

table(adult$type_employer)
adult %>% filter(type_employer=='?')
adult[adult$type_employer=='?', 'type_employer'] <- NA
adult %>% filter(is.na(type_employer)) # verification
table(adult$type_employer)

table(adult$occupation)
adult %>% filter(occupation=='?')
adult[adult$occupation=='?', 'occupation'] <- NA
adult %>% filter(is.na(occupation)) # verification
table(adult$occupation)

# fix the '?' factors which are now unused...
adult$type_employer <- factor(adult$type_employer)
adult$occupation <- factor(adult$occupation)

missmap(adult, y.at=c(1),y.labels = c(''),col=c('yellow','black'))
# remove rows with NA values
adult <- na.omit(adult)
#verify...
missmap(adult, y.at=c(1),y.labels = c(''),col=c('yellow','black'))

str(adult)

# create a histogram of ages, colored by income...
library(ggplot2)

ggplot(adult, aes(age)) + geom_histogram(aes(fill=income), col='black', binwidth=1) + theme_bw()

ggplot(adult, aes(hr_per_week)) + geom_histogram() + theme_bw()

# rename country to region, since we changed the values...
colnames(adult)
colnames(adult)[14] <- 'region'
colnames(adult)
# alternatively: adult <- rename(adult, region = country)


ggplot(adult, aes(region)) + geom_bar(aes(fill=income), col='black') + theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


head(adult)

# time to make a logistic regression model to predict salary.
# split the data set into training and testing subsets...
library(caTools)
set.seed(101)
split <- sample.split(adult$income, SplitRatio = 0.7)
train <- subset(adult, split==TRUE)
test <- subset(adult, split==FALSE)
str(train)
str(test)

# train a model to predict income using all of the other features...
model <- glm(income ~ . , family=binomial(logit), data=train)
summary(model)

# use the step() function to try to hone the model...
new.step.model <- step(model)
summary(new.step.model)

# create a confusion matrix with type='response'
test$predicted.income <- predict(model, test, type='response')
cm <- table(test$income, test$predicted.income > 0.5)
cm
cm[1,1] # TN
cm[1,2] # FP (Type 1)
cm[2,1] # FN (Type 2)
cm[2,2] # TP

# Confusion Matrix:
# TP = True Positives
# TN = True Negatives
# FP = False Positives (Type 1 Error)
# FN = False Negatives (Type 2 Error)
#           |PREDICTED No | PREDICTED Yes|
# ACTUAL No |    TN       |     FP (T1)  |
# ----------|-------------|--------------|    
# ACTUAL Yes|    FN (T2)  |     TP       |
#----------------------------------------|
#
# Accuracy: (TN + TP) / TOTAL
# Error Rate: (FN + FP) / TOTAL
# Recall: TP / (FN + TP) 
# Precision: TP / (FP + TP)
# NB: In the video, the instructor's formulae were wrong
# https://en.wikipedia.org/wiki/Confusion_matrix
# https://en.wikipedia.org/wiki/Precision_and_recall#Definition_.28classification_context.29

accuracy <- (cm[1,1] + cm[2,2]) / sum(cm)
error.rate <-(cm[1,2] + cm[2,1]) / sum(cm)
recall <- cm[2,2] / sum(cm[2,])
precision <- cm[2,2] / sum(cm[,2])

accuracy
error.rate
recall
precision
