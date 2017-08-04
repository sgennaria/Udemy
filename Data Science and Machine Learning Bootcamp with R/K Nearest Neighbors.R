# K Nearest Neighbors (KNN)
# Predict a classification of a new data point based on a subset of the normally-available classes
# Pros: 
# Very simple
# Training is Trivial
# Works with any number of classes
# Easy to add more data
# Few Parameters: K and Distance Metric

# Cons:
# High Prediction Cost (worse for large data sets)
# Not good with high dimensional data
# Categorical Features don't work well

install.packages('ISLR')
library(ISLR)
str(Caravan)

summary(Caravan$Purchase)

any(is.na(Caravan))
any(is.null(Caravan))
# no NA or NULL values

var(Caravan[,1])
var(Caravan[,2])
# the variance of the first two columns shows a very different scale between them

# save the Purchase column by itself, for use later
purchase <- Caravan$Purchase

# standardize the data set using the scale() function
# but exclude the Purchase column (which is column 86)
standardized.Caravan <- scale(Caravan[,-86])
var(standardized.Caravan[,1])
var(standardized.Caravan[,2])
# now the column scales are standardized

str(standardized.Caravan)

# grab a sample
# normally, use caTools to grab random samples, but this is a simpler example
test.index <- 1:1000
test.data <- standardized.Caravan[test.index,]
test.purchase <- purchase[test.index]

# Train
train.data <- standardized.Caravan[-test.index,]

# Labels for training data
train.purchase <- purchase[-test.index]


# Build KNN Model
library(class)
set.seed(101)

predicted.purchase <- knn(train.data, test.data, train.purchase, k=1)
head(predicted.purchase)

misclass.error <- mean(test.purchase != predicted.purchase)
misclass.error
# 11.6% misclassification errors


# Choosing a K Value

# change K to 3
predicted.purchase <- knn(train.data, test.data, train.purchase, k=3)
head(predicted.purchase)

misclass.error <- mean(test.purchase != predicted.purchase)
misclass.error
# 7.4% misclassification errors


# change K to 5
predicted.purchase <- knn(train.data, test.data, train.purchase, k=5)
head(predicted.purchase)

misclass.error <- mean(test.purchase != predicted.purchase)
misclass.error
# 6.6% misclassification errors

# use a FOR LOOP to choose a good K value
predicted.purchase <- NULL
error.rate <- NULL
for(i in 1:20){
  set.seed(101)
  predicted.purchase <- knn(train.data, test.data, train.purchase, k=i)
  error.rate[i] <- mean(test.purchase != predicted.purchase)
}

# this is the vector of calculated error rates
error.rate

# Visualize K Elbow Method
library(ggplot2)
k.values <- 1:20
error.df <- data.frame(error.rate, k.values)
error.df

ggplot(error.df, aes(k.values, error.rate)) + geom_point() + geom_line(lty='dotted', col='red')
# k=9 is optimal for this particular data set


