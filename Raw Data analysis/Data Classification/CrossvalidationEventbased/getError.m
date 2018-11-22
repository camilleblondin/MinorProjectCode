function [test_classerror_fold,train_classerror_fold] = getError(trainingdata,testdata,classifiername,events_info)

WindowDuration = 0.0625;
WindowOfInterest = 0.8;
nbOfchannels = 16;

[trainingfold,trainingfold_labels] = getObsandLabels(trainingdata,events_info,nbOfchannels,WindowDuration,WindowOfInterest);
[testfold,testfold_labels] = getObsandLabels(testdata,events_info,nbOfchannels,WindowDuration,WindowOfInterest);

[trainedClassifier] =  callmyclassifier2(classifiername,trainingfold,trainingfold_labels);

% test  on test set of one fold

[testfold_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, testfold);
[train_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, trainingfold);

% compute the test error for the fold
train_classerror_fold = getclasserror(trainingfold_labels,train_labels_Prediction);
test_classerror_fold = getclasserror(testfold_labels,testfold_labels_Prediction);
classificationerror_fold = getclassificationerror(testfold_labels,testfold_labels_Prediction);

end

