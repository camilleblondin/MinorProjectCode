%% Observing the data 

clc;
clear all;
close all;
addpath(genpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data Analysis'));


dataset = load('s02s3r1_OutPutStruct');
meanoverLRL = dataset.outputdata.psd.LRL.mean  ;
size(meanoverLRL )
channel9 = meanoverLRL(:,:,9);

figure();
for i = 1:size(channel9,1)
plot(channel9(i,:)+i*10);
hold on;
end


