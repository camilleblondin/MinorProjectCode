function [criterion] = my_fun(xT,yT,xt,yt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%predictors = inputTable(:, predictorNames);
trainingResponse = yT;
trainingPredictors = xT;
%trainingData = [trainingResponse ; trainingPredictors];


% [trainedClassifier, validationAccuracy] = myKnnClassifier(trainingData);
% criterion = getclasserror(yt',trainedClassifier.predictFcn(xt'));
Mdl = fitcknn(trainingPredictors, ...
        trainingResponse, ...
        'Distance', 'Euclidean', ...
        'Exponent', [], ...
        'NumNeighbors', 1, ...
        'DistanceWeight', 'Equal', ...
        'Standardize', true, ...
        'ClassNames', [0 ; 1]);
    
criterion = getclasserror(yt,predict(Mdl,xt));

end

