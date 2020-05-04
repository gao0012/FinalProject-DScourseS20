---
title: 'final'
output: html_document
---

```{r}
library(tidyverse)
library(caret)
library(naniar)
library(ggplot2)
library(broom)
library(MASS)
library(mice)
library(DMwR2)
library(ggplot2)
library(dplyr)
library(Hmisc)
library(car)
library(caTools)
library(readr)  
library(rpart)  
library(InformationValue)
library(stringr)  
library(randomForest)
library(VIM)
library(readr)  
library(dplyr)  
library(ggplot2)  
library(VIM)  
library(rpart)  
library(InformationValue) 
library(stringr)  
library(randomForest) 
coronavirus <- read.csv("/Users/gaoningjing/Desktop/coronavirus.csv")
str(coronavirus)
coronavirus[coronavirus[1:nrow(coronavirus), ] == ""] <- NA
aggr(coronavirus,plot=FALSE)
view(coronavirus)
summary(coronavirus)



a <- sub("f","0",coronavirus$gender)
b <- sub("m","1",a)
coronavirus$gender <- b
coronavirus$gender


coronavirus$age
is.na(coronavirus$age)
coronavirus%>%distinct(age)
coronavirus%>%summarise(n = n_distinct(age))
coronavirus%>%summarise(count = sum(is.na(age)))
coronavirus %>% summarise(n = n_distinct(age),
                          na = sum(is.na(age)),
                          med = median(age, na.rm = TRUE))
coronavirus%>%mutate(age=replace(coronavirus$age,is.na(coronavirus$age),median(coronavirus$age, na.rm = TRUE)))
coronavirus <- coronavirus %>% mutate(age = replace(age,is.na(age),median(age, na.rm = TRUE)))





# 75% of our data will be training data and the 25% will be the test data.
data_split = sample.split(coronavirus, SplitRatio = 0.75)
train <- subset(coronavirus, data_split == TRUE)
test <-subset(coronavirus, data_split == FALSE)



summary(coronavirus)

```

#death&location
```{r}

data <- read.csv("/Users/gaoningjing/Downloads/19.csv")
str(data$location)
data$death <- sort(data$death)
data <- data[-c(1065:1085),]
tail(data$death)

data$death <- as.numeric(data$death)


data2 <- aggregate(data$death, by=list(Category=data$country), FUN=sum)

data2 <- as.data.frame(data2)
view(data2)

ggplot(data = data2, aes(x = Category, y = x)) + 
  geom_bar(stat = "identity") + 
  coord_flip()
```




```{r}
coronavirus$gender <- factor(coronavirus$gender)


qplot(coronavirus$age, coronavirus$death,geom='smooth', span =0.5)

ggplot(data=coronavirus[1:nrow(train), ], aes(x=age, color=death)) +
  geom_line(stat = "bin", binwidth=5)
IV(X=factor(coronavirus$age[1:nrow(train)]),
   Y=coronavirus$death[1:nrow(train)])


ggplot(data = coronavirus[1:nrow(train), ], aes(x=gender, y =..count.., fill=death)) +
  geom_bar(position="dodge") +
  geom_text(stat = "count", aes(label=..count..), position=position_dodge(.9), vjust=-.3)
IV(X=factor(coronavirus$gender[1:nrow(train)]),
   Y=coronavirus$death[1:nrow(train)])
```

```{r}
library(psych)
pairs.panels(coronavirus[c("death","age","gender","visiting.Wuhan","from.Wuhan","Hospied")])
```


```{r}
ins_model <- lm(death~age+gender+visiting.Wuhan+from.Wuhan+Hospied,data=newdata)
ins_model
stargazer(ins_model)
summary(ins_model)



ins_model2 <-lm(death~age+gender+visiting.Wuhan+from.Wuhan+Hospied+Hospied^2+age * from.Wuhan,data=newdata)
summary(ins_model2)
stargazer(ins_model2, type="latex")
```
```{r}
n <- length(names(train))
n
model <- randomForest(as.factor(death) ~ age+gender+visiting.Wuhan+from.Wuhan+Hospied+Hospied^2+age * from.Wuhan, 
data = train, ntree=800)
model
str(model)


importance <- importance(x=model)
importance

varImpPlot(model)



train_pred <- predict(model, train)
mean(train_pred==train$death)
table(train_pred, train$death)


```


```{r}
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(SnowballC)
library(syuzhet)
library(tidyverse)
library(tidytext)
library(ggplot2)
library(forcats)
library(textdata)
requestURL = "https://api.twitter.com/oauth/request_token"
accessURL = "https://api.twitter.com/oauth/access_token"
authURL = "https://api.twitter.com/oauth/authorize"
consumerKey = "nwbD6gBLHDCpIsoklUWUDP7f2"
consumerSecret = "wUi5n5znER1LkEDO16gIum23hJdayT3ncjXObrCEG4qGPVAmHS"
accessToken = "1189379771769245696-6bxB4O9DbzUqawiCUfAcgigy25StjT"
accessSecret = "jSEWNcMZCkeAxb0Fh2M20Vymv3GKOB1RwtjXjrhg5U6Mv"
setup_twitter_oauth(consumerKey,
                    consumerSecret,
                    accessToken,
                    accessSecret)

tweets <- searchTwitter('#coronavirus', 
                        n=500, retryOnRateLimit=1)
tweets.df <- twListToDF(tweets) 
View(tweets.df)
head(tweets.df$text)

tweets.df2 <- gsub("http.*","",tweets.df$text)
tweets.df2 <- gsub("https.*","",tweets.df2)
tweets.df2 <- gsub("#.*","",tweets.df2)
tweets.df2 <- gsub("@.*","",tweets.df2)
tweets.df2 <- gsub("RT","",tweets.df2)
View(tweets.df2)

data <- data.frame(tweets = as.character(tweets.df2), 
                   stringsAsFactors = FALSE)
data <- data %>% 
  unnest_tokens(word, tweets)

sentiment <- get_sentiments("nrc")
data <- inner_join(data, sentiment, by = "word")
ggplot(data = data, aes(x = fct_rev(fct_infreq(sentiment)))) +
  geom_bar() +
  coord_flip()
```
