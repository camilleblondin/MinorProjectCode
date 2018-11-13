function [criterion] = my_funWeightedknn(xT,yT,xt,yt)

trainingResponse = yT;
trainingPredictors = xT;

classificationKNN = fitcknn(...
    trainingPredictors, ...
    trainingResponse, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

    
criterion = getclasserror(yt,predict(classificationKNN ,xt));

end