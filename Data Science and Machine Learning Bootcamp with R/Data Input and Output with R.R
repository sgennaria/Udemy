write.csv(mtcars,file='my_example.csv')

ex <- read.csv('my_example.csv')
ex

class(ex)

# library to READ from excel files
install.packages('readxl')
library(readxl)

# read in a single excel sheet
excel_sheets('Sample-Sales-Data.xlsx')
df <- read_excel('Sample-Sales-Data.xlsx','Sheet1')
df
head(df)

#read in an entire excel workbook
entire.workbook <- lapply(excel_sheets('Sample-Sales-Data.xlsx'),read_excel,path="Sample-Sales-Data.xlsx")
entire.workbook

# library to WRITE to excel files
install.packages('xlsx')
library(xlsx)

head(mtcars)

write.xlsx(mtcars,"output_example.xlsx")

install.packages('RPostgreSQL')
library(RPostgreSQL)

# WEB SCRAPING
install.packages('rvest')
install.packages('V8')
install.packages('RSelenium')
library(rvest) # this also allow the %>% pipe operator
library(V8)
demo(package='rvest')
demo(package='rvest',topic='tripadvisor')

lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")
lego_movie %>% html_node("strong span") %>% html_text() %>% as.numeric()

lego_movie %>% 
  html_nodes("#titleCast .itemprop span") %>%
  html_text()

lego_movie %>%
  html_nodes("table") %>%
  .[[3]] %>%
  html_table()

lego_movie %>% 
  html_nodes("#titleUserReviewsTeaser") %>%
  html_text()

?html_node


#######
library(rvest)
URL <- "http://www.kennedy-center.org/calendar/index"
kc <- read_html(URL)

kc %>% html_node('body.kc div.no-scroll div#container div#all-content div.events-page.view-calendar.month div.stripe.events-wrap div#event-calendar-container')

kc %>% html_nodes('body.kc div.no-scroll div#container div#all-content div.events-page.view-calendar.month div.stripe.events-wrap div#event-calendar-container') %>% html_text()


#######
# CSS tutorial
#  the # symbol selects elements with an ID, and can also be combined with a specific node:
# #fancy OR plate#fancy
# compound CSS to select nodes inside others, separated only by a space: plate apple OR #fancy pickle
#  the . symbol selects elements by their class name, and can also be combined with a specific node:
# orange.small OR bento orange.small
# the , separates CSS filters which act independently (like an OR operator):
# plate, bento
# the * symbol selects everything, and can be combined with other rules:
# plate * OR plate#fancy *
# the + symbol selects elements that directly follow other elements on the same level/depth
# plate + apple
# the ~ symbol selects all elements that follow another
# bento ~ pickle
# the > symbol selects elements that are direct children of other elements (first level)
# plate > apple
# :first-child selects all first child elements of a certain type
# orange:first-child
# :only-child selects elements which are the only elements inside of another
# apple:only-child
# :last-child selects elements which are the last elements inside of another (note: single elements
# are considered first, only and last children)
# apple:last-child
# :nth-child(n) selects the nth child element in another
# plate:nth-child(3)
# :nth-last-child(n) selects the nth child from the end (counts in reverse)
# bento:nth-last-child(3)
# :first-of-type selects the first desired element
# apple:first-of-type
# :nth-of-type(n) selects the nth of the desired type, and can also count odd or even elements
# using those keywords:
# plate:nth-of-type(2) OR plate:nth-of-type(even)
# :nth-of-type(n) can also use formulas e.g. apple:nth-of-type(6n+2) selects every sixth apple
# starting with the 2nd
# :only-of-type selects elements which are the only ones of their type within their parent
# apple:only-of-type
# :last-of-type selects elements which are the last within their parent
# .small:last-of-type
# :empty selects empty elements
# bento:empty
# :not(x) selects elements which do not match the negation selector
# apple:not(.small)
# [attribute] selects elements that have a specific attribute (the value may or may not be 
# defined):
# apple[for='Ethan'] OR [for] OR plate[for]
# ^= is used to select attribute values that start with a specified string
# [for^='Sa']
# $= is used to select attribute values that end with a specified string
# [for$='ato']
# *= is used to select attribute values that contain a specified string anywhere
# [for*='obb']
# 
