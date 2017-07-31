# workbook:
# file:///C:/Users/sgenn_000/Documents/GitHub/Udemy/Data%20Science%20and%20Machine%20Learning%20Bootcamp%20with%20R/Guides/Machine%20Learning%20with%20R/Linear%20Regression%20Lecture.html


df <- read.csv('C:\\Users\\sgenn_000\\Documents\\GitHub\\Udemy\\Data Science and Machine Learning Bootcamp with R\\Guides\\Machine Learning with R\\student-mat.csv',sep=';')
head(df)
summary(df)

# make sure there are no NA/NULL values before analyzing
any(is.na(df))
any(is.null(df))

str(df)

library(ggplot2)
library(ggthemes)
library(dplyr)

#grab only numeric columns
num.cols <- sapply(df, is.numeric)

#filter to numeric columns for correlation
cor.data <- cor(df[,num.cols])

cor.data

#install.packages('corrgram')
#install.packages('corrplot')

library(corrgram)
library(corrplot)

corrplot(cor.data, method='color')
corrgram(df, order=TRUE, lower.panel=panel.shade, upper.panel=panel.pie, text.panel=panel.txt)
ggplot(df, aes(x=G3)) + geom_histogram(bins=20, alpha=0.5, fill='blue') + theme_minimal()

library(caTools)

# set the seed to have the same results as the Udemy course
set.seed(101)
# split the desired column into a training set and a test set
# the radio 0.7 means 70% will be training data
# and 30% will be test data
#sample <- sample.split(df$age, SplitRatio = 0.70)
sample <- sample.split(df$G3, SplitRatio = 0.70)

# create individual data sets for the training and test data
train = subset(df, sample==TRUE)
test = subset(df, sample==FALSE)

# create a linear regression (lm) model
# basic structure: 
# model <- lm(y ~ x1 + x2, data)
#                  ^    ^
#      individual features to predict upon
# 
# model <- lm(y ~ . , data)
#                 ^
#   predict upon ALL variables/features in the data set  

# train and build model using ALL features of the training data set
model <- lm(G3 ~ .,train)

# view the results:
# Estimated Coefficient is the value of slope calculated by the regression.  Without normalized data, we cannot effectively compare these between variables.
# Coefficient Standard Error is a measure of the variability of each estimated coefficient (lower is usually better, at least an order of magnitude less than the coefficient estimate)
# T-Value is a measure of whether or not the coefficient for the variable is meaningful for the model
# Probability (P) is the probability that the variable is NOT relevant.  Smaller is better.  *** asterisks indicate significance.
# R-squared value is a metric for evaluating the goodness of fit for the model.  Higher is better (max 1).  It corresponds with the amount of variability in your predictions which are explained by the model.
summary(model)

# plot a histogram of the residuals
# we would like the residuals to be normally distributed, in order to indicate that the mean of the diff between the predictions and actual values is close to 0 (indicating roughly equal distance between actual data above and below our predictions)
# this plot shows suspicious negative residuals which indicate predicted negative test scores, which are actually impossible since the lowest test score is 0
res <- residuals(model)
res <- as.data.frame(res)
head(res)
ggplot(res, aes(res)) + geom_histogram(fill='blue', alpha=0.5)

# the following plot shows:
# Residuals vs Fitted Values
# Normal Q-Q
# Scale-Location
# Residuals vs Leverage
# See: https://en.wikipedia.org/wiki/Regression_validation
plot(model)

# build some predictions using the model and the test data set
# It knows to predict G3 since that's what we put on the left side of the lm() formula, above
G3.predictions <- predict(model, test)

# format the predicted results as a data frame
results <- cbind(G3.predictions, test$G3)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)
head(results)
min(results) # this is negative, which is unrealstic for test scores

# fix the negative predictions we saw when we plotted a 
# histogram of the residuals
to_zero <- function(x) {
  if (x < 0){
    return(0)
  }else{
    return(x)
  }
}
results$predicted <- sapply(results$predicted, to_zero)

# Calculate Mean-Squared Error
mse <- mean((results$actual-results$predicted)^2)
mse # mean squared error
mse^0.5 # root mean squared error (RMSE)

# Calculate the Sum of the Squared-Errors (SSE)
SSE = sum((results$predicted - results$actual)^2)
# Calculate the Sum of Squared Total (SST)
SST = sum((mean(df$G3) - results$actual)^2)
# Calculate the R-Squared value
R2 = 1 - SSE/SST
R2 # R-Squared Value of model predictions
# 0.8 means we're explaining about 80% variance on the test data



