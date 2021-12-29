# Title: Transferring Excel Metadata to code-friendly Date Times & Values ------
# Author: Jessica Kendall-Bar
# Date: 6/26/2021

# Setup ----
library(ggplot2)
library(lubridate)
library(here)
library(tidyverse)

# Load seal metadata ----
## Load all metadata, make valid names
metadata <- read_csv("Data/00_Sleep_Study_Metadata.csv", 
                       na = c("NA", "n/a", ""),
                       skip = 3) %>% #skipping other names
  t()
colnames(metadata) <- make.names(metadata[1, ], unique = TRUE)
metadata <- metadata[-1, ]
metadata <- as.data.frame(metadata)
metadata <- metadata %>% rownames_to_column("Nickname")

# For more efficient storage in long format
metadata <- metadata %>% pivot_longer(cols = 2:length(metadata), names_to = "description", names_repair = "unique" )
colnames(metadata) <- c("TestID", "description", "value")
metadata <- metadata[, c(2,3,1)]
metadata <- na.omit(metadata) # remove any rows with NAs
metadata$TestID <- as.factor(metadata$TestID)

# Get date times into compatible format for R
metadata$R.Time <- mdy_hms(metadata$value)
metadata$R.Time <- as.POSIXct(metadata$R.Time, format = "%Y-%m-%d %H:%M:%OS")
metadata$Matlab.Time <- as.POSIXct(metadata$R.Time, origin = '0000-01-01')

# Save all processed long-format metadata
write.csv(metadata,here("Data","01_Sleep_Study_Metadata.csv"), row.names = FALSE)

# Seal-specific Metadata ----
SealIDs <- unique(metadata$TestID)
print(SealIDs) #All animal nicknames

# Save cleaned seal-specific metadata for all seals
for (i in 1:length(SealIDs)){
  SealID <- SealIDs[i]                        # cycle through all seals
  info <- filter(metadata, TestID==SealID)    # filter metadata seal of choice  
  description <- unique(info$description)     # save description for column titles
  info <- data.frame(t(info$value))           # transpose to wide format
  colnames(info) <- description               # use description for column titles
  write.csv(info,here("Data",paste(SealID,"_00_Metadata.csv",sep="")), row.names = FALSE)
}

# Read metadata for seal of choice ----
SealID <- SealIDs[1]                        # HERE PICK the seal you want
info <- filter(metadata, TestID==SealID)    # filter metadata seal of choice  
description <- unique(info$description)     # save description for column titles
info <- data.frame(t(info$value))           # transpose to wide format
colnames(info) <- description               # use description for column titles

paste("Retrieving data for", SealID,"who was", info$Age, "and", info$Mass.animal._kg,"kilograms.")
paste("Logger was started at", info$Logger.Start)
paste("The logger was deployed at", info$Deploy.Latitude, info$Deploy.Longitude)
if (str_detect(info$Device.Failure,"Yes") == "TRUE"){
  paste("The device was blinking and not recording upon retrieval.")
} else{
  paste("The device did not fail.")
}
