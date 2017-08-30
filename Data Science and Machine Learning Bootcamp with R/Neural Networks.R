 # Neural Networks

# Perceptron: 1 or more inputs, a processor, and 1 output
# 1) Receive Inputs
# 2) Weigh Inputs
# 3) Sum Inputs
# 4) Generate Output

# Training Perceptrons...
# 1) Provide perceptron with inputs that have known answers
# 2) Ask perceptron to guess the answers
# 3) Compute the error
# 4) Adjust all weights according to the error
# 5) Repeat from step 1 until we're satisfied with the error

library(MASS)
head(Boston)
str(Boston)
View(Boston)
# check empty data....
any(is.na(Boston))
any(is.null(Boston))

data <- Boston
str(data)
# normalize the data...
# avoiding normalization may lead to useless results or a lengthy training process
maxs <- apply(data, MARGIN = 2, max)
maxs
mins <- apply(data, MARGIN = 2, min)
mins

# center: for every data point, subtract it by the indicated vector (mins, in this case)
# scale: for every data point, divide it by the indicated vector (maxs - mins, in this case)
scaled.data <- scale(data, center=mins, scale=maxs-mins)
# above returns a matrix... now convert it to a data frame...
scaled <- as.data.frame(scaled.data)
# now everything is normalized, and ready for use in a neural net
head(scaled)
# all the summarized values should now be between 0 and 1
summary(scaled)


library(caTools)
set.seed(101)
split <- sample.split(scaled$medv, SplitRatio = 0.7)
train <- subset(scaled, split==TRUE) # be sure to remember TWO == symbols
test <- subset(scaled, split==FALSE)
str(train)
str(test)

#install.packages('neuralnet')
library(neuralnet)
# apparently neuralnet doesn't use the y ~ . syntax... you must say y ~ col1 + col2 + col3 and so forth
# here's a shortcut to help
n <- names(train)
f <- as.formula(paste("medv ~ ", paste(n[!n %in% 'medv'], collapse = ' + ')))
f # it prints all the non-medv columns in the formula automatically


nn <- neuralnet(f # this is the pre-assembled formula, with all the columns being compared against medv
                ,data = train
                ,hidden = c(5,3) # one hidden layer of 5 neurons, a second hidden layer of 3 neurons
                ,linear.output = TRUE # this would be false if we were performing a CLASSIFICATION problem
                )

# let's plot it...
plot(nn)
# ... whoa
# the black lines show the connections between each layer and the weights on each connection
# the blue lines show the bias term added in each step (... the bias is like the intercept of a linear model)
# the nn is basically a black-box... we can't say much about the fitting, weights or the model, but it's ready to use

# predict the output of the test data set without the labels (cols 1:13)
predicted.nn.values <- compute(nn, test[1:(ncol(test)-1)])
str(predicted.nn.values)
# it's a list...neurons and net.result
# we want the net.result, but we have to undo the scaling to get the true predictions
# recall that the scaling subtracted the mins and then divided by the maxs - mins
true.predictions <- predicted.nn.values$net.result * (max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test$medv)*(max(data$medv)-min(data$medv))+min(data$medv)
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

