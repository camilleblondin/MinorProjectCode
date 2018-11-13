% Main
% add  path
clc;
clear all;
close all;

outputdata = []; % variable in which output information will be stored
%%
addpath('Data Loading','Data Preprocessing','Data Visualization','Feature Extraction');

%% Load and Label data 
pathnamedefinition;
DataLoading;    % Decide here which file to load
DataLabelling;  % labelling of the events with intuitive names 'left,right,start...')

%% Define parameters
rawdata.frequencies_of_interest = [4:1:40];

%%  
DataPreProcessing; % Spacial filtering is applied / a graph is displayed (maybe to remove)
DataPSDextraction; % Power Spectral density is extracted in all the channels and stored in the structure (not sure yet if useful or bette to recompute each time)
% DataNormalization;

%% Data Visualization
EventsPlot; % shows the timing of the events for both original signal and psd signal
%%
FrequencyTimePlot_trials;
savefig(figtrial,[newname '_trial']);
%%
%FrequencyTimePlot_LRL; % Gives you the plot and the psd signal in LRL as an output
LRLmatGeneration

%%
FrequencyTimePlotLRL

%%
savefig(figLRL,[newname '_LRL']);

%% Saving DATA
save([newname '_OutPutStruct.mat'],'outputdata');
save([newname '_rawData.mat'],'rawdata');

%close all;
