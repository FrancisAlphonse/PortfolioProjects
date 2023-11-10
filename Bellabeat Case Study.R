install.packages("tidyverse")
library(tidyverse)
install.packages("janitor")
library(janitor)
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
install.packages("readr")
library(readr)
install.packages("forcats")
library(forcats)
install.packages("scales")
library(scales)
install.packages("lubridate")
library(lubridate)
install.packages("geosphere")
library(geosphere)
install.packages("plotrix")
library(plotrix)
install.packages("here")
library(here)
install.packages("skimr")
library(skimr)
install.packages("tidyr")
library(tidyr)

# Here we have created a seperate data frames for each file and 
#we have read the csv files.
daily_activity <- read_csv("dailyActivity_merged.csv")
daily_calories <- read_csv("dailyCalories_merged.csv")
daily_intensities <- read_csv("dailyIntensities_merged.csv")
daily_steps <- read_csv("dailySteps_merged.csv")
daily_sleep <- read_csv("sleepDay_merged.csv")
heart_rate <- read_csv("heartrate_seconds_merged.csv")
weight_log_data <- read_csv("weightLogInfo_merged.csv")
minute_METs <- read_csv("minuteMETsNarrow_merged.csv")


# PROCESS
# We viewed the data of daily_activity with the help of head, 
# colnames and glimpse which helped us in head() showed us the first six
# rows of the dataset, then colnames() showed us the names of the column
# and the glimpse() showed us the glimpse of the data that how does 
# it looks like.
head(daily_activity)
colnames(daily_activity)
glimpse(daily_activity)


# We viewed the data of heart_rate with the help of head, colnames.
head(heart_rate)
colnames(heart_rate)


# We viewed the data of daily_sleep with the help of head, colnames.
head(daily_sleep)
colnames(daily_sleep)


# We viewed the data of weight_log_data with the help of head, colnames.
head(weight_log_data)
colnames(weight_log_data)


# We viewed the data of minute_METs with the help of head, colnames.
head(minute_METs)
colnames(minute_METs)


#ANALYZE
# Here we used the skim_without_charts function which helped us showing
#the summary of the dataset
skim_without_charts(daily_activity)
skim_without_charts(daily_sleep)
skim_without_charts(weight_log_data)

#Found out with the help of forign key in our case Id coloum 
#was comon in all the three dataset.
n_distinct(daily_activity$Id) #based on 30 participants. 
n_distinct(daily_sleep$Id)
n_distinct(weight_log_data$Id)


#Explore Average Sleep time & Average Time in Bed
Avg_minutes_asleep <- daily_sleep %>% 
  summarize(avg_sleeptime = mean(TotalMinutesAsleep))
Avg_minutes_asleep

Avg_Time_In_Bed <- daily_sleep %>% 
  summarize(avg_TimeInBed = mean(TotalTimeInBed))
Avg_Time_In_Bed


daily_activity <- daily_activity %>% 
  mutate(weekday1 = weekdays(as.Date(ActivityDate, "%m/%d/%Y")))
glimpse(daily_activity)


daily_activity$weekday1 <- ordered(daily_activity$weekday1, levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
activity_data <- daily_activity %>% 
  group_by(weekday1) %>% 
  summarize(count_of = n())
glimpse(activity_data)


#VISUALIZATION
# Explore number of times FitBit users track their activity 
#throughout the week. "Tracker Records".
ggplot(activity_data, aes(x=weekday1, y=count_of)) +
  geom_bar(stat="identity",color="black",fill="purple") +
  labs(title="Tracker user count across the week", x="Day of the week", y="Count") +
  geom_label(aes(label=count_of),color="black")

#Total Steps vs. Sedentary Minutes
ggplot(data=daily_activity,aes(x=TotalSteps,y=SedentaryMinutes, color=Calories)) +
  geom_point() +
  geom_smooth(method="lm",color="blue") +
  labs(title="Total Steps vs. Sedentary Minutes",x="Total Steps",y="Sedentary Minutes")+
  scale_color_gradient(low="pink",high="purple")

# Observing relationship between steps taken and calories burned
mean_steps <- mean(daily_activity$TotalSteps)
mean_steps

mean_calories <- mean(daily_activity$Calories)
mean_calories

ggplot(data=daily_activity, aes(x=TotalSteps,y=Calories,color=Calories)) +
  geom_point() +
  labs(title="Calories burned for every step taken",x="Total Steps Taken",y="Calories Burned") +
  geom_smooth(method="lm") +
  geom_hline(mapping = aes(yintercept=mean_calories),color="yellow",lwd=1.0)+
  geom_vline(mapping = aes(xintercept=mean_steps),color="red",lwd=1.0) +
  geom_text(mapping = aes(x=10000,y=500,label="Average Steps",srt=-90)) +
  geom_text(mapping = aes(x=29000,y=2500,label="Average Calories")) +
  scale_color_gradient(low="pink",high="purple")

#Total Minutes Asleep vs. Total Time in Bed
ggplot(data=daily_sleep, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) +
  geom_point() +
  labs(title="Time Asleep vs. Time in Bed",x="Time Asleep",y="Time in Bed") +
  geom_smooth(method="lm") + geom_jitter()

#Relationship between being very active and calories burned
ggplot(data=daily_activity, aes(x=VeryActiveMinutes, y=Calories, color=Calories)) +
  geom_point() +
  geom_smooth(method="loess",color="blue") +
  labs(title="Very Active Minutes vs. Calories",x="Very Active Minutes",y="Calories") + 
  scale_color_gradient(low="pink",high="purple")

#Relationship between sedentary minutes and calories burned
ggplot(data=daily_activity, aes(x=SedentaryMinutes,y=Calories,color=Calories)) +
  geom_point() +
  geom_smooth(method="loess",color="blue") +
  labs(title="Sedentary Minutes vs. Calories Burned",x="Sedentary Minutes",y="Calories") + 
  scale_color_gradient(low="pink",high="purple")


