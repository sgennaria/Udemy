# Logistic Regression solves classification problems dealing with discrete categories (binary or more classifications)

# Confusion Matrix:
# TP = True Positives
# TN = True Negatives
# FP = False Positives (Type 1 Error)
# FN = False Negatives (Type 2 Error)
#           |PREDICTED No | PREDICTED Yes|
# ACTUAL No |    TN       |     FP       |
# ----------|-------------|--------------|    
# ACTUAL Yes|    FN       |     TP       |
#----------------------------------------|
#
# Accuracy: (TP + TN) / TOTAL
# Error Rate: (FP + FN) / TOTAL
# 

setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Machine Learning with R")

df.train <- read.csv('titanic_train.csv')
head(df.train)
str(df.train)

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

fixed.ages <- impute_age(df.train$Age, df.train$Pclass)
