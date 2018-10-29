% Plots with SpectrogramDisplayer
addpath('/Users/camilleblondin/Desktop/MinorProject/CodeSpectrogramDisplayer');

S = SpectrogramDisplayer();
figure()
plotAllChannels(S, outputdata.psd.LRL.mean, outputdata.psd.LRL.properties, channel_labels)

%%
figure()
plotAllChannelsWithEvents(S, outputdata.psd.LRL.mean, outputdata.psd.LRL.properties, channel_labels, outputdata.psd.LRL.event.position  , outputdata.psd.LRL.event.labels  , outputdata.psd.LRL.event.labels);