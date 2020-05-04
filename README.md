DScourseS20 Final Project
===
***This project uses the lm function to do a linear regression model to analyze the impact of early covid-19 deaths on patients. Death is hard to discribe and seems to be random. However, there are still some similarities in the group that 
died because of covid-19. Cause of its infectious nature. For example, older people are more likely to have other diseases, women are more likely to be physically inferior to men, and the number of deaths in areas with good medical conditions has less possibility. The purpose is to use patient data to predict the mortality of this group of people. And use the random forest algorithm to check the accuracy of the model.***
1. Download the data package from the kaggel website, and after observing multiple data sets, finally decided to use the data before March. Because the characteristics of early covid-19 patients are more obvious, it may be related to Wuhan, or 
the people around them are related to Wuhan. And the majority of confirmed cases occurred in China.
2. Clean up the data. There are a large number of unrelated variables in the data set. Delete them firstly. Then I found that in the effective variable, there are more than 200 values missing for age. We use the median of age to fill. For some variables that are difficult to return, such as date. I assigned them a dummy character. I establish this relationship by creating a binary indicator variable, which is set to 1, otherwise set to 0. Finally, 75% of the data set is changed to the training set, and 25% to the test set.
3. At the beginning, I did a simple logistic model, run the finalproject.rmd I uploaded to get the result:
log (death) = -0.168 + 0.004age + 0.032gender -0.017visiting.Wuhan + 0.168from.Wuhan + 0.0217Hospied,
Then improve the performance of the model. The influence of a feature is not cumulative, but only when the value of 
the feature reaches a given amount. For example, for young people in Wuhan, suffering from covid-19 is not necessarily 
fatal, but for the elderly (more than 50 years old, or themselves has other diseases), it may be a high risk of death. 
I added new linear relationships to the model, Hospied ^ 2 and age * from. Wuhan. Hospied was not significant in the first model, and I felt unreasonable so I made this changes.
4. Random forest tests the predictability of the second model.
