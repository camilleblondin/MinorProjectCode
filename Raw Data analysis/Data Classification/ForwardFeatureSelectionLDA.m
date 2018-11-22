
%% Script to obtain statistical results for the 5 classifiers : {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' }
clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis');
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');

%% 1.  First separate the data into a Training and a validation sets
% => select 11/56 events to become the validation set that won't be touch until the
% end.
dataset = load('s02s3r1_OutPutStruct');

signalLRL = dataset.outputdata.psd.LRL.signal;

partition = cvpartition(size(signalLRL, 3), 'KFold', 5);
validationdataset = signalLRL(:,:,partition.test(1),:);
traindataset = signalLRL(:,:,partition.training(1) ,:);

%% 3. From the training set create a K-fold partition (let's start with 5) cp = cvpartition(N,?kfold?,10)

WindowDuration = 0.0625;
WindowOfInterest = 0.8;
events_info = dataset.outputdata.psd.LRL.event;
nbOfchannels = 16;
%kFoldpartition.test(fold_i)
%kFoldpartition.training(fold_i)

classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM','DiagQuadratic' };

%% 4. Then use k 1 subsets to train a classifier and the remaining subset to test it, say the first subset. Then you iterate and select the second subset for testing and use subsets {1, 3, 4, . . .} for training, etc..

[trainingObs,trainingClassLabel] = getObsandLabels(traindataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);
[testObs,testClassLabel] = getObsandLabels(validationdataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);
%%
k = 5;
kFoldpartition = cvpartition(trainingClassLabel, 'KFold', k);
opt = statset('Display','iter','MaxIter',100);
%% 

fun = @(xT,yT,xt,yt) length(yt)*(getclasserror(yt,predict(fitcdiscr( xT, yT,'DiscrimType', 'linear', 'Gamma', 0, 'FillCoeffs', 'off','ClassNames', [0; 1]), xt)));

[sel,inmodelxl] = sequentialfs(fun,trainingObs,trainingClassLabel,'cv',kFoldpartition,'options',opt);
%%
index_best_features = find(mean(inmodelxl.In))
optimalError = inmodelxl.Crit(end)

% train on whole the training set with best features
[trainedClassifier] =  callmyclassifier2('LDA',trainingObs(:,index_best_features),trainingClassLabel);
% test => predict on the validationdataset with best features
[testClassLabelsPrediction, X0E, MPRED] = predict(trainedClassifier, testObs(:,index_best_features));
[trainingClassLabelsPrediction, X0E, MPRED] = predict(trainedClassifier, trainingObs(:,index_best_features));

% Compute the error and show the results
trainClassError = getclasserror(trainingClassLabel,trainingClassLabelsPrediction);
testClassError = getclasserror(testClassLabel,testClassLabelsPrediction);

% Plots
plotError(testClassError,0,trainClassError ,0,'Class Error - Forward Feature Selection','LDA')

