library(gtrendsR)
library(ggplot2)
library(tidyverse)

#We are creatin a dataframe using the package gtrendsR
bitcoin.trend <- gtrends(c("bitcoin"), gprop = "web", time = "all")[[1]]
#We check we created a data.frame
class(bitcoin.trend)
#And we show the first rows
head(bitcoin.trend)
#We check the class of the variable date in bitcoin dataframe
class(bitcoin.trend$date)

#We plot a line with date in x and hits in y
ggplot(data = bitcoin.trend) + geom_line(mapping = aes(x= date, y = hits))
?gtrends

bitcoin.trend <- bitcoin.trend %>% filter(date >= as.Date("2009-01-01"))
ggplot(data = bitcoin.trend) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red") #trump inauguration
  

library(Quandl)
bitcoin.price <- Quandl("BCHARTS/BITSTAMPUSD")
bitcoin.price <- bitcoin.price %>% filter(Date %in% bitcoin.trend$date) %>% select(Date, Close) %>% rename(date = Date, price = Close) %>% mutate(price = price*100/max(price))

bitcoin <- left_join(x = bitcoin.trend, y= bitcoin.price, by = "date")
head(bitcoin)

ggplot(data = bitcoin) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_line(mapping = aes(x= date, y = price), color = "gray") + 
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red")

