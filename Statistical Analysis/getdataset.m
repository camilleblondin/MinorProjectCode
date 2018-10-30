function [BeforeEventMat,AfterEventMat] = getdataset(filename,WindowDuration,WindowOfInterest)

load(filename);
psdLRL = outputdata.psd.LRL.signal;
events_info = outputdata.psd.LRL.event ;
channels = outputdata.channel_label ;

beforeeventMAT = [];
aftereventMAT = [];

for channel = 1:length(channels)
    
    psdLRL_channel = outputdata.psd.LRL.signal(:,:,:,channel);
    beforeeventMATchannel = [];
    aftereventMATchannel = [];
    classelabel_beforeeventMAT =[];
    classelabel_aftereventMAT =[];
    % TRIAL NUMBER
    for event = 1:size(outputdata.psd.LRL.signal,3)
        
        psdLRL_channel_event = outputdata.psd.LRL.signal(:,:,event,1);
        
        [DatasetEvent] = getSignalLabelling(psdLRL_channel_event,events_info ,WindowDuration,WindowOfInterest);
        classlabel_event = DatasetEvent.classlabels;
        dataset_event = DatasetEvent.data;

        posclass1 = find(classlabel_event == 1);
        posclass1start = posclass1(1);
        posclass1end = posclass1(end);
        
        beforeevent = dataset_event(:,1:posclass1end);
        beforeeventMATchannel = [beforeeventMATchannel,beforeevent];
        classelabel_beforeeventMAT =[classelabel_beforeeventMAT,classlabel_event(:,1:posclass1end)];
        classelabel_aftereventMAT =[classelabel_aftereventMAT,classlabel_event(:,posclass1start:end)];
        afterevent = dataset_event(:,posclass1start:end);
        aftereventMATchannel = [aftereventMATchannel,afterevent];
            
    end
    
    beforeeventMAT = [beforeeventMAT;beforeeventMATchannel];
    aftereventMAT = [aftereventMAT;aftereventMATchannel];
end
BeforeEventMat = [ classelabel_beforeeventMAT ;beforeeventMAT];
AfterEventMat = [classelabel_aftereventMAT;aftereventMAT];

end
