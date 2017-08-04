library(ISLR)

head(iris)
str(iris)

standardized.features <- scale(iris[,-5])

var(standardized.features[,1])
var(standardized.features[,2])
str(standardized.features)
head(standardized.features)

# for some reason, passing iris$Species doesn't produce the same output as iris[5]
final.data <- cbind(standardized.features, iris[5])
str(final.data)
head(final.data)

library(caTools)
set.seed(101)
split <- sample.split(iris$Species, SplitRatio = 0.7)
train <- subset(final.data, split==TRUE)
test <- subset(final.data, split==FALSE)
str(train)
str(test)

library(class)
set.seed(101)

predicted.species <- knn(train[1:4], test[1:4], train$Species, k=1)
head(predicted.species)
predicted.species

misclass.error <- mean(test$Species != predicted.species)
misclass.error
# 4.4% misclassification error

# use a FOR LOOP to choose a good K value
predicted.species <- NULL
error.rate <- NULL
for(i in 1:10){
  set.seed(101)
  predicted.species <- knn(train[1:4], test[1:4], train$Species, k=i)
  error.rate[i] <- mean(test$Species != predicted.species)
}

# this is the vector of calculated error rates
error.rate

library(ggplot2)
k.values <- 1:10
error.df <- data.frame(error.rate, k.values)
error.df

ggplot(error.df, aes(k.values, error.rate)) + geom_point() + geom_line(lty='dotted', col='red')
# k=9 is optimal for this particular data set

