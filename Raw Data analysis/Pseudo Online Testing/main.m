% Separate into LRLRLRLR events
% 1 s windows
% normalize??
% Car  filtering
% PSD
% classify
clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis');

%% 
rawdata = load('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data analysis/results/s02s3r1_rawData.mat', 'rawdata')

%% Separate into LRL events

rawsignal = rawdata.rawdata.signal;
filteredsignal = applyCAR(rawsignal(:,1:16));
events = rawdata.rawdata.events;
baselinepos = events.position(find(events.labels == 'baseline')); 
firstleftevent_ind = find(events.labels == 'baseline')+1;
firstLeftEvents_pos = events.position(firstleftevent_ind);
lasttrialevent_ind = find(events.labels == 'START trial');
lasttrialevent_ind = lasttrialevent_ind(2:end)-1 ;
lasttrialeventpos = events.position(lasttrialevent_ind );

event_trial_position  = [];
event_trial_labels = [];
pre_processed_signal = [];
event_trial_time = [];
%%
L = 1;
for trial_i = 1:length(firstLeftEvents_pos)
    baseline_trial = filteredsignal(baselinepos(trial_i):firstLeftEvents_pos(trial_i),:);
    
    event_trial_position  = [event_trial_position ; events.position(firstleftevent_ind(trial_i):(lasttrialevent_ind(trial_i)))- firstLeftEvents_pos(trial_i)+L] ;
    event_trial_labels  = [event_trial_labels ; events.labels(firstleftevent_ind(trial_i):lasttrialevent_ind(trial_i))];
    event_trial_time = [event_trial_time;  events.time(firstleftevent_ind(trial_i):lasttrialevent_ind(trial_i )) ]; 
    
    L = event_trial_position(end)+1; 
    signaltrial = filteredsignal(firstLeftEvents_pos(trial_i):lasttrialeventpos(trial_i),:);
    %signaltrial =  (log(signaltrial) - mean(log(baseline_trial),1));
    pre_processed_signal = [pre_processed_signal; signaltrial];    

end

%% Plot

figure();
plot(pre_processed_signal(:,1));
hold on;
vline(event_trial_position(event_trial_labels == 'left'), '--g', 'L')
hold on;
vline(event_trial_position(event_trial_labels == 'right'), '--r', 'R')
hold on;
title('Timing of the events during one run');
hold on;
xlabel('time [s]');
hold on;
ylabel('Pre processed signal');
%% Model Training
% % Load Data
WindowDuration = 0.0625;
WindowOfInterest = 0.8;
dataset = load('s02s3r1_OutPutStruct.mat');
% % Get Feature Set
[BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);

obstrain = BeforeEventMatLRL(2:end,:)';
grptrain = BeforeEventMatLRL(1, :)';
xT = obstrain;
yT = grptrain;

classificationKNN = fitcknn(...
    xT, ...
    yT, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

 [YP, X0E, MPRED] = predict(classificationKNN,xT);
 classerrortrain = getclasserror(yT,YP)

%% Window 
analysis_window_duration = 0.5 + 2/16; % in seconds
analysis_window_length = analysis_window_duration*512; % in seconds
freq_of_interest = [4:1:40];

%for 1:analysis_window_length :size(pre_processed_signal,1)
windowdata = pre_processed_signal(1:analysis_window_length,:);

[PSDdata] = getPSDforallchannels(windowdata,freq_of_interest); % should do it with pWelch instead

newdataset = [];

for c = 1:size(PSDdata.data,3)
    
   newwindowdataset = [newwindowdataset; PSDdata.data(:,:,c)]; 
    
end

%figure();
%imagesc(PSDdata.time,rot90(flipud(freq_of_interest)),PSDdata.data(:,:,1));

%% Prediction on each single window
 [YPw, X0Ew, MPREDw] = predict(classificationKNN,newwindowdataset');
