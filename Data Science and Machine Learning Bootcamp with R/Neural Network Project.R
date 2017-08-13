# Neural Network Project

setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Machine Learning Projects/CSV files for ML Projects")
head(readLines('bank_note_data.csv')) # check delimiters...

df <- read.csv('bank_note_data.csv')
head(df)
str(df)

# we aren't normalizing this data because they're already somewhat similar
# normally, you should check for significantly different min/max values between fields
# then you should normalize them if they're significantly deviant

library(caTools)
set.seed(101)
split <- sample.split(df$Class, SplitRatio = 0.7)
train <- subset(df, split==TRUE) # be sure to remember TWO == symbols
test <- subset(df, split==FALSE)
str(train)
str(test)
# don't convert Class to a factor since we need it to be a numeric data type for neural network processing

library(neuralnet)
n <- names(train)
f <- as.formula(paste("Class ~ ", paste(n[!n %in% 'Class'], collapse = ' + ')))
f # it prints all the non-medv columns in the formula automatically


nn <- neuralnet(f # this is the pre-assembled formula, with all the columns being compared against medv
                ,data = train
                ,hidden = c(10) # one hidden layer of 10 neurons... why 1 level of 10?
                ,linear.output = FALSE # this is a CLASSIFICATION problem
)

# let's plot it...
plot(nn)
ncol(test) # this is ONLY useful to compute if the predicted column is the LAST one
predicted.nn.values <- compute(nn, test[1:ncol(test)-1])
str(predicted.nn.values)
# it's a list...neurons and net.result

# check out the net.result, but notice that they're still predictions...
head(predicted.nn.values$net.result)
# apply the round function to the predicted values so you only get 0 or 1 for each
predictions <- sapply(predicted.nn.values$net.result, round)
head(predictions)

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
cm.report(table(test$Class, predictions))
table(test$Class, predictions)
# whoa... suspicious... why was the model so incredibly accurate?

# let's try with a randomForest model...
library(randomForest)
df$Class <- factor(df$Class) # unlike neural nets, randomForest needs the classification column to be a factor...
set.seed(101)
split = sample.split(df$Class, SplitRatio = 0.70)
train = subset(df, split == TRUE)
test = subset(df, split == FALSE)
str(train)
str(test)


model <- randomForest(Class ~ ., data=train)
rf.pred <- predict(model,test)
table(rf.pred,test$Class)
cm.report(table(test$Class, rf.pred))
# randomForest was good, but the neural network did even better!


# we want the net.result, but we have to undo the scaling to get the true predictions
# recall that the scaling subtracted the mins and then divided by the maxs - mins
true.predictions <- predicted.nn.values$net.result * (max(df$Class)-min(df$Class))+min(df$Class)
test.r <- (test$Class)*(max(df$Class)-min(df$Class))+min(df$Class)
# compute the Mean Squared Error (MSE)
MSE.nn <- sum((test.r - true.predictions)^2)/nrow(test)
MSE.nn

error.df <- data.frame(test.r, true.predictions)
head(error.df)

# let's plot the predictions against the actual answers
library(ggplot2)
ggplot(error.df, aes(test.r, true.predictions)) + geom_point() + stat_smooth()
# a perfect prediction plot would be a staight 45 degree line with slope = 1
# this model isn't half bad, but the main problem is that we can't explain its reasoning.
# Remember, it's basically a black-box.  We can't explain WHY? or HOW? very well regarding this model.
