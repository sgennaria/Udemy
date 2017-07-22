state.x77

USPersonalExpenditure

women

data()
head(state.x77)
tail(state.x77)

str(state.x77)

summary(state.x77)

days <- c('Mon','Tue', 'Wed','Thu','Fri')
temp <- c(22.2,21,23,24.3,25)
rain <- c(T,T,F,F,T)

df <- data.frame(days,temp,rain)
df
str(df)
summary(df)

df[1,]
df[,1]

df[,'rain']
df[1:5,c('days','temp')]

df$days
df$temp
df['days']

subset(df,subset=rain==T)
subset(df,subset=temp>23)

sorted.temp <- order(df['temp'])
sorted.temp
df[sorted.temp,]

desc.temp <- order(-df['temp'])
desc.temp
df[desc.temp,]

desc.temp <- order(-df$temp)
desc.temp

empty <- data.frame()
c1 <- 1:10
c1
letters
numbers
c2 <- letters[1:10]
c1
c2
df <- data.frame(col.name.1=c1, col.name.2=c2)
df

write.csv(df,file='saved_df.csv')
df2 <- read.csv('saved_df.csv')

df2

nrow(df)
ncol(df)
colnames(df)
rownames(df)
str(df)
summary(df)

# referencing single cells with double-bracket [[]] notation
df[[5,2]]
df[[5,'col.name.2']]
df[[2,'col.name.1']] <- 9999
df

#referencing rows
df[1,]

#referencing columns
mtcars
head(mtcars)

# 4 different ways to return a vector of values from a column...
mtcars$mpg
mtcars[,'mpg']
mtcars[,1]
mtcars[['mpg']]

# return a data frame with a single column
mtcars['mpg']
mtcars[1]

#return a data frame with multiple columns
head(mtcars[c('mpg','cyl')])
head(mtcars[c(1,2)])

# add a new row to an existing data frame
df2 <- data.frame(col.name.1=2000,col.name.2='new')
df2
df
dfnew <- rbind(df, df2)
dfnew

# add a new column to an existing data frame
2*df$col.name.1 #returns a vector of values we want to add as a new column
df$newcol <- 2*df$col.name.1 # populate new column by multiplying values in first column by 2
df

df$newcol.copy <- df$newcol
head(df)

df[,'newcol.copy2'] <- df$newcol
head(df)

# change names of columns
colnames(df)
colnames(df) <- c('1','2','3','4','5')
head(df)

#change name of single column
colnames(df)[1] <- 'NEW COL NAME'
head(df)

# select multiple rows 
df[1:10,]
df[1:3,]
head(df)
head(df,7)

df[-2,] #exclude a row from being returned

head(mtcars)
mtcars[mtcars$mpg>20,]

head(mtcars)
mtcars[mtcars$mpg>20 & mtcars$cyl==6,] # this is the proper way to satisfy both booleans
mtcars[mtcars$mpg>20 && mtcars$cyl==6,] # DO NOT MAKE THIS MISTAKE
mtcars$mpg>20
mtcars$cyl==6
mtcars$mpg>20 & mtcars$cyl==6 # This returns a vector of logical values representing each index
mtcars$mpg>20 && mtcars$cyl==6 # Not sure what this does, but we don't want it since it returns a single value

mtcars[(mtcars$mpg>20 & mtcars$cyl==6), c('mpg','cyl','hp')]
subset(mtcars, mpg>20 & cyl==6) # this is another way of doing the same row filters
subset(mtcars, mpg>20 & cyl==6)[,c('mpg','cyl','hp')]

# dealing with MISSING DATA
is.na(mtcars) # there is no missing data
any(is.na(mtcars)) # faster way of seeing if there is any missing data
any(is.na(mtcars$mpg)) # check for missing data in a single column
df[is.na(df)] <- 0 # replace all NA columns with a value
df
mtcars$mpg[is.na(mtcars$mpg)] <- mean(mtcars$mpg) # apparently some people like to plug averages into missing values

# Exercises:
Age <- c(22,25,26)
Weight <- c(150,165,120)
Sex <- c('M','M','F')
names <- c('Sam','Frank','Amy')
data.frame(Age,Weight,Sex,row.names = names)

is.data.frame(mtcars)

mat <- matrix(1:25,nrow=5)
mat
is.data.frame(mat)
dfmat <- as.data.frame(mat)
is.data.frame(dfmat)
dfmat

df <- mtcars

head(df)

mean(df$mpg)

df[df$cyl==6,]

df[,c('am','gear','carb')]

df$performance <- df$hp / df$wt
df

head(df)

?round
df$performance <- round(df$performance, digits = 2)
head(df)

mean(subset(df,hp>100 & wt>2.5)$mpg)
mean(df[df$hp>100 & df$wt>2.5,'mpg'])

df['Hornet Sportabout',]$mpg
df['Hornet Sportabout', 'mpg']

