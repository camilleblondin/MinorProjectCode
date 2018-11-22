% PSeudo Online
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

partition = cvpartition(size(signalLRL, 3), 'KFold', 10);
validationdataset = signalLRL(:,:,partition.test(1),:);
traindataset = signalLRL(:,:,partition.training(1) ,:);
nbValEvents= sum(partition.test(1));
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
validationObs = [];
validationClassLabel= [];
for testevent_i = 1:length(nbValEvents )
    
    Validationdata = struct('signal',[],'event',[],'channelLabel',[]);
    Validationdata.signal = validationdataset(:,:,testevent_i,:);
    Validationdata.event = dataset.outputdata.psd.LRL.event;
    Validationdata.channelLabel = dataset.outputdata.channel_label;
    
    [BeforeEventMatLRLVal,AfterEventMatVal] = getdataset_general(Validationdata,WindowDuration,WindowOfInterest);
    validationObs(:,:,testevent_i) = BeforeEventMatLRLVal(2:end,:)';
    validationClassLabel(:,testevent_i) = BeforeEventMatLRLVal(1,:)';
    
end

%% TRaining classifier
[orderedInd, orderedPower] = rankfeat(trainingObs,trainingClassLabel,'fisher');
trainedClassifier =  callmyclassifier2('LDA',trainingObs(:,orderedInd(1:100)),trainingClassLabel)

% Then we compute the validation class and classification error
[training_labels_Prediction, X0E, MPRED] = predict(trainedClassifier,trainingObs(:,orderedInd(1:100)));
trainingclasserror = getclasserror(trainingClassLabel,training_labels_Prediction);
Class1ProbaAllEvents= [];
Class0ProbaAllEvents= [];

for event_i = 1: length(nbValEvents)
    testSet_forOneEvent = validationObs(:,:,event_i);
    EventClass1Proba= [];
    EventClass0Proba= [];
    for w = 1:size(testSet_forOneEvent,1)
        [labels_Prediction, ClassProba, MPRED] = predict(trainedClassifier,testSet_forOneEvent(w,orderedInd(1:100)));
        EventClass1Proba = [EventClass1Proba ClassProba(2)];
        EventClass0Proba = [EventClass0Proba ClassProba(1)];
    end
    Class1ProbaAllEvents = [Class1ProbaAllEvents;EventClass1Proba];
    Class0ProbaAllEvents = [Class0ProbaAllEvents;EventClass0Proba];
end
%%
events_pos = dataset.outputdata.psd.LRL.event.position;
events_label = dataset.outputdata.psd.LRL.event.labels;
startevent = events_pos(events_label == 'start');
time= (1:length(mean(Class1ProbaAllEvents,1)))/16;
figure()
plot(time,mean(Class1ProbaAllEvents,1),'-*b');
hold on;
%plot(mean(Class0ProbaAllEvents,1),'-.b');
title('LDA Pseudo Online Classification');
vline(startevent(1)/16, '-.p','Left Cue')
vline(startevent(2)/16, '-.p','Right Cue')
xlabel('Time [s]');
ylabel('Transition Probability');
