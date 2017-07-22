install.packages('plotly')
library(ggplot2)
library(plotly)

pl <- ggplot(mtcars, aes(mpg,wt)) + geom_point()
pl

gpl <- ggplotly(pl)

gpl

