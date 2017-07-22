2^5
stock.prices <- c(23,27,23,21,34)
stock.prices
names(stock.prices) <- c('Mon', 'Tues', 'Wed', 'Thu', 'Fri')
stock.prices
mean(stock.prices)
over.23 <- stock.prices > 23
over.23
stock.prices[over.23]
max(stock.prices)
