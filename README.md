# Eavesdropping-on-the-Brain-at-Sea

## This Github repository contains data, protocols, and analyses to support the associated manuscript &quot;Eavesdropping on the brain at sea: Development of a surface-mounted system to detect weak electrophysiological signals from wild animals&quot;.

Here is a table of contents to find what you are looking for:

1. /data : folder with raw, processed, and summarized data
2. /scripts : folder with .R scripts and JMP reports
  1. **01\_Metadata.R**
 Run this first to get metadata for all seals.
  2. **06\_SignalQuality\_Analysis.R**
Run this to get paired and binned summary stats for signal quality data.
  3. **06\_SignalQuality\_Excerpts\_Plot.R**
Run this to get plots out of raw data excerpts provided in data folder.
3. /figures : folder with figures generated from R and/or edited Illustrator

Column description of important data files:

1. _00\_Sleep\_Study\_Metadata.csv_

 Metadata for all seals. All Excel Date Times are provided in the following format: &quot;mm/dd/yyyy hh:mm:ss&quot;. Row descriptions:
  1. **Test #** : recording # (includes test recordings between deployments)
  2. **Animal** : portable logger deployment number (incorporated into Nickname)
  3. **Name** : long name
  4. **Nickname** : unique animal code
  5. **Recording ID** : recording type including location (WILD vs. CAPTIVE), age estimate (i.e. 2mo = 2 months old), and age class (weanling, yearling, juvenile)
  6. **Methods\_Paper\_SEALID** : recording number (to match to Table 1 in MS)
  7. **Sex** : visually determined sex (M/F)
  8. **Age** : estimated age interval in years
  9. **Age estimate** : verbal description of age estimate
  10. **Version** : tag iteration used (V1/V2/V3)
  11. **Deployment** : deployment number
  12. **Seal ID** : Resight Seal ID for Ano Nuevo Research database: [https://www.anonuevoresearch.com/](https://www.anonuevoresearch.com/)
  13. **Pressed Start Logger:** Excel Date Time for pressing start
  14. **Logger Start:** Excel Date Time for actual logger start
  15. **Start from Real Time Clock:** Excel Date Time for time derived by real time clock utility (implemented in 2021).
  16. **Start for EDF Files:** start time used for EDF files.
  17. **ON ANIMAL:** time heart beats first detected in ECG channel (coincides with instrument attachment)
  18. **OFF ANIMAL:** time heart beats last detected in ECG channel (coincides with instrument detachment)
  19. **Duration\_ON\_ANIMAL\_h:** hours logger was attached until either was removed or device stopped recording.
  20. **Logger Stop:** time logger turned off (if applicable).
  21. **Device Failure:** indicates whether logger was in ON or OFF state when recovered.
  22. **Standard Length:** straight length of animal in centimeters (nose to tail)
  23. **Curved Length:** curved length of animal in centimeters (nose to tail along body)
  24. **Ax Girth:** circumference of animal behind pectoral flippers
  25. **Mass animal\_kg:** mass of animal in kilograms
  26. **Flipper tag 1:** ID listed on flipper tag 1 (including G to denote green color)
  27. **Position:** flipper tag position 1
  28. **Flipper tag 2:** ID listed on flipper tag 2 (including G to denote green color)
  29. **Position:** flipper tag position 2
  30. **Birth date:** verbal description of birth date estimate
  31. **Animal ID:** unique animal ID for elephant seal database: [https://www.anonuevoresearch.com/](https://www.anonuevoresearch.com/)
  32. **Deploy ID:** unique deployment ID for TOPP Bird &amp; Mammal Database: [http://lml-research-app-1.ucsc.edu/web/entryform/](http://lml-research-app-1.ucsc.edu/web/entryform/)
  33. **TOPP ID:** unique animal ID for TOPP Bird &amp; Mammal Database: [http://lml-research-app-1.ucsc.edu/web/entryform/](http://lml-research-app-1.ucsc.edu/web/entryform/)
  34. **Deploy Latitiude:** latitude where instrument was attached to animal
  35. **Deploy Longitude:** longitude where instrument was attached to animal
  36. **Hematocrit:** blood hematocrit level (if known)
  37. **Ultrasound skull depth\_cm:** skull depth estimated from ultrasound images
  38. **Recording Duration\_s:** time logger was recording in seconds
  39. **Recording Duration\_days:** time logger was recording in days
  40. **Begin Calm in Water for ICA:** Excel Date Time for start of ICA training dataset
  41. **End Calm in Water for ICA:** Excel Date Time for end of ICA training dataset
  42. **Duration for ICA:** length of ICA training dataset hh:mm:ss
  43. **Best EOG EMG EEG:** channels that provided best EOG, EMG, L EEG, and R EEG signals
  44. **ICA Decomposition Quality:** subjective assessment of ICA decomposition
  45. **ICA Component Maximal Brain:** IC# that expressed maximal brain activity
  46. **ICA Component Maximal Brain:** IC# that expressed maximal brain activity
  47. **Pruned with ICA Components:** ICs that were removed from EOG, EMG, and EEG signals for visual and quantitative analysis

2. _05\_Signal\_Quality\_Data.csv_

 Signal quality data for each observation (a 30-sec time period around each comment- See Cmt Text). Column descriptions:
  1. **Seconds.On.Animal:** Seconds since instrument attachment
  2. **Date Time:** Excel Date Time for each observation
  3. **Seal.ID:** Nickname from S5\_00\_Sleep\_Study\_Metadata.xlsx
  4. **Version:** Version from S5\_00\_Sleep\_Study\_Metadata.xlsx
  5. **AGE** : age from S5\_00\_Sleep\_Study\_Metadata.xlsx
  6. **Wild v. Captive:** WILD or CAPTIVE
  7. **Phase:** Mode of categorical location denoting current location (LAND vs. WATER) and then the phase number (i.e. LAND02 denotes second time on land).
  8. **Date** : Excel date of recording
  9. **Sel Start:** Start time of observation hh:mm:ss
  10. **Sel End:** End time of observation hh:mm:ss
  11. **Sel Duration:** selection duration (all 30s)
  12. **Pressure\_mean :** mean pressure for selection
  13. **Pressure\_SD :** standard deviation of pressure for selection
  14. **REEG2\_Raw\_Ch7\_Mean**
  15. **LEEG3\_Raw\_Ch8\_Mean**
  16. **EEG\_ICA5\_Mean**
  17. **pitch\_Mean**
  18. **roll\_Mean**
  19. **EEG\_ICA\_DELTA**
  20. **EEG\_Pruned\_DELTA**
  21. **EEG\_Raw1\_DELTA**
  22. **EEG\_Raw1\_DELTA\_SD**
  23. **EEG\_Raw2\_DELTA**
  24. **EEG\_Raw2\_DELTA\_SD**
  25. **EEG\_ICA\_DELTA2**
  26. **EEG\_ICA\_DELTA\_SD**
  27. **BEST\_EEG\_DELTA**
  28. **BEST\_EEG**
  29. **Cmt Text** : Comment placed during scoring (includes: Instrument ON Animal, SWS1, REM, SWS2, Heart Patterns Scorable, Sleep State Scorable, Eye Movement, Muscle Twitch, LS (light sleep), Animal Enters Water, Animal Exits Water)

3. _05\_SignalData\_binned.csv_

 Signal quality data summarized per day per animal. Column descriptions:
  1. **Observation #**
  2. **Day:** Day since instrument attachment
  3. **Seal.ID:** Nickname from S5\_00\_Sleep\_Study\_Metadata.xlsx
  4. **Mean:** Mean SWS δ/REM δper day
  5. **sd:** Standard deviation SWS δ/REM δper day
  6. **Max:** Maximum SWS δ/REM δper day (for a single sleep cycle)
  7. **Min:** Minimum SWS δ/REM δper day (for a single sleep cycle)
  8. **Mean\_SWS:** Mean SWS δper day
  9. **sd\_SWS:** Standard deviation SWS δper day
  10. **Mean\_REM:** Mean REM δper day
  11. **sd\_REM:** Standard deviation REM δper day
  12. **Version:** Version from S5\_00\_Sleep\_Study\_Metadata.xlsx
  13. **Phase:** Mode of categorical location denoting current location (LAND vs. WATER) and then the phase number (i.e. LAND02 denotes second time on land).
  14. **Percent.Obs.Water:** # of sleep cycles in water for that day / total sleep cycles that day
  15. **Deployment:** deployment number from S5\_00\_Sleep\_Study\_Metadata.xlsx
  16. **Seal.Number** : Methods\_Paper\_SEALIDfrom S5\_00\_Sleep\_Study\_Metadata.xlsx.
  17. **AGE** : age from S5\_00\_Sleep\_Study\_Metadata.xlsx

4. _05\_SignalData\_paired.csv_

 Signal quality data summarized per sleep cycle. Column descriptions:
  1. **Observation #**
  2. **PairLabel:** Sleep cycle number (for paired SWS and REM observations)
  3. **Day:** Day since instrument attachment
  4. **MinSec:** Seconds on animal before first observation (SWS)
  5. **MeanSec:** Mean seconds on animal between SWS and REM observations
  6. **Standardized:** SWS δ/REM δfor each observation (paired SWS/REM sleep cycle)
  7. **Seal.ID:** Nickname from S5\_00\_Sleep\_Study\_Metadata.xlsx
  8. **Location:** animal location (LAND v WATER)
  9. **Version:** Version from S5\_00\_Sleep\_Study\_Metadata.xlsx
  10. **Phase:** Mode of categorical location denoting current location (LAND vs. WATER) and then the phase number (i.e. LAND02 denotes second time on land).
  11. **AGE** : age from S5\_00\_Sleep\_Study\_Metadata.xlsx
  12. **Deployment:** deployment number from S5\_00\_Sleep\_Study\_Metadata.xlsx
  13. **Seal.Number** : Methods\_Paper\_SEALIDfrom S5\_00\_Sleep\_Study\_Metadata.xlsx.
  14. **SWS:** SWS δfor best EEG channel
  15. **REM:** REMδfor best EEG channel
  16. **Days.Elapsed:** Mean days on animal between SWS and REM observations

5. _06\_Signal\_Quality\_Excerpts\_Across\_Locations.csv_

 1-min excerpts of raw signals in different settings. Data can be plotted using R script 06\_SignalQuality\_Excerpts\_Plot.R in code repository. Column descriptions:
  1. **SecElapsed** : seconds since logger start
  2. **Date** : Excel date of recording
  3. **ECG:** raw timeseries data for ECG
  4. **LEOG:** raw timeseries data for left EOG
  5. **REOG:** raw timeseries data for right EOG
  6. **LEMG:** raw timeseries data for left EMG
  7. **REMG:** raw timeseries data for right EMG
  8. **LEEG1:** raw timeseries data for left EEG (frontal region)
  9. **REEG2:** raw timeseries data for right EEG (frontal region)
  10. **LEEG3:** raw timeseries data for left EEG (parietal region)
  11. **REEG4:** raw timeseries data for right EEG (parietal region)
  12. **Acc X/Acc Y/Acc Z :** unprocessed accelerometer timeseries data
  13. **HeartRate:** output for automated peak detection
  14. **Seconds:** seconds since start of each excerpt (0 to 60)
  15. **Comment:** channel with event markers for each identified heart beat
  16. **SealID:** Nickname from S5\_00\_Sleep\_Study\_Metadata.xlsx
  17. **Wild v. Captive:** WILD or CAPTIVE
  18. **Active v SWS v REM:** denoting whether excerpt is of active behavior (galumphing on land or swimming in water), slow-wave sleep (SWS), or rapid-eye-movement (REM) sleep
  19. **Location:** LAND or SHALLOW (water)
  20. **Activity:** Galumphing (land), Swimming (water), Stationary (land or on the ocean floor), or Drifting (water).

6. _06\_Signal\_Quality\_Excerpts\_Challenges\_Solutions.csv_

 1-min excerpts of challenges and solutions to signal recording obstacles. Data can be plotted using R script 06\_SignalQuality\_Excerpts\_Plot.R in code repository. Column descriptions:
  1. **SecElapsed** : seconds since logger start
  2. **Date** : Excel date of recording
  3. **ECG:** raw timeseries data for ECG
  4. **LEOG:** raw timeseries data for left EOG
  5. **REOG:** raw timeseries data for right EOG
  6. **LEMG:** raw timeseries data for left EMG
  7. **REMG:** raw timeseries data for right EMG
  8. **LEEG1:** raw timeseries data for left EEG (frontal region)
  9. **REEG2:** raw timeseries data for right EEG (frontal region)
  10. **LEEG3:** raw timeseries data for left EEG (parietal region)
  11. **REEG4:** raw timeseries data for right EEG (parietal region)
  12. **Acc X/Acc Y/Acc Z :** unprocessed accelerometer timeseries data
  13. **HeartRate:** output for automated peak detection
  14. **Seconds:** seconds since start of each excerpt (0 to 60)
  15. **Comment:** channel with event markers for each identified heart beat
  16. **SealID:** Nickname from S5\_00\_Sleep\_Study\_Metadata.xlsx
  17. **Wild v. Captive:** WILD or CAPTIVE
  18. **Active v SWS v REM:** denoting whether excerpt is of active behavior (galumphing on land or swimming in water), slow-wave sleep (SWS), or rapid-eye-movement (REM) sleep
  19. **Location:** LAND or SHALLOW (water)
  20. **Activity:** wet (headcap had significant water intrusion), dry (headcap had no water intrusion), VHF BAD (VHF on land), VHF GOOD (VHF in water where signals were attenuated), with pings (satellite pings present), without pings (satellite pings removed), HR BAD (HR signals messier with poor wire fortification), HR GOOD (HR signals better with good wire fortification).
