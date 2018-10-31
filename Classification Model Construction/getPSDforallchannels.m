function [PSDdata] = getPSDforallchannels(rawdata,freq_of_interest)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

PSDdata = struct('data',[],'time',[]);
%% Parameters
samplingfreq = 512; 
desiredwindowduration = 0.5; %seconds
delay = 1/samplingfreq;
delay2 = 1/16;

window = desiredwindowduration/delay;
overlap = (desiredwindowduration - delay2)*samplingfreq;

nb_of_channels = 16;
%%
PSDdata.data = [];

for i =1: nb_of_channels
    [~,~,psdtime,psdsignal] = spectrogram(rawdata(:,i),window,overlap,freq_of_interest,samplingfreq);
    PSDdata.data(:,:,i) = psdsignal;
end
PSDdata.time = psdtime;
end

