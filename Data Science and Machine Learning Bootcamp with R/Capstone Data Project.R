# fixed solution is all the way at the bottom

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

combo <- merge(batting, sal, by=c('playerID', 'yearID', 'teamID', 'lgID')) # in addition to playerid & yearid, this should also use teamid & lgid since the salaries depend on these factor.  This matches 814 (for year 2001) instead of 915 rows.

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

install.packages('RPostgreSQL')
library(RPostgreSQL)
pw<- {
  "password"
}
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "udemy",
                 host = "localhost", port = 5496,
                 user = "postgres", password = pw)
#dbDisconnect(con)

length(combo$playerID) # 915
length(unique(combo$playerID)) # 817 !!!
# not good! figure it out... #############################################
batting2001 <- batting %>% filter(yearID==2001)
sal2001 <- sal %>% filter(yearID==2001)
nrow(batting2001) # 1339
length(unique(batting2001$playerID)) # 1220 BAD
nrow(sal2001) # 860
length(unique(sal2001$playerID)) # 860 GOOD

pgbatting <- batting
names(pgbatting) <- tolower(names(pgbatting))
dbWriteTable(con, "batting", pgbatting, row.names=TRUE, append=FALSE)

pgsal <- sal
names(pgsal) <- tolower(names(pgsal))
dbWriteTable(con, "sal", pgsal, row.names=TRUE, append=FALSE)

combo2001 <- merge(batting2001, sal2001, by=c('playerID', 'yearID'))
nrow(combo2001) # 915 UH OH, HOW?
##########################################################################


fcombo <- subset(combo, select=c('playerID', 'salary', 'AB', 'OBP'))

dbWriteTable(con, "fcombo", fcombo, row.names=TRUE, append=FALSE)

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

dbWriteTable(con, "fcombo2", fcombo2, row.names=TRUE, append=FALSE)

ufcombo2 <- sqldf("
SELECT
  DISTINCT playerID_a, playerID_b
FROM
  fcombo2
")

ufcombo2_2 <- sqldf("
SELECT
  playerID_a, playerID_b
FROM
  fcombo2
GROUP BY
  playerID_a, playerID_b
")

ufcombo22 <- sqldf("
SELECT
  b.*
FROM
  ufcombo2 AS a
LEFT JOIN
  fcombo2 AS b
ON
  (a.playerID_a = b.playerID_a
  AND a.playerID_b = b.playerID_b)
")

ufcombo22 %>% filter(playerID_a=='abbotje01' & playerID_b=='abbotku01')
ufcombo22 %>% filter(playerID_a=='abbotku01' & playerID_b=='abbotje01')

fcombo2 %>% filter((playerID_a=='abbotje01' & playerID_b=='abbotku01') | (playerID_a=='abbotku01' & playerID_b=='abbotje01'))
ufcombo2_2 %>% filter((playerID_a=='abbotje01' & playerID_b=='abbotku01') | (playerID_a=='abbotku01' & playerID_b=='abbotje01'))
ufcombo22 %>% filter((playerID_a=='abbotje01' & playerID_b=='abbotku01') | (playerID_a=='abbotku01' & playerID_b=='abbotje01'))

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



##########################################
##########################################
##########################################
##########################################
########## FIXED SOLUTION! ###############


batting <- read.csv('C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Batting.csv')

batting$BA <- batting$H / batting$AB

batting$X1B <- batting$H - batting$X2B - batting$X3B - batting$HR

batting$OBP <- (batting$H + batting$BB + batting$HBP) / (batting$AB + batting$BB + batting$HBP + batting$SF)

batting$SLG <- (batting$X1B + (2 * batting$X2B) + (3 * batting$X3B) + (4 * batting$HR)) / (batting$AB)

sal <- read.csv('C:/Users/sgenn_000/Documents/GitHub/Udemy/Data Science and Machine Learning Bootcamp with R/Guides/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Salaries.csv')

batting <- subset(batting, yearID >= 1985)

combo <- merge(batting, sal, by=c('playerID', 'yearID', 'teamID', 'lgID')) # in addition to playerid & yearid, this should also use teamid & lgid since the salaries depend on these factor.  This matches 814 (for year 2001) instead of 915 rows.

lost_players <- subset(combo, playerID %in% c('giambja01', 'damonjo01', 'saenzol01'))

lost_players <- subset(lost_players, yearID == 2001)

maxsal <- 15000000
minAB <- sum(lost_players$AB)
minOBP <- mean(lost_players$OBP)

combo <- subset(combo, yearID == 2001)

combo <- subset(combo, !(playerID %in% c('giambja01', 'damonjo01', 'saenzol01')))

length(combo$playerID) # 811
length(unique(combo$playerID)) #811

fcombo <- subset(combo, select=c('playerID', 'salary', 'AB', 'OBP'))

test <- data.frame(a = c(3,1,2,2,1,3), b = c(1,2,1,3,3,2), c = c(2,3,3,1,2,4))
unique(t(apply(test, 1, sort)))
!duplicated(t(apply(test, 1, sort)))

install.packages('sqldf')
library(sqldf)

options(sqldf.RPostgreSQL.user="postgres",
        sqldf.RPostgreSQL.password="password",
        sqldf.RPostgreSQL.dbname='udemy',
        sqldf.RPostgreSQL.host='localhost',
        sqldf.RPostgreSQL.port=5496)

str(fcombo)
names(fcombo) <- tolower(names(fcombo))
str(fcombo)

fcombo2 <- sqldf("
SELECT
  a.playerid AS playerid_a
  ,a.salary AS salary_a
  ,a.ab AS ab_a
  ,a.obp AS obp_a
  ,b.playerid AS playerid_b
  ,b.salary AS salary_b
  ,b.ab AS ab_b
  ,b.obp AS obp_b
FROM
  fcombo AS a
INNER JOIN
  fcombo AS b
ON
  a.playerid <> b.playerid
")

nrow(fcombo2) # 656910
fcombo2 %>% filter((playerid_a=='abbotje01' & playerid_b=='abbotku01') | (playerid_a=='abbotku01' & playerid_b=='abbotje01'))
fcombo2players <- fcombo2 %>% select(playerid_a, playerid_b)
nrow(fcombo2players) # 656910
#ufcombo2players <- unique(t(apply(fcombo2players, 1, sort))) # this does not return a data frame, which makes it inaccesible to sqldf
ufcombo2players <- fcombo2[!duplicated(t(apply(fcombo2players, 1, sort))),] # removes multiple rows with duplicated name combinations, regardless of column order
nrow(ufcombo2players) # 328455
str(ufcombo2players)

ufcombo2 <- sqldf("
SELECT
  a.*
FROM
  fcombo2 AS a
INNER JOIN
  ufcombo2players AS b
ON
  a.playerid_a = b.playerid_a
  AND a.playerid_b = b.playerid_b
ORDER BY
  a.playerid_a
  ,a.playerid_b
")
nrow(ufcombo2) #328455
ufcombo2 %>% filter((playerid_a=='abbotje01' & playerid_b=='abbotku01') | (playerid_a=='abbotku01' & playerid_b=='abbotje01'))

fcombo3 <- sqldf(paste0("
SELECT
  playerid_a
  ,salary_a
  ,ab_a
  ,obp_a
  ,playerid_b
  ,salary_b
  ,ab_b
  ,obp_b
  ,c.playerid AS playerid_c
  ,c.salary AS salary_c
  ,c.ab AS ab_c
  ,c.obp AS obp_c
FROM
  ufcombo2 AS a
INNER JOIN
  fcombo AS c
ON
  playerid_a <> c.playerid
  AND playerid_b <> c.playerid
WHERE
  (salary_a + salary_b + c.salary) <= ", maxsal, "
  AND (ab_a + ab_b + c.ab) >= ", minAB, "
  AND ((obp_a + obp_b + c.obp) / 3) >= ", minOBP, "
"))

nrow(fcombo3) # 330906
head(fcombo3)
fcombo3 %>% filter(
  (playerid_a=='abreubo01' & playerid_b=='agbaybe01' & playerid_c=='aurilri01') | 
  (playerid_a=='abreubo01' & playerid_b=='aurilri01' & playerid_c=='agbaybe01') |
  (playerid_a=='agbaybe01' & playerid_b=='abreubo01' & playerid_c=='aurilri01') |
  (playerid_a=='agbaybe01' & playerid_b=='aurilri01' & playerid_c=='abreubo01') |
  (playerid_a=='aurilri01' & playerid_b=='abreubo01' & playerid_c=='agbaybe01') |
  (playerid_a=='aurilri01' & playerid_b=='agbaybe01' & playerid_c=='abreubo01')
)

fcombo3players <- fcombo3 %>% select(playerid_a, playerid_b, playerid_c)
ufcombo3players <- fcombo3[!duplicated(t(apply(fcombo3players, 1, sort))),] # removes multiple rows with duplicated name combinations, regardless of column order
nrow(ufcombo3players) # 110302

ufcombo3 <- sqldf("
SELECT
  a.*
FROM
  fcombo3 AS a
INNER JOIN
  ufcombo3players AS b
ON
  a.playerid_a = b.playerid_a
  AND a.playerid_b = b.playerid_b
  AND a.playerid_c = b.playerid_c
ORDER BY
  a.playerid_a
  ,a.playerid_b
  ,a.playerid_c
")
nrow(ufcombo3)
ufcombo3 %>% filter(
    (playerid_a=='abreubo01' & playerid_b=='agbaybe01' & playerid_c=='aurilri01') | 
    (playerid_a=='abreubo01' & playerid_b=='aurilri01' & playerid_c=='agbaybe01') |
    (playerid_a=='agbaybe01' & playerid_b=='abreubo01' & playerid_c=='aurilri01') |
    (playerid_a=='agbaybe01' & playerid_b=='aurilri01' & playerid_c=='abreubo01') |
    (playerid_a=='aurilri01' & playerid_b=='abreubo01' & playerid_c=='agbaybe01') |
    (playerid_a=='aurilri01' & playerid_b=='agbaybe01' & playerid_c=='abreubo01')
)

ufcombo3$total_salary <- ufcombo3$salary_a + ufcombo3$salary_b + ufcombo3$salary_c
ufcombo3$total_AB <- ufcombo3$ab_a + ufcombo3$ab_b + ufcombo3$ab_c
ufcombo3$mean_OBP <- mean(c(ufcombo3$obp_a, ufcombo3$obp_b, ufcombo3$obp_c))

head(ufcombo3)
maxsal
minAB
minOBP

ufcombo3 %>% filter(
  (playerid_a=='heltoto01' & playerid_b=='berkmla01' & playerid_c=='gonzalu01') | 
  (playerid_a=='heltoto01' & playerid_b=='gonzalu01' & playerid_c=='berkmla01') |
  (playerid_a=='berkmla01' & playerid_b=='heltoto01' & playerid_c=='gonzalu01') |
  (playerid_a=='berkmla01' & playerid_b=='gonzalu01' & playerid_c=='heltoto01') |
  (playerid_a=='gonzalu01' & playerid_b=='heltoto01' & playerid_c=='berkmla01') |
  (playerid_a=='gonzalu01' & playerid_b=='berkmla01' & playerid_c=='heltoto01')
) # this combo was the teacher's arbitrary solution, and it is still present in my solution

head(ufcombo3 %>% arrange(total_salary, desc(mean_OBP), desc(total_AB))) # sort by what you want
head(ufcombo3 %>% arrange(desc(mean_OBP), desc(total_AB), total_salary)) # sort by what you want
head(ufcombo3 %>% arrange(desc(total_AB), desc(mean_OBP), total_salary)) # sort by what you want


