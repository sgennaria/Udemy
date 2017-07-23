df <- read.csv('C:\\Users\\sgenn_000\\Documents\\GitHub\\Udemy\\Data Science and Machine Learning Bootcamp with R\\Guides\\Machine Learning with R\\student-mat.csv',sep=';')
head(df)
summary(df)

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

install.packages('corrgram')
install.packages('corrplot')

library(corrgram)
library(corrplot)

corrplot(cor.data, method='color')
corrgram(df, order=TRUE, lower.panel=panel.shade, upper.panel=panel.pie, text.panel=panel.txt)
ggplot(df, aes(x=G3)) + geom_histogram(bins=20, alpha=0.5, fill='blue') + theme_minimal()

library(caTools)

set.seed(101)
sample <- sample.split(df$age, SplitRatio = 0.70)

train = subset(df, sample==TRUE)
test = subset(df, sample==FALSE)

model <- lm(G3 ~ .,train)
summary(model)

res <- residuals(model)

res <- as.data.frame(res)

head(res)

ggplot(res, aes(res)) + geom_histogram(fill='blue', alpha=0.5)

plot(model)

G3.predictions <- predict(model, test)

results <- cbind(G3.predictions, test$G3)
colnames(results) <- c('pred', 'real')
results <- as.data.frame(results)

to_zero <- function(x) {
  if (x < 0){
    return(0)
  }else{
    return(x)
  }
}

results$pred <- sapply(results$pred, to_zero)

mse <- mean((results$real-results$pred)^2)
mse # mean squared error
mse^0.5 # root mean squared error

SSE = sum((results$pred - results$real)^2)
SST = sum((mean(df$G3) - results$real)^2)
R2 = 1 - SSE/SST
R2 # R-Squared Value of model predictions
