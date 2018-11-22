%Feature Map
clc;
clear all;
close all;
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis');
addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');
%%
dataset = load('s02s3r1_OutPutStruct');

signalLRL = dataset.outputdata.psd.LRL.signal;
channels = dataset.outputdata.channel_label;
WindowDuration = 0.0625;
WindowOfInterest = 0.8;
nbfreq = size(signalLRL,1);
nbchannels= length(channels);

orderedPowerperChannel = zeros(nbchannels,nbfreq);
for channel_i=1:nbchannels
datachannel = struct('signal',[],'event',[],'channelLabel',[]);
datachannel.signal = signalLRL(:,:,:,channel_i);
datachannel.event = dataset.outputdata.psd.LRL.event;
datachannel.channelLabel = channels(channel_i);

[BeforeEventMatLRL,AfterEventMat] = getdataset_general(datachannel,WindowDuration,WindowOfInterest);
obs = BeforeEventMatLRL(2:end,:)';
labels = BeforeEventMatLRL(1,:)';
[orderedInd, orderedPower] = rankfeat(obs, labels,'fisher');

orderedPowerperChannel(channel_i,:) = orderedPower(orderedInd) ;
end

figure()
imagesc(1:nbfreq,1:1:nbchannels,orderedPowerperChannel)
set(gca,'YDir','normal')
colorbar
axis([0 37 1 16]);
caxis([-0 0.2]);
xlabel('frequency [Hz]');
ylabel('Channel # ');
title('Feature Map');


