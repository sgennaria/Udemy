# Logistic Regression solves classification problems dealing with discrete categories (binary or more classifications)

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
# Accuracy: (TP + TN) / TOTAL
# Error Rate: (FP + FN) / TOTAL
# 

setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Machine Learning with R")

df.train <- read.csv('titanic_train.csv')
head(df.train)
str(df.train)

# look for missing data...
sapply(df.train,function(x) sum(is.na(x)))
# look for unique values...
sapply(df.train, function(x) length(unique(x)))

#install.packages("Amelia")
library(Amelia) # good for finding how much data is missing

missmap(df.train, main='Missing Map', col=c('yellow',  'black'), legend=FALSE)
# this reveals a lot of missing AGE data

library(ggplot2)

# explore the data
ggplot(df.train, aes(Survived)) + geom_bar()
ggplot(df.train, aes(Pclass)) + geom_bar(aes(fill=factor(Pclass)))
ggplot(df.train, aes(Sex)) + geom_bar(aes(fill=factor(Sex)))
ggplot(df.train, aes(Age)) + geom_histogram(bins=20, alpha=0.5, fill='blue')
ggplot(df.train, aes(SibSp)) + geom_bar()
ggplot(df.train, aes(Fare)) + geom_histogram(fill='green', col='black', alpha=0.5)

# how to clean up the missing age data?  
# dropping the rows would be throwing away too much data
# you could fill it in with predicted ages...
pl <- ggplot(df.train, aes(Pclass,Age))
pl <- pl + geom_boxplot(aes(group=Pclass, fill=factor(Pclass), alpha=0.4))
pl + scale_y_continuous(breaks=seq(min(0), max(80), by=2)) + theme_bw()
# this allows us to "impute" the average age of missing data by class
# 1st class passengers are generally older than 2nd class passengers who are generally older than 3rd class passengers

impute_age <- function(age, class) {
  out <- age
  for(i in 1:length(age)){
    if(is.na(age[i])){
      if(class[i] == 1){
        out[i] <- 37 # these numbers came from the last graph
      }else if(class[i] == 2){
        out[i] <- 29 # these numbers came from the last graph
      }else{
        out[i] <- 24 # these numbers came from the last graph
      }
    }else{
      out[i]  <- age[i]
    }
  }
  return(out)
}

# an educated guess of missing ages, based on class
fixed.ages <- impute_age(df.train$Age, df.train$Pclass)

df.train$Age <- fixed.ages

missmap(df.train, main = 'Imputation Check', col=c('yellow', 'black'), legend = FALSE)
# nothing is missing anymore

str(df.train)

library(dplyr)

df.train <- select(df.train, -PassengerId, -Name, -Ticket, -Cabin)

head(df.train)
str(df.train)

# let's turn some of the integer values (with few possibilities) into factors
df.train$Survived <- factor(df.train$Survived)
df.train$Pclass <- factor(df.train$Pclass)
df.train$Parch <- factor(df.train$Parch)
df.train$SibSp <- factor(df.train$SibSp)
str(df.train)

# make our logistic regression model (glm = generalized linear model)
# the link='logit' argument in binomial() means to use logistic regression
log.model <- glm(Survived ~ . , family=binomial(link='logit'), data=df.train)

summary(log.model)
# in order of perceived probabilistic importance to Survival:
# gender, 3rd class, age, 2nd class

# split the current df.train data set into training and test data
# the actual test data set csv should be used after this to test
# your knowledge of the material
library(caTools)
set.seed(101)
split <- sample.split(df.train$Survived, SplitRatio = 0.7)
final.train <- subset(df.train, split==TRUE)
final.test <- subset(df.train, split==FALSE)
str(final.train)
str(final.test)
final.log.model <- glm(Survived ~ . , family=binomial(link='logit'), data=final.train)
summary(final.log.model)

fitted.probabilities <- predict(final.log.model, final.test, type='response')
# if the calculated probability of survival is greater than 50%, set the 
# result value to 1, else set it to 0
fitted.results <- ifelse(fitted.probabilities>0.5, 1, 0)
misClassError <- mean(fitted.results != final.test$Survived)
# check the accuracy of the model (80%)
1-misClassError

# CONFUSION MATRIX
table(final.test$Survived, fitted.probabilities > 0.5)
#           |PREDICTED No | PREDICTED Yes|
# ACTUAL No |    TN       |     FP (T1)  |
# ----------|-------------|--------------|    
# ACTUAL Yes|    FN (T2)  |     TP       |
#----------------------------------------|

#   FALSE TRUE
#0   140   25
#1    29   74

df.test <- read.csv('titanic_test.csv')
# check for missing data in the new set!
# look for missing data...
sapply(df.test,function(x) sum(is.na(x)))
# missing lots of AGE and 1 FARE
# look for unique values...
sapply(df.test, function(x) length(unique(x)))
# there's one additional Parch value than in the training set...

missmap(df.test, main='Missing Map', col=c('yellow',  'black'), legend=FALSE)
# missing a lot of AGE data, and a little FARE data...
# plot ages by class...
pl <- ggplot(df.test, aes(Pclass,Age))
pl <- pl + geom_boxplot(aes(group=Pclass, fill=factor(Pclass), alpha=0.4))
pl + scale_y_continuous(breaks=seq(min(0), max(80), by=2)) + theme_bw()
#impute ages...
impute_age <- function(age, class) {
  out <- age
  for(i in 1:length(age)){
    if(is.na(age[i])){
      if(class[i] == 1){
        out[i] <- 42 # these numbers came from the last graph
      }else if(class[i] == 2){
        out[i] <- 27 # these numbers came from the last graph
      }else{
        out[i] <- 24 # these numbers came from the last graph
      }
    }else{
      out[i]  <- age[i]
    }
  }
  return(out)
}
fixed.ages <- impute_age(df.test$Age, df.test$Pclass)
df.test$Age <- fixed.ages
missmap(df.test, main = 'Imputation Check', col=c('yellow', 'black'), legend = FALSE)
# no more missing ages, but we have to fix the missing fare.
ggplot(df.test, aes(Fare)) + geom_histogram(fill='green', col='black', alpha=0.5)
# there is a likely relationship between FARE and CLASS...
pl2 <- ggplot(df.test, aes(Pclass,Fare))
pl2 <- pl2 + geom_boxplot(aes(group=Pclass, fill=factor(Pclass), alpha=0.4))
pl2 + coord_cartesian(ylim=c(0,150)) + scale_y_continuous(breaks=seq(min(0), max(150), by=5)) + theme_bw()
#impute fares...
impute_fare <- function(fare, class) {
  out <- fare
  for(i in 1:length(fare)){
    if(is.na(fare[i])){
      if(class[i] == 1){
        out[i] <- 60 # these numbers came from the last graph
      }else if(class[i] == 2){
        out[i] <- 15 # these numbers came from the last graph
      }else{
        out[i] <- 8 # these numbers came from the last graph
      }
    }else{
      out[i]  <- fare[i]
    }
  }
  return(out)
}
fixed.fares <- impute_fare(df.test$Fare, df.test$Pclass)
df.test$Fare <- fixed.fares
missmap(df.test, main = 'Imputation Check', col=c('yellow', 'black'), legend = FALSE)
# no more missing data
# fix the columns as we did with the test set
# remember there's no Survived column yet, since this is test data!
df.test <- select(df.test, -PassengerId, -Name, -Ticket, -Cabin)
#df.test$Survived <- 0
#df.test$Survived[1] <- 1
#df.test$Survived <- factor(df.test$Survived)
df.test$Pclass <- factor(df.test$Pclass)
df.test$Parch <- factor(df.test$Parch)
df.test$SibSp <- factor(df.test$SibSp)
## reorder the columns..
#df.test <- df.test[, c(8, 1:7)]
str(df.test)
str(df.train)
# df.train$Parch is missing one of the factor levels found in df.test$Parch
# adding the factor level to the training data won't help, since it doesn't actually exist in the data
# therefore, remove the test rows with the additional factor level not present in the training data
new.df.test <- df.test %>% filter(Parch!=9)
str(new.df.test)
str(df.train)

#we already ran the model on the training set...
log.model <- glm(Survived ~ . , family=binomial(link='logit'), data=df.train)
summary(log.model)

log.probabilities <- predict(log.model, new.df.test, type='response', se.fit=FALSE)
log.results <- ifelse(log.probabilities>0.5, 1, 0)
new.df.test$Survived <- log.results
new.df.test$Survived <- factor(new.df.test$Survived)
str(new.df.test)
