%% Script to obtain statistical results
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

valLRLind = [1 6 10 11 15 20 22 28 32 40 45];
trainLRLind = [2:5 7:9 12:14 16:19 21 23:27 29:31 33:39 41:44 46:56];

validationdataset = signalLRL(:,:,valLRLind,:);
traindataset = signalLRL(:,:,trainLRLind ,:);

%% 2. Extract the Feature sets
%Training Set
Trainingdata = struct('signal',[],'event',[],'channelLabel',[]);
Trainingdata.signal = traindataset;
Trainingdata.event = dataset.outputdata.psd.LRL.event;
Trainingdata.channelLabel = dataset.outputdata.channel_label;

WindowDuration = 0.0625;
WindowOfInterest = 0.8;

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
%% 3. From the training set create a K-fold partition (let's start with 5) cp = cvpartition(N,?kfold?,10)
K = 5;
kFoldpartition = cvpartition(trainingClassLabel,'KFold',K)


%% 4. Then use k 1 subsets to train a classifier and the remaining subset to test it, say the first subset. Then you iterate and select the second subset for testing and use subsets {1, 3, 4, . . .} for training, etc..
% find(test(cp,i)) to find indices of samples for the ith test subset and find(training(cp,i)) to find indices of the ith train subsets. It is also possible to use cp.training(i) and cp.test(i).
% use a for loop to compute the test error for each fold. Your cross- validation error is the mean of the test errors obtained over the 10 folds. Notice that you can also compute the standard deviation of the cross-validation error. This is an important measure of how stable your performances are.
 classerror_fold = zeros(K,1); 
 classificationerror_fold = zeros(K,1); 

for fold_i = 1:K
    
    % train on train set of one fold
    predictor = trainingObs(find(training(kFoldpartition,fold_i)),:);
    response = trainingClassLabel(find(training(kFoldpartition,fold_i)));
    
    classificationKNN = fitcknn(...
    predictor, ...
    response, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);
    
    % test  on test set of one fold
    
    testfold = trainingObs(find(test(kFoldpartition,fold_i)),:);
    testfold_labels = trainingClassLabel(find(test(kFoldpartition,fold_i)),:);
    
    [testfold_labels_Prediction, X0E, MPRED] = predict(classificationKNN, testfold);
    % compute the test error for the fold
    classerror_fold(fold_i) = getclasserror(testfold_labels,testfold_labels_Prediction);
    classificationerror_fold(fold_i) = getclassificationerror(testfold_labels,testfold_labels_Prediction);
    
end

% compute the crossvalidation error => the mean error over all the folds
CVclassError = mean(classerror_fold)
CVclassError_std = std(classerror_fold)
CVclassificationError = mean(classificationerror_fold)
CVclassificationError_std = std(classificationerror_fold)

%% Now compute the error on an unseen data set (the validation set we kept at the begining)
% First we train the model with the whole training set
 classificationKNN = fitcknn(...
    trainingObs, ...
    trainingClassLabel, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);
    
% Then we compute the validation class and classification error

[Validation_labels_Prediction, X0E, MPRED] = predict(classificationKNN,validationObs);
Validationclasserror = getclasserror(validationClassLabel,Validation_labels_Prediction)
Validationclassificationerror = getclassificationerror(validationClassLabel,Validation_labels_Prediction)
    

%% Plot results
x=1:7;
y = [CVclassError,0,CVclassificationError,0,Validationclasserror,0,Validationclassificationerror ];
std_dev = [CVclassError_std, 0 ,CVclassificationError_std,0,0,0,0];

figure()
hold on
bar(x,y)
errorbar(y,std_dev ,'.');

XTickLabel={'CV class error'; 'CV classification error';'Validation Class Error';'Validation Classification error'};
XTick=[1 3 5 7];
set(gca, 'XTick',XTick);
set(gca, 'XTickLabel', XTickLabel);

%% 5. Do it for all the models we want to test!
% See PerformanceforAllModels / partitionned with cvpartition or 'by hand'

%% 6. same with Fisher score with the two best models maybe