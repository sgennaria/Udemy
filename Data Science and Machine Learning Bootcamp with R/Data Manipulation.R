install.packages('dplyr')
library(dplyr)

install.packages('nycflights13') #sample dataset
library(nycflights13)

head(flights)
summary(flights)

# filter() - select rows using conditionals against named columns
head(filter(flights,month==11,day==3,carrier=='AA'))

#above is MUCH easier equivalent to native subsetting...
head(flights[flights$month == 11 & flights$day == 3 & flights$carrier == 'AA', ])

#slice() - select rows by position
slice(flights,1:10)

#arrange() - reorders rows by named columns
head(arrange(flights,year,month,day,arr_time))
head(arrange(flights,year,month,day,desc(arr_time))) # includes example of a DESCENDING sort

#select() - selects columns by name
head(select(flights,carrier))
head(select(flights,carrier,arr_time))

#rename() - renames columns
# SYNTAX: rename(dataframe, new_column_name = old_column_name)
head(rename(flights,airline_carrier = carrier))

#distinct() - returns only unique values... great when used with select() to hone in on specific columns
distinct(select(flights,carrier))

#mutate() - add a new column, which could be built using formulas based on other existing columns and such
head(mutate(flights,new_col = arr_delay - dep_delay))

#transmute() - like mutate() but ONLY returns the new column being created
head(transmute(flights,new_col = arr_delay - dep_delay))

#summarise() - perform aggregate operations on columns in a dataframe
#SYNTAX: summarise(dataframe,new_column_name = aggregate_function(existing_column,...))

summarise(flights,avg_air_time = mean(air_time,na.rm=T)) #na.rm=T excludes 'NA' values from the aggregation
summarise(flights,total_air_time=sum(air_time,na.rm=T))

#sample_n() - return a sample of n random rows from the dataframe
sample_n(flights,10)

#sample_frac() - returns a fraction of random rows from the total dataframe
sample_frac(flights,0.1) #return 10% random rows from the dataframe
nrow(flights)


# %>% PIPE OPERATOR

df <- mtcars

#Nesting -- can be difficult to read
arrange(sample_n(filter(df,mpg>20),5),desc(mpg))

#Multiple Assignments
a <- filter(df,mpg>20)
b <- sample_n(a,5)
c <- arrange(b,desc(mpg))
c

# use PIPES for easy readability, plus not wasting memory with variable assignments...
# DATA %>% op1 %>% op2 %>% op3 ...
df %>% filter(mpg>20) %>% sample_n(5) %>% arrange(desc(mpg))


# EXERCISES

head(mtcars)

filter(mtcars,mpg>20,cyl==6)

head(arrange(mtcars,cyl,desc(wt)))

distinct(mtcars,gear)

head(mutate(mtcars,Performance=hp/wt))

summarise(mtcars,avg_mpg = mean(mpg,na.rm=T))

mtcars %>% filter(cyl==6) %>% mean(hp,na.rm=T) # unfortunately, this does not work
mtcars %>% filter(cyl==6) %>% summarise(std_hp=mean(hp,na.rm=T))


# tidyr -- every ROW is an OBSERVATION; every COLUMN is a FEATURE/VARIABLE
install.packages('tidyr')
library(tidyr)
#data.table -- like a data.frame, but with a few extra features
install.packages('data.table')
library(data.table)

comp <- c(1,1,1,2,2,2,3,3,3)
yr <- c(1998,1999,2000,1998,1999,2000,1998,1999,2000)
q1 <- runif(9, min=0, max=100)
q2 <- runif(9, min=0, max=100)
q3 <- runif(9, min=0, max=100)
q4 <- runif(9, min=0, max=100)

df <- data.frame(comp=comp,year=yr,Qtr1 = q1,Qtr2 = q2,Qtr3 = q3,Qtr4 = q4)
df # wide-format

#gather() -- collapse multiple columns into key,value pairs
# SYNTAX: gather(data.frame,key,value,list_of_key_columns_to_gather)
gather(df,Quarter,Revenue,Qtr1:Qtr4)

#can use PIPE to do this, too
df %>% gather(Quarter,Revenue,Qtr1:Qtr4)

#spread() -- complements what gather() does

stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
stocks
head(stocks)

stocks.gathered <- stocks %>% gather(stock,price,X,Y,Z)
head(stocks.gathered)

stocks.gathered %>% spread(stock,price) # reverses what we did with gather()

spread(stocks.gathered,time,price) # weird stuff...but it works if you want it

#separate() - turn a single character column into multiple columns
df <- data.frame(new.col=c(NA,"a.x","b.y","c.z"))
df

separate(df,new.col,c('ABC','XYZ')) # default separator is non-alphanumeric characters

df <- data.frame(new.col=c(NA,"a-x","b-y","c-z"))
df
separate(data = df,col = new.col,into = c('abc','xyz'),sep='-') #same thing, but more explicit argument labels

#unite() - paste multiple colums into one
df.sep <- separate(data = df,col = new.col,into = c('abc','xyz'),sep='-') #same thing, but more explicit argument labels
df.sep

unite(df.sep,new.joined.col,abc,xyz) #defaults to '_' delimiter
unite(df.sep,new.joined.col,abc,xyz,sep='---')

