
setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Machine Learning Projects/CSV files for ML Projects")

loans <- read.csv('loan_data.csv')

any(is.na(loans))
any(is.null(loans))

str(loans)
summary(loans)

loans$inq.last.6mths <- factor(loans$inq.last.6mths)
loans$delinq.2yrs <- factor(loans$delinq.2yrs)
loans$pub.rec <- factor(loans$pub.rec)
loans$not.fully.paid <- factor(loans$not.fully.paid)
loans$credit.policy <- factor(loans$credit.policy)

str(loans)

library(ggplot2)
ggplot(loans, aes(fico)) + geom_histogram(bins=40, aes(fill=not.fully.paid), col='black', alpha = 0.5) + scale_fill_manual(values =c('green', 'red')) + theme_bw()

ggplot(loans, aes(purpose)) + geom_bar(aes(fill=not.fully.paid), position='dodge') + theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(loans, aes(int.rate, fico)) + geom_point(alpha = 0.3, aes(color=not.fully.paid)) + theme_minimal() + scale_fill_manual(values = c('red', 'blue'))

library(caTools)
set.seed(101)
split <- sample.split(loans$not.fully.paid, SplitRatio = 0.7)
train <- subset(loans, split==TRUE)
test <- subset(loans, split==FALSE)
str(train)
str(test)

library(e1071)

model <- svm(not.fully.paid ~ ., data=train)
summary(model)

pred.values <- predict(model, test) 
#pred.values <- predict(model, test[1:13]) # the class says to do it this way (excluding the prediction column), but I don't get different results than if I do it the above way
table(pred.values, test$not.fully.paid)

cm.report <- function(cm) {
  accuracy <- (cm[1,1] + cm[2,2]) / sum(cm)
  error.rate <-(cm[1,2] + cm[2,1]) / sum(cm)
  recall <- cm[2,2] / sum(cm[2,])
  precision <- cm[2,2] / sum(cm[,2])
  cat('Accuracy: ', accuracy, '
      Error Rate: ', error.rate, '
      Recall: ', recall, '
      Precision: ', precision)
}
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

cm.report(table(pred.values, test$not.fully.paid))

# still confused on what to put in the ranges, below...
# the more combinations of cost & gamma that you try, the longer it takes
# how do you improve this beyond blind trial and error?  Binary search method?
tune.results <- tune(svm, train.x = not.fully.paid ~ ., data = train, kernel='radial', ranges=list(cost=c(1, 10), gamma=c(0.1, 1)))
summary(tune.results)

new.model <- svm(not.fully.paid ~ ., data=train, cost=10, gamma=0.1)
tuned.pred.values <- predict(new.model, test) 
table(tuned.pred.values, test$not.fully.paid)
cm.report(table(tuned.pred.values, test$not.fully.paid))

new.model <- svm(not.fully.paid ~ ., data=train, cost=1, gamma=0.1)
tuned.pred.values <- predict(new.model, test) 
table(tuned.pred.values, test$not.fully.paid)
cm.report(table(tuned.pred.values, test$not.fully.paid))
