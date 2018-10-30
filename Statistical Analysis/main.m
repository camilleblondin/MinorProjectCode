% main
clc;
clear all;
close all;

addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data analysis/results');
%%
[BeforeEventMat,AftereventMAT] = getdataset('s02s3r1_OutPutStruct.mat',0.065,0.8);

%%
load('s02s3r1_rawData.mat');
load('TRainedModelKnn.mat'); % Foot to hand transition motor imagery
%%
samplingfreq = 512; 
desiredwindowduration = 0.5; %seconds
delay = 1/samplingfreq;
delay2 = 1/16;
window = desiredwindowduration/delay;
overlap = (desiredwindowduration - delay2) * samplingfreq;
freq_of_interest = [4:1:40];
nb_of_channels = 16;
PSDsignal = [];

S = applyCAR(rawdata.signal(:,1:16));

for i =1: nb_of_channels
    [~,~,psdtime,psdsignal] = spectrogram(S(:,i),window,overlap,freq_of_interest,samplingfreq);
    PSDsignal = [PSDsignal;psdsignal];
end
%%
DATA = BeforeEventMat(2:end,:);
yfit = TrainedModelKnn.predictFcn(PSDsignal) 

% %% ttest
% addpath('/Users/camilleblondin/Desktop/MinorProject/CodeSpectrogramDisplayer/statistics');
% BeforeEventClassLabel = BeforeEventMat(1,:);
% group1 = BeforeEventMat(2:end,find(BeforeEventClassLabel==0));
% group2 = BeforeEventMat(2:end,find(BeforeEventClassLabel==1));
% testType = 'ttest';
% label1 = 'Classe 0';
% label2 = 'Classe 1';
% verbose = true;
% S_ind= [];
% 
% for j = 1:size(group2,2)
%     for i = 1:size(group1,2)
%         [meanDiff, pvalue, rejectedHypothesis] = testSignificance(group1(:,i), group2(:,j), testType, label1, label2, verbose);
% 
%         if rejectedHypothesis == 1
% 
%             S_ind = [S_ind,[i ;j]];
% 
%         end
% 
%     end
% end