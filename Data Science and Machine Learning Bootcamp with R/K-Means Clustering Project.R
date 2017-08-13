# K-Means Clustering Project

setwd("C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Machine Learning Projects/CSV files for ML Projects")

head(readLines('winequality-red.csv'))
# ; delimiter
# don't use read.csv2 since it automatically turns all the numerics into factors, despite using ';' as the default delimiter
df1 <- read.csv('winequality-red.csv', sep=';')
head(df1)
df2 <- read.csv('winequality-white.csv', sep=';')
head(df2)

# add label column
df1$label <- 'red'
df2$label <- 'white'

head(df1)
head(df2)
str(df1)
str(df2)

# wine <- rbind.data.frame(df1, df2)
wine <- rbind(df1, df2)
str(wine)

library(ggplot2)
ggplot(wine, aes(residual.sugar)) + geom_histogram(bins = 50, aes(fill=label), col = 'black') + theme_bw() + scale_fill_manual(values = c('red'='red', 'white'='white'))
ggplot(wine, aes(residual.sugar, fill = label)) + geom_histogram(bins = 50, col = 'black') + theme_bw() + scale_fill_manual(values = c('red'='red', 'white'='white'))

ggplot(wine, aes(citric.acid, fill = label)) + geom_histogram(bins = 50, col = 'black') + theme_bw() + scale_fill_manual(values = c('red'='red', 'white'='white'))

ggplot(wine, aes(alcohol, fill = label)) + geom_histogram(bins = 50, col = 'black') + theme_bw() + scale_fill_manual(values = c('red'='red', 'white'='white'))

ggplot(wine, aes(citric.acid, residual.sugar, color = label)) + geom_point(size = 1, alpha = 0.3) + scale_color_manual(values = c('red'='red', 'white'='white')) + theme_dark()

ggplot(wine, aes(volatile.acidity, residual.sugar, color = label)) + geom_point(size = 1, alpha = 0.3) + scale_color_manual(values = c('red'='red', 'white'='white')) + theme_dark()

library(dplyr)
clus.data <- select(wine, -label)
str(wine)
str(clus.data)
head(clus.data)

set.seed(101)
wine.cluster <- kmeans(clus.data, 2)
wine.cluster$centers

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
cm.report(table(wine$label, wine.cluster$cluster))

table(wine$label, wine.cluster$cluster)
# red wine is easier to classify than white ...


library(cluster)
clusplot(clus.data, wine.cluster$cluster, color = TRUE, shade = TRUE, labels = 0, lines = 0)

# just to mess around, try classifying K=3 since it visually looks like there are 3 somewhat distinct groups...
wine.cluster2 <- kmeans(clus.data, 3)
wine.cluster2$centers
cm.report(table(wine$label, wine.cluster2$cluster))
table(wine$label, wine.cluster2$cluster)

clusplot(clus.data, wine.cluster2$cluster, color = TRUE, shade = TRUE, labels = 0, lines = 0)
# didn't look as nice as I thought... 
# the data is pretty poorly guessed... there's a lot of overlap in the white and red categories
# the values here don't appear to be good predictors of color
