% main
clc;
clear all;
close all;

addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data analysis/results');
%%
filename = load('s02s2r1_OutPutStruct.mat');
[BeforeEventMat,AfterEventMat] = getdataset(filename,0.2,0.8);
[EventMatLRL] = getdatasetLRL(filename,0.2,0.8);

%%
load('TRainedModelKnn.mat'); % Foot to hand transition motor imagery

[trainedClassifier, validationAccuracy] = trainClassifierKnn(BeforeEventMat(:,1:800));
%%

testingData = BeforeEventMat(2:end,800:end);
yfit = trainedClassifier.predictFcn(testingData);


confusionmat_res = confusionmat(BeforeEventMat(1,800:end),yfit);

%%
