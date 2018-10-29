
% Script to plot the already normalized and separated data in a TIME
% FREQUENCY plot per channel

%outputdata.psd.LRL.signal(:,:,:,j) = normalized_signal;
meanLRLsignal = outputdata.psd.LRL.mean;
event_labels_in_LRL = outputdata.psd.LRL.event.labels ;
event_position_in_LRL = outputdata.psd.LRL.event.position ;
time_LRL = outputdata.psd.LRL.properties.time ;
frequencies_of_interest = rawdata.frequencies_of_interest;
channel_labels = rawdata.channel_label;
numberofchannels = size(meanLRLsignal,3);

figLRL = figure();

for channel_n = 1:numberofchannels
    
    figure(figLRL);
    set(figLRL,'Name','Frequency vs Time, average over LRL segment','NumberTitle','off')
    subplot(sqrt(numberofchannels),sqrt(numberofchannels),channel_n)
    
    imagesc(time_LRL,rot90(flipud(frequencies_of_interest),-1),meanLRLsignal(:,:,channel_n))
    hold on;
    set(gca,'YDir','normal')
    hold on;
    vline(time_LRL(event_position_in_LRL(event_labels_in_LRL == 'left')), '--g', 'L')
    hold on;
    vline(time_LRL(event_position_in_LRL(event_labels_in_LRL == 'right')) , '--r', 'R')
    hold on;
    vline(time_LRL(event_position_in_LRL(event_labels_in_LRL == 'start')), '-.p', 's')
    hold on;
    title([channel_labels(channel_n)]);
    xlabel('Time [s]');
    ylabel('Frequency');
    hold on;
    colorbar;
    caxis([-20 20]);
    hold off;
   
    
end