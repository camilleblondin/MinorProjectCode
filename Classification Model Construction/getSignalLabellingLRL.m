function [DataSet] = getSignalLabellingLRL(signal_event,event,WindowDuration,WindowOfInterest)
DataSet = struct('data',[],'classlabels',[]);
%UNTITLED Summary of this function goes here
%   signal_event: dimensions =  (frequencies x length of one event)
%   WindowDuration: window duration in seconds 
%   WindowOfInterest: duration of the window around the event of interest that will be labelled as class 1 in seconds

window_length = floor(16 * WindowDuration);
window_of_interest = floor(WindowOfInterest*16);

nb_of_windows = floor(size((1:window_length:(size(signal_event,2) - window_length)),2));

classlabel = zeros(1,nb_of_windows);
        
signal_event_windows=[];
windowcount = 0;

event_label = event.labels;
event_position = event.position;
        

for i = 1:window_length:(size(signal_event,2) - window_length)
            
            windowcount = windowcount +1;
            signal_event_windows = [signal_event_windows , mean(signal_event(:,i:i+window_length),2)];
            startpos =  find(event_label == 'start',2,'first');
        
            
            if i >= event_position(startpos(end))- window_of_interest/2  && i <= event_position(startpos(end)) + window_of_interest/2
                classlabel(windowcount) = 1;
            end
                   
end
dataset = [signal_event_windows];
DataSet.data = dataset;
DataSet.classlabels = classlabel;
end

