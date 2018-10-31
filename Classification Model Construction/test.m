
filename = 's02s3r1_OutPutStruct.mat';
WindowDuration = 0.5;
WindowOfInterest = 0.8;

load(filename);
psdLRL = outputdata.psd.LRL.signal;
event_position = outputdata.psd.LRL.event.position ;
event_label = outputdata.psd.LRL.event.labels ;
channels = outputdata.channel_label ;


beforeeventMAT = [];
aftereventMAT = [];

% For each Channel
for channel = 1:length(channels)
    
    psdLRL_channel = outputdata.psd.LRL.signal(:,:,:,channel);
    beforeeventMATchannel = [];
    aftereventMATchannel = [];
    classelabel_beforeeventMAT =[];
    classelabel_aftereventMAT =[];
    

    nbOfEvents = size(outputdata.psd.LRL.signal,3);
    
    for event = 1:nbOfEvents
        
        psdLRL_channel_event = outputdata.psd.LRL.signal(:,:,event,1);
        
        % For each trial 
        [dataset] = getSignalLabelling(psdLRL_channel_event,outputdata.psd.LRL.event,WindowDuration,WindowOfInterest);
        
        posclass1 =  find(dataset(1,:) == 1);
        posclass1start = posclass1(1);
        posclass1end = posclass1(end);
        
        beforeevent = dataset(:,1:posclass1end);
        beforeeventMATchannel = [beforeeventMATchannel,beforeevent];
        
        afterevent = dataset(:,posclass1start:end);
        aftereventMATchannel = [aftereventMATchannel,afterevent];
            
    end
    beforeeventMAT = [beforeeventMAT;beforeeventMATchannel];
    aftereventMAT = [aftereventMAT;aftereventMATchannel];
end
BeforeEventMat = [beforeeventMAT];
AfterEventMat = [aftereventMAT];



