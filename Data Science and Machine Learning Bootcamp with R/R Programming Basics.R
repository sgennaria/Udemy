x <- 1
if(x == 1) {
  print("Hello")
}

x <- 6
x <- 9
if(x%%2 == 0){
  print("Even Number")
} else {
  print("Not Even")
}

x <- matrix(1:5)
x
is.matrix(x)
x <- 5
is.matrix(x)

if(is.matrix(x)) {
  print("Is a Matrix")
} else {
  print("Not a Matrix")
}

# crappy sorting IF for 3-length vectors
x <- c(1,3,7)
x <- c(1,7,3)
x <- c(3,1,7)
x <- c(3,7,1)
x <- c(7,1,3)
x <- c(7,3,1)
x1 <- x[1];x2 <- x[2];x3 <- x[3]
if(x1 >= x2){
  if(x1 >= x3) {
    if(x2 >= x3) {
      print(c(x1,x2,x3))
    } else {
      print(c(x1,x3,x2))
    }
  } else {
    print(c(x3,x1,x2))
  }
} else if(x1 >= x3) {
  print(c(x2,x1,x3))
} else if(x2 >= x3) {
  print(c(x2,x3,x1))
} else {
  print(c(x3,x2,x1))
}

# print max of 3-element vector
x <- c(20,10,1)
x <- c(10,20,1)
x <- c(1,10,20)
x1 <- x[1];x2 <- x[2];x3 <- x[3]
if(x1 >= x2 & x1 >= x3) {
  print(x1)
} else if(x2 >= x3) {
  print(x2)
} else {
  print(x3)
}

# FUNCTIONS exercises...

fp <- function(name) {
  print(paste('Hello',name))
}
fp('Bob')

fr <- function(name) {
  return(paste('Hello',name))
}
fr('Bill')

prod <- function(x,y) {
  return(x*y)
}
prod(6,3)

num_check <- function(x,v) {
  return(x %in% v)
}
# OR
num_check <- function(x,v) {
  return(as.logical(length(v[v==x])))
}
num_check(2,c(1,2,3))
num_check(2,c(1,4,5))

num_count <- function(x,v) {
  return(length(v[v==x]))
}
num_count(2,c(1,1,2,2,3,3))
num_count(1,c(1,1,2,2,3,1,4,5,5,2,2,1,3))

bar_count <- function(x) {
  return(trunc(x/5) + (x%%5))
}
bar_count(6)
bar_count(17)
bar_count(0)

summer <- function(x,y,z) {
  sum <- 0
  if(x%%3 != 0) {
    sum <- sum + x
  }
  if(y%%3 != 0) {
    sum <- sum + y
  }
  if(z%%3 != 0) {
    sum <- sum + z
  }
  return(sum)
}

summer(7,2,3)
summer(3,6,9)
summer(9,11,12)

prime_check <- function(x) {
  if(x<=1){
    return(F)
  } else if(x<=3) {
    return(T)
  } else if(x%%2==0 | x%%3==0) {
    return(F)
  }
  i <- 5
  while(i * i <= x){
    if(x%%i==0 | x%%(i+2)==0){
      return(F)
    }
    i <- i + 6
  }
  return(T)
}
prime_check(2)
prime_check(5)
prime_check(4)
prime_check(237)
prime_check(131)

