function [] = FT_subplot(time,frequencies_of_interest,event_position,event_labels,signal,fig,figurename,channel_label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
subplotsize = sqrt(length(channel_label));
figure(fig);
    set(fig,'Name',figurename,'NumberTitle','off')
    subplot(subplotsize,subplotsize,j)
    imagesc(time,rot90(flipud(frequencies_of_interest),-1),signal)
    hold on;
    set(gca,'YDir','normal')
    hold on;
    vline(time(event_position(event_labels == 'left')), '--g', 'L')
    hold on;
    vline(time(event_position(event_labels == 'right')) , '--r', 'R')
    hold on;
    vline(time(event_position(event_labels == 'start')), '-.p', 's')
    hold on;
    title([channel_label(j)]);
    xlabel('Time [s]');
    ylabel('Frequency');
    hold on;
    colorbar;
    caxis([-2 2]);
    hold off;
end

