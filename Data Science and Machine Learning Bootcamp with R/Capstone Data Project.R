batting <- read.csv('C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Batting.csv')

head(batting)
str(batting)
head(batting$AB, 5)
head(batting$X2B, 5)


batting$BA <- batting$H / batting$AB
tail(batting$BA, 5)

batting$X1B <- batting$H - batting$X2B - batting$X3B - batting$HR

batting$OBP <- (batting$H + batting$BB + batting$HBP) / (batting$AB + batting$BB + batting$HBP + batting$SF)

batting$SLG <- (batting$X1B + (2 * batting$X2B) + (3 * batting$X3B) + (4 * batting$HR)) / (batting$AB)

str(batting)

sal <- read.csv('C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Salaries.csv')

head(sal)

summary(batting)
summary(sal)

batting <- subset(batting, yearID >= 1985)

summary(batting)
str(batting)

combo <- merge(batting, sal, by=c('playerID', 'yearID'))

str(combo)
summary(combo)

lost_players <- subset(combo, playerID %in% c('giambja01', 'damonjo01', 'saenzol01'))
lost_players

lost_players <- subset(lost_players, yearID == 2001)
lost_players

maxsal <- 15000000
minAB <- sum(lost_players$AB)
minOBP <- mean(lost_players$OBP)

combo <- subset(combo, yearID == 2001)

library(dplyr)
str(combo)

install.packages('sqldf')
library(sqldf)

fcombo <- subset(combo, select=c('playerID', 'salary', 'AB', 'OBP'))

fcombo2 <- sqldf("
SELECT
  a.playerID AS playerID_a
  ,a.salary AS salary_a
  ,a.AB AS AB_a
  ,a.OBP AS OBP_a
  ,b.playerID AS playerID_b
  ,b.salary AS salary_b
  ,b.AB AS AB_b
  ,b.OBP AS OBP_b
FROM
  fcombo AS a
INNER JOIN
  fcombo AS b
ON
  a.playerID <> b.playerID
                 ")

fcombo3 <- sqldf("
SELECT
  playerID_a
  ,salary_a
  ,AB_a
  ,OBP_a
  ,playerID_b
  ,salary_b
  ,AB_b
  ,OBP_b
  ,c.playerID AS playerID_c
  ,c.salary AS salary_c
  ,c.AB AS AB_c
  ,c.OBP AS OBP_c
FROM
  fcombo2 AS a
INNER JOIN
  fcombo AS c
ON
  playerID_a <> c.playerID
  AND playerID_b <> c.playerID
WHERE
  (salary_a + salary_b + c.salary) <= 15000000
  AND (AB_a + AB_b + c.AB) >= 1469
  AND ((OBP_a + OBP_b + c.OBP) / 3) >= 0.3638687
                 ")

str(fcombo3)

fcombo3$total_salary <- fcombo3$salary_a + fcombo3$salary_b + fcombo3$salary_c
fcombo3$total_AB <- fcombo3$AB_a + fcombo3$AB_b + fcombo3$AB_c
fcombo3$mean_OBP <- mean(c(fcombo3$OBP_a, fcombo3$OBP_b, fcombo3$OBP_c))

fcombo3 <- arrange(fcombo3, total_salary)
