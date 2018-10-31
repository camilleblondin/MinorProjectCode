% Labelling of the data for pseudo online testing
clc;
clear all;
close all;

load('s02s3r1_rawData.mat');
load('TRainedModelKnn.mat');
%%
% parameters for spectrogram
samplingfreq = 512;
desiredwindowduration = 0.5; %seconds
delay = 1/samplingfreq;
delay2 = 1/16;
window = desiredwindowduration/delay;
overlap = (desiredwindowduration - delay2) * samplingfreq;
freq_of_interest = [4:1:40];
nb_of_channels = 16;
PSDsignal = [];

S = applyCAR(rawdata.signal(:,1:16)); % Not Sure

for i =1: nb_of_channels
    [~,~,psdtime,psdsignal] = spectrogram(S(:,i),window,overlap,freq_of_interest,samplingfreq);
    PSDsignal = [PSDsignal;psdsignal];
end
%%
% Now we labbel the data => lets focus on the right events as a start and
% label as class 1 the data on a windows around
window_of_interest = floor(0.8 * 16);

event_position = rawdata.psd.events.position;
event_labels = rawdata.psd.events.labels;
RightStart_index = event_position(find(event_labels == 'right')+1);

classlabel = zeros(1,size(PSDsignal,2));

for i = 1:length(RightStart_index)

TransitionLR_start = RightStart_index(i) - window_of_interest/2;
TransitionLR_end = RightStart_index(i) + window_of_interest/2;
classlabel(TransitionLR_start:TransitionLR_end) = 1;

end

%%
[trainedClassifier, validationAccuracy] = trainClassifierKnn(EventMatLRL);

xfit = TrainedModelKnn.predictFcn(EventMatLRL(2:end,:));

confusionmat(EventMatLRL(1,:),xfit)

