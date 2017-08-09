# Tree Methods Project

library(ISLR)

# check out data sets available in ISLR...
data()

# check out the College data set...
str(College)
head(College)

df <- College

library(ggplot2)

# create a scatterplot of Grad.Rate vs Room.Board colored by Private
ggplot(College, aes(Room.Board, Grad.Rate)) + geom_point(aes(col=Private))

# create a histogram of full time undergrad students, color by Private
ggplot(College, aes(F.Undergrad)) + geom_histogram(col='black', aes(fill=Private), binwidth=650)

# create a histogram of Grad.Rate, color by Private
ggplot(College, aes(Grad.Rate)) + geom_histogram(col='black', aes(fill=Private), binwidth=2.5)
# this shows some college had a graduation rate above 100%... which?
College[College$Grad.Rate > 100,]
# fix Cazenovia College back to 100% Grad.Rate...
College[College$Grad.Rate > 100,]$Grad.Rate <- 100

# split into training/test data sets (70/30 split)
library(caTools)
set.seed(101)
split <- sample.split(College$Private, SplitRatio = 0.7)
train <- subset(College, split==TRUE)
test <- subset(College, split==FALSE)
str(train)
str(test)

# use rpart to build a decision tree to predict whether or not a school is Private
library(rpart)
tree <- rpart(Private ~ ., method='class', data=train)

# use predict() to predict the Private label on the test data...
tree.preds <- predict(tree, test)

head(tree.preds)

# if the calculated probability of Private is greater than 50%, set the 
# result value to 1, else set it to 0
pred.results <- ifelse(tree.preds>0.5, 1, 0)
str(pred.results)
head(pred.results)
pred.results <- as.data.frame(pred.results)
tree.preds <- as.data.frame(tree.preds)
#pred.results$Private <- ifelse(pred.results$Yes==1, 'Yes', 'No')
tree.preds$Private <- ifelse(pred.results$Yes==1, 'Yes', 'No')

# CONFUSION MATRIX
table(tree.preds$Private, test$Private)

library(rpart.plot)
# view the decision tree...
prp(tree)

library(randomForest)
# build rf model to predict Private class.  Be sure to evaluate the importance of predictors...
rf.model <- randomForest(Private ~ ., data=train, importance=TRUE)
# CONFUSION MATRIX
rf.model$confusion
rf.model$importance
# MeanDecreaseGini is a measure of variable importance based on the Gini impurity index used
# for the calculation of splits during training.  A common misconception is that the variable
# importance metric refers to the Gini used for asserting model performance which is closely 
# related to AUC, but this is wrong.  
# Gini Importance: Every time a split of a node is made on variable m, the Gini impurity criterion
# for the two descendent nodes is less than the parent node.  Adding up the Gini decreases for each 
# individual variable over all trees in the forest gives a fast variable importance that is often 
# very consistent with the permutation importance measure.

# use rf model to predict on the test set...
rf.preds <- predict(rf.model, test)
head(rf.preds)

# RF CONFUSION MATRIX
rf.cm <- table(rf.preds, test$Private)

# SINGLE TREE CONFUSION MATRIX
tree.cm <- table(tree.preds$Private, test$Private)


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

cm.report(rf.cm)
cm.report(tree.cm)

