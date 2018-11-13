%% Classifier
clc;
clear all;
close all;
%% load Data & get feature set
dataset = load('s02s3r1_OutPutStruct.mat');
load('trainedModel_BFE.mat');
WindowDuration = 0.0625;

WindowOfInterest = [0.6 0.8 1 1.2];
ClassError = zeros(length(WindowOfInterest ),1);

for w_i = 1:length(WindowOfInterest)
    
    [EventMatLRL] = getdatasetLRL(dataset,WindowDuration,WindowOfInterest(w_i));
    [BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest(w_i));
    %%
    % Define train and test data
    Ltrain = size(BeforeEventMatLRL,2)/4 *3;
    
    ttrainDataSet = BeforeEventMatLRL(:,1:Ltrain);
    train_labels = BeforeEventMatLRL(1,1:Ltrain);
    
    test_labels = BeforeEventMatLRL(1,Ltrain:end);
    testDataSet  = BeforeEventMatLRL(2:end,Ltrain:end);
    %% Train the model
    %[trainedClassifier, validationAccuracy] = trainedModel_BFE(ttrainDataSet);
    % Test on the same data
    yfit_train = trainedModel_BFE.predictFcn(ttrainDataSet(2:end,:));
    
    %% Test the model
    yfit_test = trainedModel_BFE.predictFcn(testDataSet);
    
    %% Test Classifier Accuracy
    [ClassificationErrorTrain] = getclassificationerror(train_labels,yfit_train);
    [ClassErrorTrain] = getclasserror(train_labels,yfit_train);
    
    [ClassificationErrorTest] = getclassificationerror(test_labels,yfit_test);
    [ClassErrorTest] = getclasserror(test_labels,yfit_test);
    ClassError(w_i) = ClassErrorTest ;
end
figure();
plot(WindowOfInterest,ClassError);

%% Feature Selection
% PCA  
% Fisher Score
%% Cross Validation
% Test different classifiers LDA/QDA/KNN..


