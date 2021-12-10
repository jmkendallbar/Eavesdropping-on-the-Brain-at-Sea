# Set up packages
library(ggplot2)
library("car")
library("lubridate")
library(here)
library(tidyverse)
library(lme4)
library(reshape2)

# Run this to load in raw data across recording locations
SignalExcerpts <- read.csv(here("data","06_Signal_Quality_Excerpts_Across_Locations.csv"))

# Run this to load in raw data across various signal challenges/solutions
SignalExcerpts <- read.csv(here("data","06_Signal_Quality_Excerpts_Challenges_Solutions.csv"))

# Making a label column to facet by
SignalExcerpts$LABEL <- paste(SignalExcerpts$Wild.v.Captive,
                              SignalExcerpts$Active.v.SWS.v.REM,
                              SignalExcerpts$Activity,
                              SignalExcerpts$Location, sep="_")

SignalExcerpts.long <- SignalExcerpts %>% gather(Signal,Value,ECG,LEEG1,REEG2,LEEG3,REEG4,-c(LABEL, Seconds))
SignalExcerpts_plot <- SignalExcerpts.long %>%  
  select('Seconds','Value','Signal','LABEL','Wild.v.Captive','Active.v.SWS.v.REM','Activity','Location') %>% 
  na.omit()


# Offset values to visualize in plot
Offset_ECG <- SignalExcerpts_plot %>% 
  filter(Signal=="ECG") %>% 
  mutate(Offset_value=Value+100)
Offset_LEEG1 <- SignalExcerpts_plot %>% 
  filter(Signal=="LEEG1") %>% 
  mutate(Offset_value=Value+50)
Offset_REEG2 <- SignalExcerpts_plot %>% 
  filter(Signal=="REEG2") %>% 
  mutate(Offset_value=Value-0)
Offset_LEEG3 <- SignalExcerpts_plot %>% 
  filter(Signal=="LEEG3") %>% 
  mutate(Offset_value=Value-50)
Offset_REEG4 <- SignalExcerpts_plot %>% 
  filter(Signal=="REEG4") %>% 
  mutate(Offset_value=Value-100)

Concatenated <- rbind(Offset_ECG,Offset_LEEG1,Offset_REEG2,Offset_LEEG3,Offset_REEG4)

Concatenated_2 <- rbind(Offset_LEEG1,Offset_REEG2,Offset_LEEG3,Offset_REEG4)

levels(factor(SignalExcerpts_plot$Signal))

# Scaled to show ECG
plotB <- ggplot(data=Offset_ECG,aes(x=Seconds,y=Offset_value, colour=Signal)) + 
  geom_line(alpha=0.5) +
  xlim(10,20)+
  ylim(-5000,7000) +
  facet_wrap(Wild.v.Captive ~ Location ~ Activity + Active.v.SWS.v.REM) +
  theme_classic() +
  labs(y= "Signal Quality by Location")
plotB

# Plot with EEG only
plotC <- ggplot(data=Concatenated_2,aes(x=Seconds,y=Offset_value, colour=Signal)) + 
  geom_line(alpha=0.5) +
  xlim(11,21)+
  ylim(-250,300) +
  facet_wrap(~LABEL) +
  theme_classic() +
  labs(y= "Signal Quality by Location")
plotC

#scaled to show all simultaneously
plotD <- ggplot(data=Concatenated,aes(x=Seconds,y=Offset_value, colour=Signal)) + 
  geom_line(alpha=0.5, size=0.8) +
  xlim(5,15)+
  ylim(-200,400) +
  facet_wrap(~LABEL) +
  theme_classic() +
  labs(y= "Signal Quality by Location")
plotD