v <- c(1,2,3)
m <- matrix(1:10,nrow=2)
df <- mtcars

class(v)
class(m)
class(df)

my.list <- list(v,m,df)
my.list

my.named.list <- list(sample.vec=v, my.matrix=m, sample.df=df)
my.named.list

my.named.list$sample.vec

my.list
my.list[1]
my.named.list[1]
my.named.list['sample.vec'] #notice this comes with a label since it's STILL a list (of one item)
my.named.list$sample.vec #notice this is not a list, but actually is the internal vector
my.named.list[['sample.vec']] #notice this uses double-bracket notation to also return just the internal vector

class(my.named.list['sample.vec']) # still a list
class(my.named.list$sample.vec) # actually returns the data type of the object internal to the list
class(my.named.list[['sample.vec']]) # also returns the internal object


double.list <- c(my.named.list, my.named.list) # combine lists

str(my.named.list)
str(double.list)
