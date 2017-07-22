install.packages('ggplot2')
library(ggplot2)
install.packages('ggthemes')
library(ggthemes)

# 7 Total Possible Layers of Data Visualization

# 3 MAIN layers of data visualization with ggplot2:
# Primary Layers: Data, Aesthetics, Geometries
p <- ggplot(mtcars) # data: from which to draw things
p <- p + aes(x=mpg,y=hp) # aesthetics: the look & feel of the background graph "paper"
p <- p + geom_point() # geometry: the specific look & feel of what to draw
p

# 4 Optional Layers
# Tertiary Layers: Facets, Statistics, Coordinates
p <- p + facet_grid(cyl~ .) # Facet grid
p <- p + stat_smooth() # Statistics
p <- p + coord_cartesian(xlim=c(15,25)) # Coordinates: ratio & limits of x/y axes
p <- p + theme_bw() # Theme
p


head(mpg)

pl <- ggplot(mpg,aes(x=hwy))
pl + geom_histogram(fill='pink')

bp <- ggplot(mpg, aes(x=manufacturer))
bp + geom_bar(aes(fill=factor(cyl)))
