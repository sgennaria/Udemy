

install.packages('rpart')
library(rpart)

str(kyphosis)
head(kyphosis)

#create a tree model to predict the Kyphosis outcome using all varaibles
# NOTE: Kyphosis (with a capital K) is the COLUMN NAME
# kyphosis (lowercase k) is the dataframe
tree <- rpart(Kyphosis ~ ., method='class', data=kyphosis)


# there are various ways to view the results, outlined in the notes
printcp(tree)

plot(tree, uniform=TRUE, main='Kyphosis Tree')
text(tree, use.n=TRUE, all=TRUE)

# rpart.plot is a better library to visualize the tree models...
install.packages('rpart.plot')
library(rpart.plot)

# this is a much nicer viz of the decision tree
prp(tree)


install.packages('randomForest')
library(randomForest)

# NOTE: Kyphosis (with a capital K) is the COLUMN NAME
# kyphosis (lowercase k) is the dataframe
rf.model <- randomForest(Kyphosis ~ ., data=kyphosis)
print(rf.model)

?randomForest
#explore the Value section to see the various values resulting from this call
rf.model$ntree
rf.model$confusion

