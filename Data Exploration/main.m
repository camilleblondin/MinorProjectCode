% Here is where I will look at the data to observe the signal
% this hopefully will help me to identify the Foot/Hand and Hand/Foot
% Motor Imagery transition and to labelize the data
clc;
clear all;
close all;
%%
% First we load a rawdata (we will use here an already pre-loaded data
% from the result folder in EEGDataAnalysis/RawDataAnalysis because it is
% more convenient here.

addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data analysis/results');
load('s02s3r1_rawData.mat');

%% 1. Observing the raw signal for all channels
channel_nb = 16;
fs = 512;

figure()
lag = 200;
for channel = 1:channel_nb
    signal_channel = rawdata.signal(:,channel)+ lag * channel;
    plot(rawdata.time,signal_channel);
    hold on;
end
title('Raw signal');
%% 2. Band pass filtering the signal
d1 = designfilt('bandpassfir','FilterOrder',20, ...
    'CutoffFrequency1',8,'CutoffFrequency2',11, ...
    'SampleRate',fs);
d2 = designfilt('bandpassfir','FilterOrder',20, ...
    'CutoffFrequency1',26,'CutoffFrequency2',30, ...
    'SampleRate',fs);
figure()
lag = 200;
FilteredSignal = zeros(size(rawdata.signal(:,1:channel_nb)));
for channel = 1:channel_nb
    FilteredSignal(:,channel) = filtfilt(d1, rawdata.signal(:,channel))+ lag * channel ;
    hold on;
    plot(rawdata.time,FilteredSignal(:,channel));
    hold on;
end
title('Filtered signal');
%% Relative Power
window = 0.5*512;
noverlap = (0.5-1/16) * 512;
interval = [find(rawdata.time==90):1:find(rawdata.time>=120)];
ff = [4:1:12];
PXX = [];
for i = 1:length(interval)-window
    
    [pxx ,f] = pwelch(FilteredSignal(i:i+window,9),window,noverlap,ff,512);
    PXX = [PXX, pxx];
end

figure()
plot(PXX);
title('Psd signal');
