function [EventSignalMAT ] = getdatasetLRL(dataset,WindowDuration,WindowOfInterest)

%load(filename);
psdLRL = dataset.outputdata.psd.LRL.signal;
events_info = dataset.outputdata.psd.LRL.event ;
channels = dataset.outputdata.channel_label ;


EventSignalMAT = [];
for channel = 1:length(channels)
    
    psdLRL_channel = psdLRL(:,:,:,channel);
    EventSignal = [];
    classelabelMat = [];

    % TRIAL NUMBER
    for event = 1:size(psdLRL,3)
        
        psdLRL_channel_event = psdLRL(:,:,event,1);
        
        [DatasetEvent] = getSignalLabellingLRL(psdLRL_channel_event,events_info ,WindowDuration,WindowOfInterest);
        classlabel = DatasetEvent.classlabels;
        dataset_event = DatasetEvent.data;

        EventSignal = [EventSignal, dataset_event];
        classelabelMat =[classelabelMat,classlabel];
            
    end
    
    %meanoverfreq = mean(EventSignal,1);
    %EventSignalMAT = [EventSignalMAT ;EventSignal;meanoverfreq ];
    EventSignalMAT = [EventSignalMAT ;EventSignal ];
end

 
EventSignalMAT = [ classelabelMat ;EventSignalMAT ];

end
