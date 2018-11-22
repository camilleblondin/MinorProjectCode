function [trainingObs,trainingClassLabel] = getObsandLabels(dataset,events_info,nbOfchannels,WindowDuration,WindowOfInterest)
%% Dataset should be a whole data set or a partition of an event-based dataset (nbfeatures x time x events x channels)
data = struct('signal',[],'event',[],'channelLabel',[]);
data.signal = dataset;
data.event = events_info;
data.channelLabel = [1:nbOfchannels];

[BeforeEventMatLRL,AfterEventMat] = getdataset_general(data,WindowDuration,WindowOfInterest);

trainingObs = BeforeEventMatLRL(2:end,:)';
trainingClassLabel = BeforeEventMatLRL(1,:)';
end

