

event_position = rawdata.events.position;
event_labels = rawdata.events.labels;
event_time = rawdata.events.time ;
signal = rawdata.signal(:,1:16);
%%
baseline_position = event_position(find(event_labels == 'baseline'));
baseline_end_position = event_position(find(event_labels == 'baseline')+1);
START_position = event_position(find(event_labels == 'START trial'));

rawdata_normalized = zeros(size(rawdata.signal));
nb_of_channels = 16;
%%
diff = START_position - [0; START_position(1:end-1)];
dmin = min(diff(2:end));
%%
% For one channel at a time

normalized_signal_channels = zeros(dmin,length(baseline_position),nb_of_channels);
for j = 1:nb_of_channels
    
    channel_j = signal(:,j);
    normalized_signal =  zeros(dmin,length(baseline_position));
    
    baseline=[];
    
    for i = 1:length(baseline_position)
        
        trial_i = channel_j(START_position(i):START_position(i)+dmin-1);
        baseline_i = channel_j(baseline_position(i):baseline_end_position(i));
        
        norm_i = 20*(log(trial_i) - mean(log(baseline_i)));
        normalized_signal(:,i) = norm_i;
        
    end
    
    normalized_signal_channels(:,:,j) = normalized_signal;
    mean_signal_overtrials = mean(normalized_signal,3);
    
end

 startposition = event_position(event_labels == 'START trial');
 start2startpos = find(event_labels == 'START trial',2);
 event_labels_trial = event_labels(start2startpos(1) : start2startpos(2));
 event_position_trial = event_position(start2startpos(1) : start2startpos(2) ) - startposition(1)+1;


