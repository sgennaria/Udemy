# cluster unlabeled data in an unsupervised machine learning algorithm

# K is how many clusters are being assigned
# no catch-all way of choosing a good K
# the elbow method is a popular way of determining the best K
# but your domain knowledge of the data should feed this process heavily

# use the iris dataset, but pretend we don't actually have the labels
library(ISLR)
head(iris)

library(ggplot2)
ggplot(iris, aes(Petal.Length, Petal.Width, color=Species)) + geom_point(size=4)

set.seed(101)
irisCluster <- kmeans(iris[,1:4], 3, nstart = 20)
irisCluster

table(irisCluster$cluster, iris$Species)
# Cluster 2 is clearly the Setosa species, which is easy to tell since it's so separated on the scatterplot
# Cluster 1 is apparently Versicolor, since the majority of those were guessed from that species
# Cluster 3 is virginica since the majority of those were guessed from that species

library(cluster)
clusplot(iris, irisCluster$cluster, color = TRUE, shade = TRUE, labels = 0, lines = 0)
# not very useful with a dataset of numerous features, since we can only plot two features at a time here
# it automatically focuses on the two features with the best explanation for the data's variability

