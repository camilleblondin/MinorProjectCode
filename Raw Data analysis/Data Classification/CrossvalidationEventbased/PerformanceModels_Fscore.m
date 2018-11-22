
%% Script to obtain statistical results for the 5 classifiers : {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' }
clc;
clear all;
close all;
addpath(genpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data Analysis'));

%% 1.  First separate the data into a Training and a validation sets
% => select 11/56 events to become the validation set that won't be touch until the
% end.
dataset = load('s02s3r1_OutPutStruct');

signalLRL = dataset.outputdata.psd.LRL.signal;

partition = cvpartition(size(signalLRL, 3), 'KFold', 5);
validationdataset = signalLRL(:,:,partition.test(1),:);
traindataset = signalLRL(:,:,partition.training(1) ,:);

%% 3. From the training set create a K-fold partition (let's start with 5) cp = cvpartition(N,?kfold?,10)

k = 5;
kFoldpartition = cvpartition(size(traindataset,3), 'KFold', k);
WindowDuration = 0.0625;
WindowOfInterest = 0.8;
events_info = dataset.outputdata.psd.LRL.event;
nbOfchannels = 16;
%kFoldpartition.test(fold_i)
%kFoldpartition.training(fold_i)

classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM','DiagQuadratic','DiagLinear' };

%% 4. Then use k 1 subsets to train a classifier and the remaining subset to test it, say the first subset. Then you iterate and select the second subset for testing and use subsets {1, 3, 4, . . .} for training, etc..
trainingclasserror = zeros(k,length(classifiers));
testclasserror = zeros(k,length(classifiers));
classificationerror_fold = zeros(k,length(classifiers));
C = zeros(2,2,length(classifiers));
for fold_i = 1:k
    
    [trainingObs,trainingClassLabel] = getObsandLabels(traindataset(:,:,kFoldpartition.training(fold_i),:),events_info,nbOfchannels,WindowDuration,WindowOfInterest);
    [testfold,testfold_labels] = getObsandLabels(traindataset(:,:,kFoldpartition.test(fold_i),:),events_info,nbOfchannels,WindowDuration,WindowOfInterest);
    
    [orderedInd, orderedPower] = rankfeat(trainingObs,trainingClassLabel,'fisher');
    bestfeatures = orderedInd(1:15)
    trainingObs = trainingObs(:,bestfeatures );
    testfold = testfold(:,bestfeatures );
    for classifier_i = 1:length(classifiers);
        
        [trainedClassifier] =  callmyclassifier2(char(classifiers(classifier_i)),trainingObs,trainingClassLabel);
        
        % test  on test set of one fold
        
        [testfold_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, testfold);
        [train_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, trainingObs);
        
        C(:,:,classifier_i) = C(:,:,classifier_i) + confusionmat(testfold_labels,testfold_labels_Prediction);

        % compute the test error for the fold
        trainingclasserror(fold_i,classifier_i) = getclasserror(trainingClassLabel,train_labels_Prediction);
        
        testclasserror(fold_i,classifier_i) = getclasserror(testfold_labels,testfold_labels_Prediction);
        classificationerror_fold(fold_i,classifier_i) = getclassificationerror(testfold_labels,testfold_labels_Prediction);
        
    end
    
end
% compute the crossvalidation error => the mean error over all the folds
CVclassError = mean(testclasserror)
CVclassError_std = std(testclasserror)
C = C./k;
%CVclassificationError = mean(classificationerror_fold)
%CVclassificationError_std = std(classificationerror_fold)

CVclassErrortrain = mean( trainingclasserror)
CVclassError_stdtrain = std(trainingclasserror)
%% Now compute the error on an unseen data set (the validation set we kept at the begining)

Validationclasserror = zeros(length(classifiers),1);
Validationclassificationerror = zeros(length(classifiers),1);
trainingclasserror = zeros(length(classifiers),1);


[trainingObs,trainingClassLabel] = getObsandLabels(traindataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);
[validationObs,validationClassLabel] = getObsandLabels(validationdataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);

[orderedInd, orderedPower] = rankfeat(trainingObs,trainingClassLabel,'fisher');
bestfeatures = orderedInd(1:15)
trainingObs = trainingObs(:,bestfeatures);
validationObs = validationObs(:,bestfeatures);
for cl = 1:length(classifiers)
   
    % First we train the model with the whole training set
    trainedClassifier = callmyclassifier2(char(classifiers(cl)),trainingObs,trainingClassLabel)
    % Then we compute the validation class and classification error
    [training_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,trainingObs(:,:));
    trainingclasserror(cl) = getclasserror(trainingClassLabel,training_labels_Prediction);
    %%
    [Validation_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,validationObs(:,:));
    Validationclasserror(cl) = getclasserror(validationClassLabel,Validation_labels_Prediction);
    Validationclassificationerror(cl) = getclassificationerror(validationClassLabel,Validation_labels_Prediction);
end

%% Plot results

plotError(CVclassError,CVclassError_std,CVclassErrortrain,CVclassError_stdtrain,'CV Class Error',classifiers)

%%
plotError(Validationclasserror,zeros(7,1),trainingclasserror,zeros(7,1),'Test Error',classifiers)
