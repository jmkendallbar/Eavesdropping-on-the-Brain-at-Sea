library(ggplot2)
library("car")
library("lubridate")
library(here)
library(tidyverse)
library(lme4)
library(lmerTest)
library(cowplot)

# PROCESS DATA ----
ON_ANIMAL_TIMES <- metadata %>% 
  filter(description=='ON.ANIMAL') %>% 
  select(R.Time)

SignalData <- read.csv(here("Data","05_Signal_Quality_Data.csv"))
SignalData$R.Time <- as.POSIXct(SignalData[,2], format = "%m/%d/%Y %H:%M:%OS")

SignalData <- SignalData %>% 
  na.omit() %>% 
  arrange(Seal.ID)
for (i in 1:nrow(SignalData)){
    SignalData$Deployment[i] <- metadata$value[metadata$TestID==SignalData$Seal.ID[i] & 
                                                 metadata$description=='Deployment']
    SignalData$Seal.Number[i] <- metadata$value[metadata$TestID==SignalData$Seal.ID[i] & 
                                                 metadata$description=='Seal.Number']
    SignalData$Version[i] <- metadata$value[metadata$TestID==SignalData$Seal.ID[i] & 
                                                 metadata$description=='Version']
    SignalData$AGE[i] <- metadata$value[metadata$TestID==SignalData$Seal.ID[i] & 
                                                  metadata$description=='Age']
}

Raw_Metadata <- read.csv(here("Data","00_Raw_Scoring_Metadata.csv"))
EnterWater <- Raw_Metadata %>% 
  filter(CommentText=='Animal Enters Water') %>% 
  select('Seconds','SealID','CommentText')

ExitWater <- Raw_Metadata %>% 
  filter(CommentText=='Animal Exits Water') %>% 
  select('Seconds','SealID','CommentText')
Failed_Seconds=numeric()

for (i in 1:length(SealIDs)){
  SealID <- SealIDs[i] # cycle through all seals to find failures
  Seal_EnterWater <- EnterWater %>% filter(SealID==SealIDs[i])
  Seal_ExitWater  <- ExitWater %>% filter(SealID==SealIDs[i])
  if (nrow(Seal_EnterWater)==nrow(Seal_ExitWater)){
    Failed_Seconds[i]=NA
  } else if (str_detect(metadata$value[metadata$TestID==SealID & 
                                       metadata$description=='Device.Failure'],
                        "Yes") == "TRUE" ) {
    Failed_Seconds[i]=as.numeric(metadata$value[metadata$TestID==SealID & metadata$description=='Recording.Duration_s'])
  } else {
    Failed_Seconds[i]=NA
  }
}
Failed_in_Water_Seconds <- data.frame(as.numeric(Failed_Seconds),SealIDs,'fail')
colnames(Failed_in_Water_Seconds) <- c('Seconds','SealID','CommentText')
ExitWater <- rbind(ExitWater,Failed_in_Water_Seconds)
ExitWater <- ExitWater %>% 
  na.omit() %>% 
  arrange(as.character(SealID),as.numeric(Seconds)) %>% 
  mutate(SealID=factor(SealID))
EnterWater <- EnterWater %>% 
  arrange(as.character(SealID),as.numeric(Seconds)) %>% 
  mutate(SealID=factor(SealID))

WaterData <- cbind(EnterWater,ExitWater)
colnames(WaterData) <- c('EnterSec','EnterSealID','EnterComment','ExitSec','Seal.ID','ExitComment')

Seconds_at_ON_ANIMAL <- numeric()
for (i in 1:length(SealIDs)){
  SealID <- SealIDs[i] # cycle through all seals to find failures
  Seconds_at_ON_ANIMAL[i] <- difftime(metadata$R.Time[metadata$TestID==SealIDs[i] & metadata$description=='ON.ANIMAL'],
    metadata$R.Time[metadata$TestID==SealIDs[i] & metadata$description=='Logger.Start'],
    units="secs")
  WaterData$EnterSec_Elapsed[WaterData$Seal.ID==SealIDs[i]] <- WaterData$EnterSec[WaterData$Seal.ID==SealIDs[i]] - Seconds_at_ON_ANIMAL[i]
  WaterData$ExitSec_Elapsed[WaterData$Seal.ID==SealIDs[i]] <- WaterData$ExitSec[WaterData$Seal.ID==SealIDs[i]] - Seconds_at_ON_ANIMAL[i]
}


SignalData$Seconds.on.Animal <- as.double(SignalData[,1])

daysec <- 24*3600

SignalData_clean <- SignalData %>% 
  filter(Cmt.Text=="SWS2" | Cmt.Text== "REM") %>% 
  select('Seconds.on.Animal',
         as.factor('Cmt.Text'),
         as.factor('Seal.ID'),
         as.factor('Location'),
         as.factor('Phase'),
         as.factor('AGE'),
         as.factor('Version'),
         as.factor('Deployment'),
         as.factor('Seal.Number'),
         'R.Time',
         'BEST_EEG_DELTA',
         'EEG_ICA_DELTA',
         'EEG_Pruned_DELTA',
         'EEG_Raw1_DELTA')

# Binning into Days
SignalData_clean <- SignalData_clean %>%
  mutate(Day=as.double(ifelse(Seconds.on.Animal<daysec,"0",
                    ifelse(Seconds.on.Animal<2*daysec,"1",
                           ifelse(Seconds.on.Animal<3*daysec,"2",
                                  ifelse(Seconds.on.Animal<4*daysec,"3",
                                         ifelse(Seconds.on.Animal<5*daysec,"4",
                                                ifelse(Seconds.on.Animal<5*daysec,"5","6"))))))))

# Add pair labels
Label<-numeric(NROW(SignalData_clean))
#start indexing at 1
count<-1
Label[1] <- NA
#find first sleep stage
prevStage<-SignalData_clean[1,]$Cmt.Text
#iterate each row
for(i in 2:NROW(SignalData_clean)){
  curStage<-SignalData_clean[i,]$Cmt.Text
  #if whatever the criteria is
  if(curStage=="REM" & prevStage=="SWS2"){
    #label previous
    Label[i-1]<-count
    #label current
    Label[i]<-count
    prevStage<-curStage
    count<-count+1
  }else{
    #Not a pair
    Label[i]<-NA
    prevStage<-SignalData_clean[i,]$Cmt.Text
  }}
SignalData_clean$PairLabel <- Label

calculate_mode <- function(x) {
  uniqx <- unique(x)
  uniqx[which.max(tabulate(match(x, uniqx)))]
}

SignalData_paired <- SignalData_clean %>% 
  filter(!is.na(PairLabel)) %>% 
  group_by(PairLabel,Day) %>% 
  dplyr::summarise(MinSec=min(Seconds.on.Animal,na.rm=TRUE),
                   MeanSec=mean(Seconds.on.Animal,na.rm=TRUE),
                   Standardized = BEST_EEG_DELTA[Cmt.Text=="SWS2"]/BEST_EEG_DELTA[Cmt.Text=="REM"],
                   Seal.ID = as.factor(calculate_mode(Seal.ID)),
                   Location = as.factor(calculate_mode(Location)),
                   Version = as.factor(calculate_mode(Version)),
                   Phase = as.factor(calculate_mode(Phase)),
                   AGE = as.factor(calculate_mode(AGE)),
                   Deployment = as.factor(calculate_mode(Deployment)),
                   Seal.Number = as.factor(calculate_mode(Seal.Number)),
                   SWS = BEST_EEG_DELTA[Cmt.Text=="SWS2"],
                   REM = BEST_EEG_DELTA[Cmt.Text=="REM"]) %>% 
  mutate(PairLabel=as.numeric(PairLabel))
  
SignalData_paired$Days.Elapsed <- as.numeric(SignalData_paired$MeanSec)/(24*3600)
SignalData_paired$AGE <- factor(SignalData_paired$AGE, levels=c("(0,1]","(1,2]","(2,3]"))

SignalData_join <- left_join(by=c('Day','PairLabel'),SignalData_clean,SignalData_paired)

SignalData_binned <- SignalData_paired %>% 
  filter(!is.na(PairLabel)) %>% 
  group_by(Day,Seal.ID) %>% 
  dplyr::summarise(Mean=mean(Standardized),
                   sd=sd(Standardized),
                   max=max(Standardized),
                   min=min(Standardized),
                   Mean_SWS = mean(SWS),
                   sd_SWS = sd(SWS),
                   Mean_REM = mean(REM),
                   sd_REM = sd(REM),
                   Version = as.factor(calculate_mode(Version)),
                   Phase = as.factor(calculate_mode(Phase)),
                   Percent.Obs.Water = length(which(Location=="WATER")/length(Location)),
                   Deployment = as.factor(calculate_mode(Deployment)),
                   Seal.Number = as.factor(calculate_mode(Seal.Number)),
                   AGE = as.factor(calculate_mode(AGE)))

write.csv(SignalData_binned,here("Data","05_SignalData_binned.csv"))
write.csv(SignalData_paired,here("Data","05_SignalData_paired.csv"))

# PLOT DATA ----

LandvWater_colors<-c("LAND"="#dfc27d", #land color from divergent colorblind friendly color brewer palette
                     "WATER"="#80cdc1") #water color from divergent colorblind friendly color brewer palette

SleepState_colors<-c("SWS2" = "#6CAFE2",
                     "REM" = "#FFC000")

SleepState_allcolors <- c("MVMT (from calm)"= "#FF7F7F", 
                          "JOLT (from sleep)"= "#FF7F7F",
                          "CALM (from motion)" = "#ACD7CA", 
                          "WAKE (from sleep)" = "#ACD7CA", 
                          "LS (light sleep)" = "#CFCDEB",
                          "SWS1" = "#A3CEED",
                          "SWS2" = "#6CAFE2",
                          "REM" = "#FFC000")

#ALL ANIMALS Signal v. Time (by Day)
plotA <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=factor(Day), y=Standardized))+
  geom_jitter(data=SignalData_paired,aes(x=factor(Day), y=Standardized), alpha=0.2)+
  scale_y_log10()+
  theme_classic() +
  #annotate("text", x=4,y=2.25,label="REM v. SWS quantitatively distinguished")+
  labs(x="Day", y= "SWS Delta / REM Delta", title = "Signal Quality v Time (days)") +
  geom_hline(yintercept=2, linetype="dashed", color="gray")
plotA

#ALL ANIMALS Signal v. Time (by Day)
plotB <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=factor(Day), y=Standardized))+
  geom_jitter(data=SignalData_paired,aes(x=factor(Day), y=Standardized), alpha=0.2)+
  scale_y_log10()+
  facet_wrap(~Version)+
  theme_classic() +
  labs(x="Day", y= "SWS Delta / REM Delta", title = "Signal Quality v Time by Version") +
  geom_hline(yintercept=2, linetype="dashed", color="gray")
plotB

#LAND v WATER across VERSION
plotC <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)))+
  geom_jitter(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)),alpha=0.2)+
  scale_y_log10()+
  theme_classic() +
  geom_hline(yintercept=2, linetype="dashed", color="gray")+
  labs(x="Location", y= "SWS Delta / REM Delta", title = "Signal Quality v Location", color='Location') +
  theme(legend.position = c(.85,.85))
plotC

#LAND v WATER across VERSION
plotD <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)))+
  geom_jitter(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)),alpha=0.2)+
  facet_wrap(~Version)+
  scale_y_log10()+
  theme_classic() +
  geom_hline(yintercept=2, linetype="dashed", color="gray")+
  labs(x="Location", y= "SWS Delta / REM Delta", title = "Signal Quality v Location by Version (V1, V2, V3)", color='Location')+
  theme(legend.position = "none")
  #theme(legend.position = c(.85,.85))
plotD

#ALL ANIMALS Signal v AGE
plotE <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=AGE,y=Standardized))+
  geom_jitter(data=SignalData_paired,aes(x=AGE,y=Standardized),alpha=0.2)+
  scale_y_log10()+
  theme_classic() +
  geom_hline(yintercept=2, linetype="dashed", color="gray")+
  labs(x="Age of Seal",y= "SWS Delta / REM Delta", title="Signal Quality v Age") +
  theme(legend.position = "top")
plotE

#LAND v WATER across AGE
plotF <- ggplot() + 
  geom_boxplot(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)))+
  geom_jitter(data=SignalData_paired,aes(x=Location,y=Standardized,colour=factor(Location)),alpha=0.2)+
  facet_wrap(~AGE)+
  scale_y_log10()+
  theme_classic() +
  geom_hline(yintercept=2, linetype="dashed", color="gray")+
  labs(x="Location", y= "SWS Delta / REM Delta", title = "Signal Quality v Location by Age (years)", color='Location')+
  theme(legend.position = "none")
#theme(legend.position = c(.85,.85))
plotF

top_row <- plot_grid(plotA,plotB,labels="AUTO", rel_widths=c(1,2))
middle_row <- plot_grid(plotC,plotD,labels=c("C","D"), rel_widths=c(1,2))
bottom_row <- plot_grid(plotE,plotF,labels=c("E","F"), rel_widths=c(1,2))
Signal_Quality_plots<- plot_grid(top_row,middle_row,bottom_row,nrow=3)
ggsave(here("Figures",paste("06_Signal_Quality_plots.pdf",sep="")),Signal_Quality_plots, width= 10,height = 10,units="in",dpi=300)



# Plot with raw data, linear geom smooth, and water rectangles ----
sleep_cycle_lines <- ggplot()+
  geom_segment(data = SignalData_paired, aes(x=SWS, 
                                                     xend=REM, 
                                                     y=Days.Elapsed, 
                                                     yend=Days.Elapsed,colour=Location))+
  facet_wrap(~Seal.ID, nrow=1, ncol = length(SealIDs)) +
  geom_rect(data=WaterData, aes(xmin=0,xmax=100,ymin=EnterSec_Elapsed/(24*3600),ymax=ExitSec_Elapsed/(24*3600)), fill='#6CAFE2', alpha=0.3)+
  #geom_point(data = Captive_SignalData_paired, aes(x=SWS, y=Days.Elapsed), color = "#6CAFE2", size=1, alpha = 1)+
  #geom_point(data = Captive_SignalData_paired, aes(x=REM, y=Days.Elapsed),color = "#FFC000", size=1, alpha = 1) +
  theme_classic() +
  scale_x_log10()+
  scale_y_reverse()+
  xlab("Delta Spectral Power")+
  ylab("Days Since Attachment")
sleep_cycle_lines
ggsave(here("Figures",paste("06_SignalQuality_Lines.pdf",sep="")),sleep_cycle_lines, width= 15,height = 10,units="in",dpi=300)