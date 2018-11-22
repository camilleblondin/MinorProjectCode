
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

k = 5;
kFoldpartition = cvpartition(size(traindataset,3), 'KFold', k);
WindowDuration = 0.0625;
WindowOfInterest = 0.8;
events_info = dataset.outputdata.psd.LRL.event;
nbOfchannels = 16;
%kFoldpartition.test(fold_i)
%kFoldpartition.training(fold_i)

classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM','DiagQuadratic' };

%% 4. Then use k 1 subsets to train a classifier and the remaining subset to test it, say the first subset. Then you iterate and select the second subset for testing and use subsets {1, 3, 4, . . .} for training, etc..
nbfeatures = 16*37;
trainingclasserror = zeros(k,nbfeatures,length(classifiers));
testclasserror = zeros(k,nbfeatures,length(classifiers));

for fold_i = 1:k
    for classifier_i = 1:length(classifiers)
        % For each fold and each classifier we extract the Observation and
        % labels of beforeeventmatrice
        
        [trainingfolds, trainingfoldslabels] = getObsandLabels(traindataset(:,:,kFoldpartition.training(fold_i),:),events_info,nbOfchannels,WindowDuration,WindowOfInterest);
        [testfold,testfoldslabels] = getObsandLabels(traindataset(:,:,kFoldpartition.test(fold_i),:),events_info,nbOfchannels,WindowDuration,WindowOfInterest);
% then for each fold and each classifier, we define the best features with
% their order
        [orderedInd, orderedPower] = rankfeat(trainingfolds, trainingfoldslabels,'fisher');
        
        for feature_i = 1:nbfeatures
         %Then for each combination of feature we train and predict and compute the error   
            
            [trainedClassifier] =  callmyclassifier2(char(classifiers(classifier_i)),trainingfolds(:,orderedInd(1,1:feature_i )),trainingfoldslabels);
            
            [testfold_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, testfold(:,orderedInd(1,1:feature_i )));
            [train_labels_Prediction, X0E, MPRED] = predict(trainedClassifier, trainingfolds(:,orderedInd(1,1:feature_i )));
            trainingclasserror(fold_i,feature_i,classifier_i) = getclasserror(trainingfoldslabels,train_labels_Prediction);
            testclasserror(fold_i,feature_i,classifier_i) = getclasserror(testfoldslabels,testfold_labels_Prediction);

        end
                 
    end
end
%%
% compute the crossvalidation error => the mean error over all the folds
CVclassError = mean(testclasserror);
CVclassError_std = std(testclasserror);

CVclassErrortrain = mean(trainingclasserror);
CVclassError_stdtrain = std(trainingclasserror);


%% Plot results
x = 1:nbfeatures;
y = [CVclassError];
std_dev = [CVclassError_std];
figtrial(1) = figure();
%
nboffeatureforminerror = zeros(size(classifiers));
%
figure(figtrial(1))
for i = 1:length(classifiers)
CVClassError_classifier_i = y(:,:,i);
subplot(3,2,i);
plot(x,CVClassError_classifier_i);
%errorbar(y,std_dev ,'.');
title('CV Class Error vs number of features ');
legend(char(classifiers(i)))
grid on;
ylim([0.2 0.5])
%
nboffeatureforminerror(i) = find(CVClassError_classifier_i  == min(CVClassError_classifier_i ));
%
end

savefig(figtrial, 'CV Class Error vs number of features');

%% Now, for each classifier, we take the optimal number of best feature and train/test a model 


Validationclasserror = zeros(length(classifiers),1);
Validationclassificationerror = zeros(length(classifiers),1);
trainingclasserror = zeros(length(classifiers),1);

[trainingObs,trainingClassLabel] = getObsandLabels(traindataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);
[validationObs,validationClassLabel] = getObsandLabels(validationdataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest);

[orderedInd, orderedPower] = rankfeat(trainingObs, trainingClassLabel,'fisher');

for cl = 1:length(classifiers)
    % First we train the model with the whole training set
    trainedClassifier = callmyclassifier2(char(classifiers(cl)),trainingObs(:,orderedInd(1:nboffeatureforminerror(cl))),trainingClassLabel)
    
    % Then we compute the validation class and classification error
    [training_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,trainingObs(:,orderedInd(1:nboffeatureforminerror(cl))));
    trainingclasserror(cl) = getclasserror(trainingClassLabel,training_labels_Prediction);
    %
    [Validation_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,validationObs(:,orderedInd(1:nboffeatureforminerror(cl))));
    Validationclasserror(cl) = getclasserror(validationClassLabel,Validation_labels_Prediction);
    Validationclassificationerror(cl) = getclassificationerror(validationClassLabel,Validation_labels_Prediction);
end

%% PLot
nbmodels =length(classifiers);
x=1:nbmodels;
y = [Validationclasserror(1:nbmodels)];
y2 = trainingclasserror(1:nbmodels);
figure()
hold on;
bar(x,y)
hold on;
bar(x,y2)
title('Class Error');
ylim([0 0.5])
hold on;
grid on;
XTickLabel = classifiers(1:nbmodels);
XTick = [1:nbmodels];
set(gca, 'XTick',XTick);
set(gca, 'XTickLabel', XTickLabel);
legend('Test error','Training Error')