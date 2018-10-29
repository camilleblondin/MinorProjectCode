% data labels

event_type = rawdata.events.type;
rawdata.events.labels = strings(length(event_type),1);

for i = 1:length(event_type)
    rawdata.events.labels(find(event_type == 781)) = 'start';
    rawdata.events.labels(find(event_type == 1 | event_type == 1000)) = 'START trial';
    rawdata.events.labels(find(event_type == 782)) = 'left';
    rawdata.events.labels(find(event_type == 783)) = 'right';
    rawdata.events.labels(find(event_type == 786)) = 'baseline';
end

%% Name the channels as well according to their names

channel_labels = load('/Users/camilleblondin/Desktop/MinorProjectCode/BCI_FTW/Analysis/resources/chanlocs16.mat');
channels_number = 16;
rawdata.channel_label = strings(channels_number,1);
outputdata.channel_label= strings(channels_number,1);
for i = 1:channels_number
    
    rawdata.channel_label(i) = channel_labels.chanlocs16(i).labels;
    outputdata.channel_label(i) = channel_labels.chanlocs16(i).labels;
end

