# wd is: "C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R"
df <- read.csv('./Guides/Training Exercises/Machine Learning Projects/CSV files for ML Projects/bikeshare.csv')

# check for data gaps
any(is.na(df))
any(is.null(df))

bike <- df
head(bike)
str(bike)

library(ggplot2)
library(ggthemes)
# try to predict count using a training set of the first 19 days of each month with a test set spanning the 20th until the end of each month
ggplot(bike, aes(temp, count)) + geom_point(aes(color=temp), alpha = 0.2) + theme_minimal()

str(bike)
bike$datetime <- as.POSIXct(df$datetime)
str(bike)
head(bike)

ggplot(bike, aes(datetime, count)) + geom_point(aes(color=temp), alpha = 0.5) + scale_x_datetime() + scale_color_gradient(high='orangered', low='cyan') + theme_minimal()
# the gaps between the months are due to the excluded 20th-to-month-end data.  colors show expected seasonal temperature variance.
# also notice that the growth of bike rentals is growing over time, regardless of temperature.  this may confound our linear regression analysis.

summary(bike)
#num.cols <- sapply(bike, is.numeric)
#cor.data <- cor(df[,num.cols])
cor.data <- cor(df[,c(6,12)]) # only the temp and count columns
cor.data
cor(bike[,c('temp', 'count')]) # same answer as above


ggplot(bike, aes(factor(season), count)) + geom_boxplot(aes(color = factor(season))) + theme_minimal()
# season: 1 = spring, 2 = summer, 3 = fall, 4 = winter
# a line can't capture a non-linear relationship
# more rentals in winter than spring
# these issues are due to growth in rental count over time over this dataset, regardless of season

bike$hour <- format(bike$datetime, "%H")
str(bike)
head(bike)
head(bike[bike$workingday==1,])
ggplot(bike[bike$workingday==1,], aes(hour, count)) + geom_point(aes(color=temp), alpha = 0.4, position = position_jitter(w=1, h=0)) + scale_color_gradientn(colors = c('dark blue', 'blue', 'light blue', 'light green', 'yellow', 'orange', 'red')) + theme_minimal()

ggplot(bike[bike$workingday==0,], aes(hour, count)) + geom_point(aes(color=temp), alpha = 0.4, position = position_jitter(w=1, h=0)) + scale_color_gradientn(colors = c('dark blue', 'blue', 'light blue', 'light green', 'yellow', 'orange', 'red')) + theme_minimal()
# working days have peaks during morning and afternoon commuting hours, with some activity during lunch
# non-working days have a steady rise and fall during the afternoon

# alternate method
library(dplyr)
pl <- ggplot(filter(bike, workingday==1), aes(hour, count))
pl <- pl + geom_point(position=position_jitter(w=1, h=0), aes(color=temp), alpha=0.5)
pl <- pl + scale_color_gradientn(colors=c('dark blue', 'blue', 'light blue', 'light green', 'yellow', 'orange', 'red'))
pl + theme_minimal()

pl <- ggplot(filter(bike, workingday==0), aes(hour, count))
pl <- pl + geom_point(position=position_jitter(w=1, h=0), aes(color=temp), alpha=0.5)
pl <- pl + scale_color_gradientn(colors=c('dark blue', 'blue', 'light blue', 'light green', 'yellow', 'orange', 'red'))
pl + theme_minimal()

# end alternate method

temp.model <- lm(count ~ temp, bike)

summary(temp.model)

# Intercept 6.0462 is the Y (count) value when X (temp) is 0
# temp coefficient 9.1705 is the change in y (count) divided by the change in x (temp)
# therefore an increase of 1 degree Celsius (temp) is associated with an increase in count by 9.17
# Method 1, using above analysis
6.0462 + (9.1705 * 25)
# Method 2, using precict()
temp.test <- data.frame(temp=25)
predict(temp.model,temp.test)

# My method, below
temp.predictions <- predict(temp.model, bike)
temp.results <- cbind(temp.predictions, bike$temp)
colnames(temp.results) <- c('predicted', 'temp')
temp.results <- as.data.frame(temp.results)

head(temp.results)
mean(temp.results[round(temp.results$temp)==25, ]$predicted)
ggplot(temp.results, aes(temp, predicted)) + geom_point() + theme_minimal()

str(bike)
bike$hour <- as.numeric(bike$hour)
str(bike)

library(corrgram)
corrgram(bike, order=TRUE, lower.panel=panel.shade, upper.panel=panel.pie, text.panel=panel.txt)

complex.model <- lm(count ~ season + holiday + workingday + weather + temp + humidity + windspeed + hour, bike)
summary(complex.model)

# Alternative approach: negate the ones we don't want
complex.model <- lm(count ~ . -casual -registered -datetime -atemp, bike)
summary(complex.model)

# overall, model not appropriate since it mistakenly attributes growth of rentals to winter season, but it was actually just a growth of overall demand, not represented in this data set
