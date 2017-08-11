# Support Vector Machines
# SVMs are used to predict the classification of a new plotted point
# based on its proximity to the classes already in the plot

library(ISLR)

head(iris)
str(iris)

install.packages('e1071')
library(e1071)
?svm

model <- svm(Species ~ ., data=iris)
summary(model)

pred.values <- predict(model, iris[1:4]) # normally you shouldn't train against the actual data...this is just quick example
table(pred.values, iris[,5])

summary(model)
# read ISLR (Chapter 9?) to fully understand the "cost" and "gamma" parameters

tune.results <- tune(svm, train.x = iris[1:4], train.y = iris[,5], kernel='radial', ranges=list(cost=c(0.1, 1, 10), gamma=c(0.5, 1, 2)))
summary(tune.results)
# this showed that cost = 1 and gamma = 0.5 were the best values, so now hone in on values near those...

tune.results <- tune(svm, train.x = iris[1:4], train.y = iris[,5], kernel='radial', ranges=list(cost=c(0.5, 1, 1.5), gamma=c(0.1, 0.5, 0.7)))
summary(tune.results)

# cost = 1, gamma = 0.1
tuned.svm <- svm(Species ~ ., data=iris, kernel='radial', cost=1, gamma=0.1)
summary(tuned.svm)
