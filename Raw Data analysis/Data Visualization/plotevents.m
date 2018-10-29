function  [] = plotevents(event_time,event_labels,delay,events2plot)
color = {'--g','-b','-.p','--r','-g','--b','-r'};

for event_i = 1:length(events2plot)
    vline(event_time(event_labels == events2plot(event_i)) - delay, color(event_i), events2plot(event_i))
    hold on;
end
        
end

