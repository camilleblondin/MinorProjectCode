function normalizedData = normalize_data(rawdata,event_position,event_label)
% NORMAILZE_DATA takes data in a 2D or 3D (if multiple channels) and gives
% back a normalized matrice of the same format with the normalized signal 

baseline_position = event_position(find(event_label == 'baseline'));
baseline_end_position = event_position(find(event_label == 'baseline')+1);
START_position = event_position(find(event_label == 'START trial'));

normalizedData = zeros(size(rawdata));
nb_of_channels = size(rawdata,3);

% For one channel at a time
for j = 1:nb_of_channels
    
    channel_j = rawdata(:,:,j);
    
    % Format of a channel is nb_of_frequencies x time
    normalized_signal = zeros(size(channel_j));
    
    for i = 1:length(baseline_position)
        
        trial_i = channel_j(:,START_position(i):START_position(i+1));
        baseline_i = channel_j(:,baseline_position(i):baseline_end_position(i));
        
        norm_i = 20*(log(trial_i) - mean(log(baseline_i),2));
        normalized_signal(:,START_position(i):START_position(i+1)) = norm_i;
    end
    
    normalizedData(:,:,j)= normalized_signal;
end
end

