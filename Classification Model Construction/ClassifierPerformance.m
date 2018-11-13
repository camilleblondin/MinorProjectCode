%% Classifier
clc;
clear all;
close all;
%% load Data & get feature set
dataset = load('s02s3r1_OutPutStruct.mat');

WindowDuration = 0.0625;
WindowOfInterest = [1];

[BeforeEventMat,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);

ttrainDataSet = BeforeEventMat(:,2:2:end);
testDataSetBF = BeforeEventMat(2:end,1:2:end);
test_labelsBF = BeforeEventMat(1,1:2:end);

[trainedClassifier, validationAccuracy] = trainedClassifier_BFE(ttrainDataSet);

yfit_test = trainedClassifier.predictFcn(testDataSetBF);

[ClassificationErrorTest] = getclassificationerror(test_labelsBF,yfit_test);
[ClassErrorTest] = getclasserror(test_labelsBF,yfit_test);