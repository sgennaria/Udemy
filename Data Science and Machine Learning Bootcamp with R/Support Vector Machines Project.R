
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
ggplot(loans, aes(fico)) + geom_histogram(binwidth=6, aes(fill=not.fully.paid), col='black') + scale_fill_manual(values =c('green', 'red'))

ggplot(loans, aes(purpose)) + geom_bar(aes(fill=not.fully.paid), position='dodge') + theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(loans, aes(int.rate, fico)) + geom_point(alpha = 0.5, aes(color=not.fully.paid)) + theme_minimal() + scale_fill_manual(values = c('red', 'blue'))

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

cm.report(table(pred.values, test$not.fully.paid))

tune.results <- tune(svm, train.x = not.fully.paid ~ ., data = train, kernel='radial', ranges=list(cost=c(0.1, 1, 10), gamma=c(0.5, 1, 2)))
summary(tune.results)
