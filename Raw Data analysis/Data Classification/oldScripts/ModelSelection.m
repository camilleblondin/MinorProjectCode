% Model Selection
clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');

%% Load Data Set
% Parameters 
WindowDuration = 0.0625;
WindowOfInterest = 0.8;

% Load Data
dataset = load('s02s3r1_OutPutStruct.mat');

% Get Feature Set
[BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);
nbOfEvents = 14*4;
nbofsamplesbyEvent = size(BeforeEventMatLRL,2)/nbOfEvents;
testfraction = nbofsamplesbyEvent*floor(nbofsamplesbyEvent*20/100) ;

%% Separate train and test sets

obs = BeforeEventMatLRL(2:end,:);
grp = BeforeEventMatLRL(1, :);

holdoutCVP = cvpartition(grp,'holdout',testfraction);

dataTrain = obs(:,holdoutCVP.training)';
grpTrain = grp(holdoutCVP.training)';
trainingdataSet = [grpTrain , dataTrain];

% Test Data - for class error validation
dataTest = obs(:,holdoutCVP.test)';
grpTest = grp(holdoutCVP.test)';

classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' };

ClassificationErrorTest = zeros(length(classifiers),1);
ClassErrorTest = zeros(length(classifiers),1);
ClassificationErrorTrain = zeros(length(classifiers),1);
ClassErrorTrain= zeros(length(classifiers),1);
%%%%%
% Train all the classifiers and compute both class and classification error
% when the classifier is confronted to unseen data (test set)
for cl = 1:length(classifiers)
    
[trainedClassifier, validationAccuracy] =  callmyclassifier(char(classifiers(cl)),trainingdataSet);

yhattrain = trainedClassifier.predictFcn(dataTrain);
ClassificationErrorTrain(cl) = getclassificationerror(grpTrain,yhattrain);
ClassErrorTrain(cl) = getclasserror(grpTrain,yhattrain);

yhatest = trainedClassifier.predictFcn(dataTest);
ClassificationErrorTest(cl) = getclassificationerror(grpTest,yhatest);
ClassErrorTest(cl) = getclasserror(grpTest,yhatest);

end
%%%%
%%
% Create figure
figure1 = figure;
axes1 = axes('Parent',figure1,'Position',[0.13 0.11 0.775 0.815]);
hold(axes1,'on');
bar(ClassErrorTest);
hold on; 
bar(ClassificationErrorTest);
ylabel('Error');
xlabel('Classifier type');
title('Class Error & Classification Error for each Classifier');
box(axes1,'on');
set(axes1,'FontName','Hiragino Kaku Gothic Std','FontSize',9,'XColor',...
    [0 0 0],'XTick',[1 2 3 4 5],'YColor',[0 0 0],'YGrid','on','ZColor',[0 0 0]);
set(gca,'xticklabel',classifiers);
legend('Class Error','Classification Error');
% plot histogram showing for each classifier the class error,
% classification error and test error

%% Hyperparameter optimization - Cross Validation
% Forward Feature Selection
% This paaaarts takes so long in computation, I'm doing few time per
% classifier to get results but I won't implement it in a for loop. 

%% CHOOSE function
opts = statset('display','iter');
[fs, inmodexl] = sequentialfs(@my_funFineKnn, dataTrain,grpTrain,'options',opts) ;
index_best_features = find(mean(inmodexl.In));
optimalError = inmodexl.Crit(end);

%Train and test the new classifier with less features
%%
xT = dataTrain(:,index_best_features);
yT = grpTrain;
trainingdataSet = [yT xT];

%% CHOOSE CLASSIFIER
% this one is done with cross validation maybe it is unecessary unless to
% look at the validation
%[trainedClassifier, validationAccuracy] = callmyclassifier(char(classifiers(2)),trainingdataSet);
%%
xt = dataTest(:,index_best_features);
yt = grpTest;
%classerror = getclasserror(yt',trainedClassifier.predictFcn(xt)')
classerror = my_funFineKnn(xT,yT,xt,yt)

% %% Test on a new run
% %index_best_features = [1:592]
% % Load Data
% datasetr2 = load('s02s2r2_OutPutStruct.mat');
% % Get Feature Set
% [BeforeEventMatLRLr2,AfterEventMat] = getdataset(datasetr2,WindowDuration,WindowOfInterest);
% 
% obsr2 = BeforeEventMatLRLr2(2:end,:)';
% grpr2 = BeforeEventMatLRLr2(1, :)';
% 
% % Train with run 1
% obstrain = BeforeEventMatLRL(2:end,:)';
% grptrain = BeforeEventMatLRL(1, :)';
% xT = obstrain(:,index_best_features);
% yT = grptrain;
% 
% classificationKNN = fitcknn(...
%     xT, ...
%     yT, ...
%     'Distance', 'Euclidean', ...
%     'Exponent', [], ...
%     'NumNeighbors', 10, ...
%     'DistanceWeight', 'SquaredInverse', ...
%     'Standardize', true, ...
%     'ClassNames', [0; 1]);
% 
% % Look at the errors on run 2
%     
% classerrorNewdata = getclasserror(grpr2,predict(classificationKNN ,obsr2(:,index_best_features)))
% classificationerrorNewdata = getclassificationerror(grpr2,predict(classificationKNN ,obsr2(:,index_best_features)))


%% Subject 2 session 3 
% Results for fine knn 
% Best features = [2 4 6 7 8 10 12 14 17 19 20 21 23 25 27 28 30 31 32 34 35 37 ]
% classerror =   0.1042
% Validation accuracy = 0.9388
% OPTIMAL ERROR = 3.2683e-04

% Results for Weighted knn 
% Best features = [1 ]
% classerror =    0.4863
% OPTIMAL ERROR = 0.0018
%% Subject 3 session 3 run 1
% Results for fine knn 
% Best features = [1 3 5 6 7 9 11 12 13 15 16 18 19 20 22 23 24 25 26 27 28 29 30 31 33 34 36 37 40 42 46 67 ]
% classerror =   0.0841
% OPTIMAL ERROR = 3.1602e-04
%% here is how to use the classifier but without crossvalidation just train and test sets
% 
% classificationKNN = fitcknn(...
%     trainingPredictors, ...
%     trainingResponse, ...
%     'Distance', 'Euclidean', ...
%     'Exponent', [], ...
%     'NumNeighbors', 1, ...
%     'DistanceWeight', 'Equal', ...
%     'Standardize', true, ...
%     'ClassNames', [0; 1]);
% 
% [YP, X0E, MPRED]  = predict(classificationKNN,xt);
% error =  getclasserror(yt,YP);
%%


