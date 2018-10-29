% DataSessionVisualisation
channels_nb = 16;
frequencies_of_interest = [4:0.1:40];
mean_signal = mean(signal_Session,4);
fig = figure;
time = [1:1:size(signal_Session,2)];

for j = 1:channels_nb
    
    figure(fig);
    set(fig,'Name',['Frequency vs Time ' subject ' ' sessionname],'NumberTitle','off')
    subplot(sqrt(channels_nb),sqrt(channels_nb),j)
    imagesc(time,rot90(flipud(frequencies_of_interest),-1),mean_signal(:,:,j))
    hold on;
    set(gca,'YDir','normal')
    hold on;
    vline(time(events.position(events.labels == 'left')), '--g', 'L')
    hold on;
    vline(time(events.position(events.labels == 'right')) , '--r', 'R')
    hold on;
    vline(time(events.position(events.labels == 'start')), '-.p', 's')
    hold on;
    title([run.outputdata.channel_label(j)]);
    xlabel('Time');
    ylabel('Frequency');
    hold on;
    colorbar;
    caxis([-2 2]);
    hold off;
    
end