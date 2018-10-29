%% EventsPlot

%% Timing of event is plotted for the original signal
type_of_event = rawdata.events.type;
event_time = rawdata.events.time;
event_labels = rawdata.events.labels ;
time = rawdata.time;
figure();
plot(time,rawdata.signal(:,1));
hold on;
vline(event_time(event_labels == 'left'), '--g', 'L')
hold on;
vline(event_time(event_labels == 'right'), '--r', 'R')
hold on;
vline(event_time(event_labels == 'START trial'), '-b', 'S')
hold on;
vline(event_time(event_labels == 'baseline'), '-.p', 'b')
title('Timing of the events during one run');
hold on;
xlabel('time [s]');
hold on;
ylabel('raw signal');

%% Timing of event is plotted for the psd signal
type_of_event = rawdata.psd.events.type;
event_time = rawdata.psd.events.time;
event_labels = rawdata.psd.events.labels ;
time = rawdata.psd.time;

figure();
plot(time,rawdata.psd.signal(1,:,1));
hold on;
vline(event_time(event_labels == 'left'), '--g', 'L')
hold on;
vline(event_time(event_labels == 'right'), '--r', 'R')
hold on;
vline(event_time(event_labels == 'START trial'), '-b', 'S')
hold on;
vline(event_time(event_labels == 'baseline'), '-.p', 'b')
title('Timing of the events during one run');
hold on;
xlabel('time [s]');
hold on;
ylabel('signal');
hold off;
