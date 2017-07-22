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

#histograms
install.packages('ggplot2movies')

#DATA AND AESTHETICS
pl <- ggplot(movies, aes(x=rating))

#geometry
pl2 <- pl + geom_histogram(binwidth = 0.1, color='red', fill='pink', alpha=0.4)

pl3 <- pl2 + xlab('Movie Rating') + ylab('Count')

pl3 + ggtitle("My Title")

# advanced fill
pl2 <- pl + geom_histogram(binwidth = 0.1, aes(fill=..count..))

#Scatter Plots
df <- mtcars
pl <- ggplot(df, aes(x=wt, y=mpg))
pl + geom_point(alpha=0.5, size=5)
pl + geom_point(aes(size=hp), alpha = 0.5)

pl + geom_point(aes(size=cyl), alpha = 0.5)
#but cyl should be a factor, not a continuous variable...
pl + geom_point(aes(size=factor(cyl)), alpha = 0.5)
pl + geom_point(aes(shape=factor(cyl)), alpha = 0.5, size=5)                
pl + geom_point(aes(shape=factor(cyl), color=factor(cyl)), alpha = 0.5)
pl2 <- pl + geom_point(aes(color=hp), size=5)
pl3 <- pl2 + scale_color_gradient(low='blue', high='red')

#BAR PLOT
df <- mpg

pl <- ggplot(df, aes(x=class))
pl + geom_bar(aes(fill=drv), position='dodge')
pl + geom_bar(aes(fill=drv), position='fill') # shows the drv data as a percentage within each class

#Box Plot
df <- mtcars

pl <- ggplot(df, aes(x=cyl, y=mpg))
pl + geom_boxplot() # warning... x value should not be continuous... should be discrete
pl <- ggplot(df, aes(x=factor(cyl), y=mpg))
pl + geom_boxplot()
pl + geom_boxplot() + coord_flip()
pl + geom_boxplot(aes(fill=factor(cyl)))
pl + geom_boxplot(aes(fill=factor(cyl))) + theme_dark()


# 2-variable plots
pl <- ggplot(movies, aes(x=year, y=rating))
pl2 <- pl + geom_bin2d() + scale_fill_gradient(high='red', low='green')

pl2 <- pl + geom_bin2d(binwidth=c(3,1)) + scale_fill_gradient(high='red', low='blue')

#hex plot
install.packages('hexbin')
library(hexbin)
pl2 <- pl + geom_hex()
pl2 + scale_fill_gradient(high='red', low='blue')

#density plot
pl2 <- pl + geom_density2d()
pl2


# Coordinates and Faceting
pl <- ggplot(mpg, aes(x=displ, y=hwy)) + geom_point()

pl2 <- pl + coord_cartesian(xlim=c(1,4), ylim=c(15,30))
pl2 <- pl + coord_fixed(ratio=1/3)
pl2

# facet grid
pl + facet_grid(. ~ cyl)
pl + facet_grid(drv ~ .)
pl + facet_grid(drv ~ cyl)

#Themes 
pl <- ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()

theme_set(theme_minimal()) # sets ongoing theme for following plots
pl

pl + theme_dark()

install.packages('ggthemes')
library(ggthemes)

pl + theme_economist()
pl + theme_fivethirtyeight()
pl + theme_wsj()

# Exercises
library(ggplot2)
library(ggthemes)

head(mpg)

ggplot(mpg, aes(x=hwy)) + geom_bar(color='salmon', fill='salmon')

ggplot(mpg, aes(x=manufacturer)) + geom_bar(aes(fill=factor(cyl)))

head(txhousing)

ggplot(txhousing, aes(x=sales, y=volume)) + geom_point(color='blue', alpha=0.5)

ggplot(txhousing, aes(x=sales, y=volume)) + geom_point(color='blue', alpha=0.5) + geom_smooth(color='red')
