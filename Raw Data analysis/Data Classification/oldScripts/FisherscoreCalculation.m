
%% Script to obtain statistical results for the 5 classifiers : {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' }
clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis');
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');

%% 1.  First separate the data into a Training and a validation sets
%=> select 11/56 events to become the validation set that won't be touch until the
% end.
dataset = load('s02s3r1_OutPutStruct');

signalLRL = dataset.outputdata.psd.LRL.signal;

partition = cvpartition(size(signalLRL, 3), 'KFold', 5);
validationdataset = signalLRL(:,:,partition.test(1),:);
traindataset = signalLRL(:,:,partition.training(1) ,:);

%% 2. Extract the Feature sets
%Training Set

WindowDuration = 0.0625;
WindowOfInterest = 0.8;

[trainingObs,trainingClassLabel] = getObsandLabels(traindataset,dataset.outputdata.psd.LRL.event,16,WindowDuration,WindowOfInterest);
[validationObs,validationClassLabel] = getObsandLabels(validationdataset,dataset.outputdata.psd.LRL.event,16,WindowDuration,WindowOfInterest);

%% 3. From the training set create a K-fold partition (let's start with 5) cp = cvpartition(N,?kfold?,10)
K = 5;
kFoldpartition = cvpartition(trainingClassLabel,'KFold',K)
classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' };


%% 4. Then use k 1 subsets to train a classifier and the remaining subset to test it, say the first subset. Then you iterate and select the second subset for testing and use subsets {1, 3, 4, . . .} for training, etc..
% find(test(cp,i)) to find indices of samples for the ith test subset and find(training(cp,i)) to find indices of the ith train subsets. It is also possible to use cp.training(i) and cp.test(i).
% use a for loop to compute the test error for each fold. Your cross- validation error is the mean of the test errors obtained over the 10 folds. Notice that you can also compute the standard deviation of the cross-validation error. This is an important measure of how stable your performances are.
nbfeatures = floor(size(validationObs,2));

classerror_fold = zeros(K,nbfeatures,length(classifiers));
classificationerror_fold = zeros(K,nbfeatures,length(classifiers));
bestfeaturesindex = zeros(K,nbfeatures,length(classifiers));
for classifier_i = 1:length(classifiers)-1
    
    for fold_i = 1:K
        
        trainingfolds = trainingObs(find(training(kFoldpartition,fold_i)),:);
        trainingfoldslabels = trainingClassLabel(find(training(kFoldpartition,fold_i)));
        
        [orderedInd, orderedPower] = rankfeat(trainingfolds, trainingfoldslabels,'fisher');
        bestfeaturesindex(fold_i,:,classifier_i) = orderedInd;
        for feature_i = 1:nbfeatures
            % train on train set of one fold
            predictors = trainingfolds(:,orderedInd(1,1:feature_i ));
            response = trainingfoldslabels ;
            [trainedClassifier] =  callmyclassifier2(char(classifiers(classifier_i)),predictors,response);
            
            % test  on test set of one fold
            
            testfold = trainingObs(find(test(kFoldpartition,fold_i)),orderedInd(1,1:feature_i ));
            testfold_labels = trainingClassLabel(find(test(kFoldpartition,fold_i)),:);
            
            [testfold_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, testfold);
            % compute the test error for the fold
            classerror_fold(fold_i,feature_i,classifier_i) = getclasserror(testfold_labels,testfold_labels_Prediction);
            classificationerror_fold(fold_i,feature_i,classifier_i) = getclassificationerror(testfold_labels,testfold_labels_Prediction);
            
        end
    end
    
end
% compute the crossvalidation error => the mean error over all the folds
CVclassError = mean(classerror_fold,1)
CVclassError_std = std(classerror_fold,1)
CVclassificationError = mean(classificationerror_fold,1)
CVclassificationError_std = std(classificationerror_fold,1)

%% Now compute the error on an unseen data set (the validation set we kept at the begining)
%
% Validationclasserror = zeros(length(classifiers),1);
% Validationclassificationerror = zeros(length(classifiers),1);
% for cl = 1:length(classifiers)
%     % First we train the model with the whole training set
%
%     trainedClassifier =  callmyclassifier2(char(classifiers(classifier_i)),trainingObs,trainingClassLabel)
%
%     % Then we compute the validation class and classification error
%
%     [Validation_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,validationObs);
%     Validationclasserror(cl) = getclasserror(validationClassLabel,Validation_labels_Prediction);
%     Validationclassificationerror(cl) = getclassificationerror(validationClassLabel,Validation_labels_Prediction);
% end

%% Plot results
x=1:nbfeatures;
y = [CVclassError];
std_dev = [CVclassError_std];
figtrial(1) = figure();

figure(figtrial(1))
for i = 1:length(classifiers)-1
subplot(2,2,i);
plot(x,y(:,:,i));
%errorbar(y,std_dev ,'.');
title('CV Class Error vs number of features ');
legend(char(classifiers(i)))
end

savefig(figtrial, 'CV Class Error vs number of features');

%% 6. same with Fisher score with the two best models maybe