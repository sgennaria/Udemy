# Natural Language Processing

# a "Bag of Words" is a vector of word-counts from a doc
# you can use cosine similarity on diff docs' vectors to determine their similarity

# Term Frequency is the importance of the term within a single doc
# Inverse Document Frequency is the importance of the term within a whole body of docs being compared

install.packages('tm')
install.packages('twitteR')
install.packages('wordcloud')
##install.packages('e1071') # Instructor TYPO!!!

library(tm)
library(twitteR)
library(wordcloud)
library(RColorBrewer)
library(e1071) # careful of instructor's typo!!
library(class)

# goto https://apps.twitter.com/
# create new app
# sb_nlpexampleapp
# populate the following keys from the "Keys and Access Tokens" tab:
# Consumer Key (API Key)
# Consumer Secret Key (API Secret)
# Access Token
# Access Token Secret

ck <- 'KAxnLeHzVGhHexZzeof4N0h0u'
csk <- 'eV3ff20B5lsD0gWni6lkRodSBVuRqSWRh2BqcHqeKx97hIn2w1'
at <- '850325260905959425-0PQgStKdB5kjHsgPxJ7Hrq88loh2Yse'
ats <- 'UhW18Gau65UULM6kra58WRqWdhFSWDOR52D0yP9g0wuTY'

# connect to twitter
setup_twitter_oauth(ck, csk, at, ats)
# the first time I ran this, it gave a message:
# > setup_twitter_oauth(ck, csk, at, ats)
# [1] "Using direct authentication"
# Use a local file ('.httr-oauth'), to cache OAuth access credentials between R sessions?
# 
# 1: Yes
# 2: No
# 
# Selection: 1
# Adding .httr-oauth to .gitignore
# > 
# In the future if this gives problems requiring manual input, you can try doing this:
# options(httr_oauth_cache=T)

# grab 1000 English tweets about 'soccer'
soccer.tweets <- searchTwitter('soccer', n=1000, lang = 'en')
# get the text data from those tweets
soccer.text <- sapply(soccer.tweets, function(x) x$getText())

# Clean it up... (remove emoticons, etc by forcing UTF-8 encoding)
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII')
# create a Corpus (from the 'tm' library)
soccer.corpus <- Corpus(VectorSource(soccer.text))

# create a DOCUMENT TERM MATRIX
term.doc.matrix <- TermDocumentMatrix(soccer.corpus, control = list(
  removePunctuation = TRUE
  ,stopwords = c('soccer', stopwords('english')) # remove words that are very common (e.g. 'the', 'he', 'she', etc... or whatever else).  The stopwords('english') function and parameter remove common english stopwords
  ,removeNumbers = TRUE
  ,tolower = TRUE
  )) 
# convert it to a matrix...
term.doc.matrix <- as.matrix(term.doc.matrix)

# get word counts...
word.freq <- sort(rowSums(term.doc.matrix), decreasing = TRUE)

# create a data frame with the words and their counts...
dm <- data.frame(word = names(word.freq), freq = word.freq)

# create a wordcloud
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, 'Dark2'))
# yuck...



# try again...
soccer.tweets <- searchTwitter('python', n=1000, lang = 'en')
soccer.text <- sapply(soccer.tweets, function(x) x$getText())
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII')
soccer.corpus <- Corpus(VectorSource(soccer.text))
term.doc.matrix <- TermDocumentMatrix(soccer.corpus, control = list(
  removePunctuation = TRUE
  ,stopwords = c('python', 'http', 'https', stopwords('english')) # remove words that are very common (e.g. 'the', 'he', 'she', etc... or whatever else).  The stopwords('english') function and parameter remove common english stopwords
  ,removeNumbers = TRUE
  ,tolower = TRUE
)) 
term.doc.matrix <- as.matrix(term.doc.matrix)
word.freq <- sort(rowSums(term.doc.matrix), decreasing = TRUE)
dm <- data.frame(word = names(word.freq), freq = word.freq)
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, 'Dark2'))
# nice...
