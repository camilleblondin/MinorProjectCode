function [criterion] = myfun_chosen_classifiers(xT,yT,xt,yt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%predictors = inputTable(:, predictorNames);
trainingData = [yT , xT];

[trainedClassifier, validationAccuracy] = callmyclassifier('Fine knn',trainingData);
criterion = getclasserror(yt,trainedClassifier.predictFcn(xt));


end