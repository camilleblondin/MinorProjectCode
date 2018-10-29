% FT by LRL

% First separate by trial Start trial to Start Trial
% Then normalize each of the signal_trial by its respective baseline
% Separate in LFL segment
% Then takes the mean over all LRL segments for each frequency and display a
% FrequencyTime plot

event_position = rawdata.psd.events.position;
event_labels = rawdata.psd.events.labels;
event_time = rawdata.psd.events.time;

baseline_position = event_position(find(event_labels == 'baseline'));
baseline_end_position = event_position(find(event_labels == 'baseline')+1);
START_position = event_position(find(event_labels == 'START trial'));
left_position = event_position(find(event_labels == 'left'));
start_position = event_position(find(event_labels == 'start'));

number_of_trial = length(baseline_position);
number_of_frequencies = length(rawdata.frequencies_of_interest);
number_of_left_event_per_trial = length(left_position)/number_of_trial -1;


rawdata.psd.normalized = zeros(size(rawdata.psd.signal));
nb_of_channels = size(rawdata.psd.signal,3);

diff = START_position - [0; START_position(1:end-1)];
dmin = min(diff(2:end));

diff_left = left_position - [0; left_position(1:end-1)];
dmin_left = min(diff_left(2:end)) + 5*(start_position(1)-left_position(1)); % here we define the length of a Left-Right-Left segment, we add 2 times the difference between start and left position to ensure to include the start event linked to the Left event.

outputdata.psd.LRL.mean= zeros(number_of_frequencies ,dmin_left,nb_of_channels); % nb_of_frequencie x length LRL (==dmin_left) x nb of channels
outputdata.psd.LRL.signal = zeros(number_of_frequencies ,dmin_left,number_of_trial * number_of_left_event_per_trial,nb_of_channels); % nb_of_frequencie x length LRL (==dmin_left) x nb of channels

event_labels_in_LRL= [];
event_position_in_LRL=[];
mean_baseline = [];

for j = 1:nb_of_channels
    
    channel_j = rawdata.psd.signal(:,:,j);
    number_of_LRL_events = length(left_position)-length(baseline_position);
  
    normalized_signal =  zeros(number_of_frequencies,dmin_left,number_of_LRL_events );
    baseline=[];
    LRL_event_num = 1;
    for i = 1:number_of_trial
          
        trial_i = channel_j(:,START_position(i):START_position(i)+dmin-1);
        baseline_i = channel_j(:,baseline_position(i):baseline_end_position(i));
        
        event_position_in_trial = event_position(find(event_position == START_position(i)):find(event_position == START_position(i+1))) - START_position(i) +1;
        event_labels_in_trial = event_labels(find(event_position == START_position(i)):find(event_position == START_position(i+1)));
        
        norm_i = 20*(log(trial_i) - mean(log(baseline_i),2));
        baseline = [baseline, mean(log(baseline_i),2)];

        left_event_position_in_trial = event_position_in_trial(find(event_labels_in_trial == 'left'));
        
        for LRL_nb = 1:length(left_event_position_in_trial)-1
             
            normalized_signal(:,:,LRL_event_num) = norm_i(:,left_event_position_in_trial(LRL_nb):left_event_position_in_trial(LRL_nb)+dmin_left-1);
            LRL_event_num = LRL_event_num + 1;

        end
        
        event_position_in_LRL = event_position_in_trial(find(event_position_in_trial ==left_event_position_in_trial(1)):find(event_position_in_trial ==left_event_position_in_trial(2))) - left_event_position_in_trial(1)+1;
        event_labels_in_LRL = event_labels_in_trial(find(event_position_in_trial ==left_event_position_in_trial(1)):find(event_position_in_trial ==left_event_position_in_trial(2)));
    end
    
    mean_baseline = [mean_baseline; mean(baseline,2)]; % TODO may be used for a plot average over frequencies with baseline
    mean_signal_overLRL = mean(normalized_signal,3);
    time_LRL = rawdata.psd.time(1:dmin_left);
    
    %% For each channel save the LRL mean signal
    outputdata.psd.LRL.signal(:,:,:,j) = normalized_signal;
    
    %% For each channel save the LRL mean signal
    outputdata.psd.LRL.mean(:,:,j) = mean_signal_overLRL; % nb_of_frequencie x length LRL (==dmin_left) x nb of channels
    %%
end

outputdata.psd.LRL.event.labels   = event_labels_in_LRL;
outputdata.psd.LRL.event.position = event_position_in_LRL;
outputdata.psd.LRL.properties.time = time_LRL ;
outputdata.psd.LRL.properties.frequencies = rawdata.frequencies_of_interest;

