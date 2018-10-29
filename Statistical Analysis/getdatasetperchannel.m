function [BeforeEventMat,AfterEventMat ] = getdatasetperchannel(filename,window_duration,WindowOfInterest,channelnumber)

load(filename);
psdLRL = outputdata.psd.LRL.signal;
event_position = outputdata.psd.LRL.event.position ;
event_label = outputdata.psd.LRL.event.labels ;

% Preparing the data for classification
% let's start with one channel only..
% CHANNEL
psdLRL_channel = outputdata.psd.LRL.signal(:,:,:,channelnumber);
beforeeventMAT = [];
aftereventMAT = [];
classelabel_beforeeventMAT =[];
classelabel_aftereventMAT =[];
% TRIAL NUMBER
for trial = 1:size(outputdata.psd.LRL.signal,3)
    
    psdLRL_channel_trial = outputdata.psd.LRL.signal(:,:,trial,1);
    
    window = 16 * window_duration;
    window_of_interest = floor(WindowOfInterest*16);
    nb_of_windows = floor((size(psdLRL_channel_trial,2)-window)/window);
    classlabel = zeros(1,nb_of_windows);
    
    psdLRL_channel_trial_windows=[];
    windownumber = 0;
    for i = 1:window:size(psdLRL_channel_trial,2) -window
        
        windownumber = windownumber +1;
        
        psdLRL_channel_trial_windows = [psdLRL_channel_trial_windows , mean(psdLRL_channel_trial(:,i:i+window),2)];
        startpos =  find(event_label == 'start',2,'first');
        if i >= event_position(startpos(end))-window_of_interest/2  && i <= event_position(startpos(end)) + window_of_interest/2
            classlabel(windownumber) =1;
        end
    end
    
    posclass1 =  find(classlabel == 1);
    posclass1start = posclass1(1);
    posclass1end = posclass1(end);
    
   
    beforeevent = psdLRL_channel_trial_windows(:,1:posclass1end);
    classelabel_beforeevent = classlabel(1:posclass1end);
    
    beforeeventMAT = [beforeeventMAT,beforeevent];
    classelabel_beforeeventMAT = [classelabel_beforeeventMAT,classelabel_beforeevent];
    
    afterevent = psdLRL_channel_trial_windows(:,posclass1start:end);
    classelabel_afterevent = classlabel(posclass1start:end);
    aftereventMAT = [aftereventMAT,afterevent];
    classelabel_aftereventMAT = [classelabel_aftereventMAT,classelabel_afterevent];
    
    
end

BeforeEventMat = [classelabel_beforeeventMAT;beforeeventMAT];
AfterEventMat = [classelabel_aftereventMAT;aftereventMAT];

end
