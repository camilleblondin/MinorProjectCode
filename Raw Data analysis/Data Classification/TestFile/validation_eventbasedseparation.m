
%% try to identify the error here!!!
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
classifiers = {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' };

signalLRL = dataset.outputdata.psd.LRL.signal;
WindowDuration = 0.0625;
WindowOfInterest = 0.8;
%%
partition = cvpartition(size(signalLRL, 3), 'KFold', 20);
validationdataset = signalLRL(:,:,partition.test(1),:);
traindataset = signalLRL(:,:,partition.training(1) ,:);

%% 2. Extract the Feature sets
%Training Set
Trainingdata = struct('signal',[],'event',[],'channelLabel',[]);
Trainingdata.signal = traindataset;
Trainingdata.event = dataset.outputdata.psd.LRL.event;
Trainingdata.channelLabel = dataset.outputdata.channel_label;

[BeforeEventMatLRLTraining,AfterEventMatTraining] = getdataset_general(Trainingdata,WindowDuration,WindowOfInterest);

trainingObs = BeforeEventMatLRLTraining(2:end,:)';
trainingClassLabel = BeforeEventMatLRLTraining(1,:)';

%Validation/TestingSet
Validationdata = struct('signal',[],'event',[],'channelLabel',[]);
Validationdata.signal = validationdataset;
Validationdata.event = dataset.outputdata.psd.LRL.event;
Validationdata.channelLabel = dataset.outputdata.channel_label;

[BeforeEventMatLRLVal,AfterEventMatVal] = getdataset_general(Validationdata,WindowDuration,WindowOfInterest);

validationObs = BeforeEventMatLRLVal(2:end,:)';
validationClassLabel = BeforeEventMatLRLVal(1,:)';


% % % %% Now we try by dividing the already prepared matrice as the bug may come from this
% % % [BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);
% % % 
% % % nbsamples = floor(size(BeforeEventMatLRL,2));
% % % nbtestsamples = floor(size(BeforeEventMatLRL,2)*0.2);
% % % trainingObs = BeforeEventMatLRL(2:end,1:end-nbtestsamples)';
% % % trainingClassLabel = BeforeEventMatLRL(1,1:end-nbtestsamples)'
% % % 
% % % validationObs = BeforeEventMatLRL(2:end,nbsamples-nbtestsamples:end)';
% % % validationClassLabel = BeforeEventMatLRL(1,nbsamples-nbtestsamples:end)';

%% Now compute the error on an unseen data set (the validation set we kept at the begining)

Validationclasserror = zeros(length(classifiers),1);
Validationclassificationerror = zeros(length(classifiers),1);
trainingclasserror = zeros(length(classifiers),1);

for cl = 1:length(classifiers)
    
    % Feature selection
    %opts = statset('display','iter');
    %[fs, inmodexl] = sequentialfs(@my_funFineKnn, trainingObs,trainingClassLabel,'options',opts) ;
    index_best_features = 1:(37*16) %  find(mean(inmodexl.In));
    %optimalError = inmodexl.Crit(end);

    % First we train the model with the whole training set
    trainedClassifier =  callmyclassifier2(char(classifiers(cl)),trainingObs(:,index_best_features),trainingClassLabel)
    classifiers(cl)
    % Then we compute the validation class and classification error
    [training_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,trainingObs(:,index_best_features));
    trainingclasserror(cl) = getclasserror(trainingClassLabel,training_labels_Prediction);

    [Validation_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,validationObs(:,index_best_features));
    Validationclasserror(cl) = getclasserror(validationClassLabel,Validation_labels_Prediction);
    Validationclassificationerror(cl) = getclassificationerror(validationClassLabel,Validation_labels_Prediction);
end
x=1:5;
y = [Validationclasserror];
y2 = [trainingclasserror];
figure()
hold on
bar(x,y)
hold on;
bar(x,y2)
title('Validation Class Error');
legend('test error','training error')
XTickLabel= classifiers;
XTick=[1:5];
set(gca, 'XTick',XTick);
set(gca, 'XTickLabel', XTickLabel);

