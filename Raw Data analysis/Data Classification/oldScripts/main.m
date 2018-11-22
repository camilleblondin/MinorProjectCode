% Data  Classification

clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');

%% Parameters 
WindowDuration = 0.0625;
WindowOfInterest = 0.8;

% Load Data
dataset = load('s02s3r1_OutPutStruct.mat');

%% Get Feature Set

[BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);
nbOfEvents = 14*4;
nbofsamplesbyEvent = size(BeforeEventMatLRL,2)/nbOfEvents;
testfraction = nbofsamplesbyEvent*floor(nbofsamplesbyEvent*20/100) ;

%% Separate testing and training Data / here I keep a testing Fold for a validation 
obs = BeforeEventMatLRL(2:end,:);
grp = BeforeEventMatLRL(1, :);

holdoutCVP = cvpartition(grp,'holdout',testfraction);

dataTrain = obs(:,holdoutCVP.training);
grpTrain = grp(holdoutCVP.training);
trainingdataSet = [grpTrain ; dataTrain]';
trainingdata = [grpTrain ; dataTrain];

[trainedClassifier, validationAccuracy] = myKnnClassifier(trainingdata);

% Test performance without feature selection
dataTest = obs(:,holdoutCVP.test);
grpTest = grp(holdoutCVP.test);

yhat = trainedClassifier.predictFcn(dataTest);
[ClassificationErrorTest] = getclassificationerror(grpTest,yhat);
[ClassErrorTest] = getclasserror(grpTest,yhat);


%% Feature selection

% fun = @(xT,yT,xt,yt) ...
% ( [trainedClassifier, validationAccuracy] = trainedClassifier_BFE([yT' ; xT']);
% getclasserror(yt',trainedClassifier.predictFcn(xt')));
%% use forward festure selection with sequentialfs to look for the best feature combination

opts = statset('display','iter');
%[fs, inmodel] = sequentialfs(@my_fun, dataTrain',grpTrain') 
% maybe try here with dataTrain and grpTrain so that we keep some unseen
% data ? => 'cv',cv with a partition for the sequentialfs / The default value is 10, that is, 10-fold cross-validation without stratification.
[fs, inmodexl] = sequentialfs(@my_fun, dataTrain',grpTrain', 'options',opts) ;
index_best_features = find(mean(inmodexl.In));
optimalError = inmodexl.Crit(end);


%% Train and test the new classifier with less features

trainingResponse = dataTrain(index_best_features,:)';
trainingPredictors = grpTrain';

xt = dataTest(index_best_features,:)';
yt = grpTest';

classerror = my_fun(trainingResponse,trainingPredictors,xt,yt);

