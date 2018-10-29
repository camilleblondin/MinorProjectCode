% FT by trial
% Signal normalization

% First separate by trial Start trial to Start Trial
% Then normalize each of the signal_trial by its respective baseline
% Then takes the mean over all trials for each frequency and display a
% FrequencyTime plot

event_position = rawdata.psd.events.position;
event_labels = rawdata.psd.events.labels;
event_time = rawdata.psd.events.time;

baseline_position = event_position(find(event_labels == 'baseline'));
baseline_end_position = event_position(find(event_labels == 'baseline')+1);
START_position = event_position(find(event_labels == 'START trial'));

rawdata.psd.normalized = zeros(size(rawdata.psd.signal));
nb_of_channels = size(rawdata.psd.signal,3);

diff = START_position - [0; START_position(1:end-1)];
dmin = min(diff(2:end));
figtrial(1) = figure();
figtrial(2) = figure();
% For one channel at a time
mean_baseline = [];
for j = 1:nb_of_channels
    
    channel_j = rawdata.psd.signal(:,:,j);
    normalized_signal =  zeros(size(channel_j,1),dmin,length(baseline_position));
    
    baseline=[];
    
    for i = 1:length(baseline_position)
        
        trial_i = channel_j(:,START_position(i):START_position(i)+dmin-1);
        baseline_i = channel_j(:,baseline_position(i):baseline_end_position(i));
        
        norm_i = 20*(log(trial_i) - mean(log(baseline_i),2));
        normalized_signal(:,:,i) = norm_i;
        baseline = [baseline, mean(log(baseline_i),2)];
        
    end
    
    mean_signal_overtrials = mean(normalized_signal,3);
    mean_baseline = [mean_baseline; mean(baseline,2)]; % TODO may be used for a plot average over frequencies with baseline
    
    start = event_time(event_labels == 'START trial');
    event_labels_trial = event_labels(find(event_time <= max(rawdata.psd.time(1:(dmin)))+start(1)));
    
    figure(figtrial(1)) 
    set(figtrial(1),'Name','Frequency vs Time, average over trial','NumberTitle','off')
    subplot(sqrt(nb_of_channels),sqrt(nb_of_channels),j)
    imagesc(rawdata.psd.time(1:dmin),rot90(flipud(rawdata.frequencies_of_interest),-1),mean_signal_overtrials)
    hold on;
    set(gca,'YDir','normal')
    vline(event_time(event_labels_trial == 'left')-start(1), '--g', 'L')
    hold on;
    vline(event_time(event_labels_trial == 'right') - start(1), '--r', 'R')
    hold on;
    vline(event_time(event_labels_trial == 'START trial')- start(1), '-b', 'S')
    hold on;
    vline(event_time(event_labels_trial == 'baseline')- start(1), '-.p', 'b')
    hold on;
   % plotevents(event_time,event_labels_trial,start(1),{'left','right','START trial','baseline'})
    hold on;
    title([rawdata.channel_label(j)]);
    xlabel('Time [s]');
    ylabel('Frequency');
    hold on;
    colorbar;
    caxis([-20 20]);
    hold off;
    
    figure(figtrial(2))
    set(figtrial(2),'Name','PSD mean value across frequencies during trial','NumberTitle','off')
    subplot(sqrt(nb_of_channels),sqrt(nb_of_channels),j);
    hold on;
    plot(rawdata.psd.time(1:dmin),ones(length(mean_signal_overtrials),1) * mean(mean_baseline(j)));
    hold on;
    plot(rawdata.psd.time(1:dmin),mean(mean_signal_overtrials,1));
    hold on;
     vline(event_time(event_labels_trial == 'left')-start(1), '--g', 'L')
    hold on;
    vline(event_time(event_labels_trial == 'right') - start(1), '--r', 'R')
    hold on;
    vline(event_time(event_labels_trial == 'START trial')- start(1), '-b', 'S')
    hold on;
    vline(event_time(event_labels_trial == 'baseline')- start(1), '-.p', 'b')
    %plotevents(event_time,event_labels_trial,start(1),{'left','right','START trial','baseline'})
    title([rawdata.channel_label(j)]);
    xlabel('Time [s]');
    ylabel('mean psd value');
    
end