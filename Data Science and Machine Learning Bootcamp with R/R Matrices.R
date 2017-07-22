1:10
v <- 1:10
v
matrix(v, nrow = 2)
matrix(1:12, byrow = FALSE, nrow = 4)
matrix(1:12, byrow = TRUE, nrow = 4)

goog <- c(450, 451, 452, 445, 468)
msft <- c(230, 231, 232, 233, 220)

stocks <- c(goog, msft)
stocks

stock.matrix <- matrix(stocks,byrow=T,nrow=2)
stock.matrix

days <- c('Mon', 'Tues', 'Wed', 'Thu', 'Fri')
st.names <- c('GOOG', 'MSFT')

colnames(stock.matrix) <- days
rownames(stock.matrix) <- st.names
stock.matrix

#

mat <- matrix(1:25,byrow=T,nrow=5)
mat
mat * 2
mat/2
mat^2
1/mat
mat[mat>15]
mat + mat
mat / mat
mat^mat
mat * mat

#above is not actual arithmetic matrix multiplication
#below is true matrix multiplication
mat %*% mat

print(stock.matrix)
colSums(stock.matrix)
rowSums(stock.matrix)
rowMeans(stock.matrix)
colMeans(stock.matrix)

# add cols or rows:
FB <- c(111,112,113,120,145)
tech.stocks <- rbind(stock.matrix,FB)
tech.stocks
avg <- rowMeans(tech.stocks)
avg
tech.stocks <- cbind(tech.stocks,avg)
tech.stocks

#factors
animal <- c('d', 'c', 'd', 'c', 'c')
id <- c(1,2,3,4,5)
factor(animal)
# Nominal - no order
fact.ani <- factor(animal)
#Ordinal - order
ord.cat <- c('cold', 'med', 'hot')
temps <- c('cold', 'med', 'hot', 'hot', 'hot', 'cold', 'med')
temps
fact.temp <- factor(temps,ordered=T,levels=c('cold','med','hot'))
fact.temp
summary(fact.temp)
summary(temps)

# Exercise
A <- c(1,2,3)
B <- c(4,5,6)
rbind(A,B)

mat <- matrix(1:9,nrow=3)
mat

is.matrix(mat)

mat2 <- matrix(1:25,nrow=5,byrow=T)
mat2

mat2[2:3,2:3]

mat2[4:5,4:5]

sum(mat2)

matrix(runif(20,max=100),nrow=4)
