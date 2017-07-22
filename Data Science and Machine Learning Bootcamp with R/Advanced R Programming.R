# APPLY functions

sample(x = 1:100,3)


v <- 1:5
v

addrand <- function(x){
  rand <- sample(1:100,1)
  return(x+rand)
}

addrand(10)

addrand(v)

result <- lapply(v,addrand) # returns a LIST of results
result
str(result)

addrand(v)
result <- sapply(v,addrand) # returns a VECTOR or MATRIX or ARRAY of results
result
str(result)

times2 <- function(num){
  return(num*2)
}
result <- sapply(v,times2)
result
times2(v)

result <- vapply(v,addrand,0) # the '0' (FUN.VALUE) can be any single-length digit in this case, which will enforce that the result's length matches the length of the X argument.  See docs for other data types besides vectors...
result

# Anonymous Functions (similar to Lambda Expressions in Python)

v <- 1:5

times2 <- function(num){ # NOT an anonymous function
  return(num*2)
}

result <- sapply(v, function(num){num*2}) #anonymous function
result

# Apply with Multiple Inputs
v <- 1:5
add_choice <- function(num,choice){
  return(num+choice)
}
add_choice(2,10)

sapply(v,add_choice) # ERROR since I didn't handle both arguments

sapply(v,add_choice,100)
# OR
sapply(v,add_choice,choice=100)

sapply(v,function(num,choice){num+choice},100)

