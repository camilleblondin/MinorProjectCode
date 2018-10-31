% DataPSDExtraction gets the psd of the filtered signal using the
% spectrogram function. the event for the psd signal are also extracted to
% match the new dimension of the signal
% Both psd signal, and events (time,position, labels) are stored in the
% structure

%% Parameters
% samplingfreq = 512; 
% desiredwindowduration = 0.5; %seconds
% delay = 1/samplingfreq;
% delay2 = 1/16;
% 
% window = desiredwindowduration/delay;
% overlap = (desiredwindowduration - delay2)*samplingfreq;
% freq_of_interest = rawdata.frequencies_of_interest;
% nb_of_channels = 16;
% %%
% time = [];
% rawdata.psd.signal = [];
% 
% for i =1: nb_of_channels
%     [~,~,psdtime,psdsignal] = spectrogram(rawdata.CARsignal(:,i),window,overlap,freq_of_interest,samplingfreq);
%     rawdata.psd.signal(:,:,i) = psdsignal;
% end


[PsdData] = getPSDforallchannels(rawdata.CARsignal,rawdata.frequencies_of_interest)

rawdata.psd.signal = PsdData.data;
rawdata.psd.time = PsdData.time;

%% Get Event for the PSD signal

% As the dimension of the psd signal is not the same as the original signal, we
% also need to adapt the position of the events
rawdata.psd.events.type = rawdata.events.type;
rawdata.psd.events.labels = rawdata.events.labels;

%%
event_time_original = rawdata.events.time;
event_position_psd= [];
for i = 1:length(event_time_original)
    event_position_psd = [event_position_psd;find(rawdata.psd.time >= event_time_original(i),1)];
end
% mean(psdtime(event_position_psd)-event_time_original) % to verify if
% needed that the difference is not too big

rawdata.psd.events.position = event_position_psd;
rawdata.psd.events.time = rawdata.psd.time(event_position_psd);
%%