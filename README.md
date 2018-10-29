# MinorProjectCode

Data Analysis by Session --> main :

Processed Data --> where I store output data and figures for each subject

Raw Data Analysis
--> Data Loading/DataLoading:
here you define what data to load in the format pathname.s09.s3.r1
the name of the output structure is also defined here (newname)
pathname is a structure containing the pathname of all the gdf files connected to the user computer

--> Data Loading/pathnamedefinition:
creates a structure files containing all the pathname of the files to analyse
This script should be modified once per user, if the same files are used by a different user
only commonpath should be modified.

--> Data Loading/main:
the main should be launched once the pathnaname is defined (in pathnamedefinition)
and once the data to load is defined (in DataLoading).
the main gives you:
- a plot of the events in time (verification - might be removed later)
- a Frequency Time plot by trial and a plot of the mean psd values over all the frequencies for one trial
- a Frequency Time plot by LRL (left right left) events
those plots, as well as output data are saved

outputdata (newname_OutPutStruct.mat) contains:
outputdata.channel_label
outputdata.filename
outputdata.psd
outputdata.psd.LRL.time
outputdata.psd.LRL.event
outputdata.psd.LRL.event.position
outputdata.psd.LRL.event.labels
outputdata.psd.LRL.signal
outputdata.psd.LRL.mean


Data Anaylsis by Session

Statistical Analysis




