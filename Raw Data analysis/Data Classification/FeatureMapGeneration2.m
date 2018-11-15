%Feature Map % Not sure this one is usable

% % clc;
% % clear all;
% % close all;
% % addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis');
% % addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Classification Model Construction');
% % %%
% % dataset = load('s02s3r1_OutPutStruct');
% % 
% % signalLRL = dataset.outputdata.psd.LRL.signal;
% % channels = dataset.outputdata.channel_label;
% % WindowDuration = 0.0625;
% % WindowOfInterest = 0.8;
% % nbfreq = size(signalLRL,1);
% % nbchannels= length(channels);
% % 
% % orderedPowerperChannel = zeros(nbchannels,nbfreq);
% % [BeforeEventMatLRL,AfterEventMat] = getdataset(dataset,WindowDuration,WindowOfInterest);
% % obs = BeforeEventMatLRL(2:end,:)';
% % labels = BeforeEventMatLRL(1,:)';
% % [orderedInd, orderedPower] = rankfeat(obs, labels,'fisher');
% % start=1;
% % end_ind = 0;
% % for channel_i=1:nbchannels
% % start
% % end_ind = end_ind + nbfreq
% % orderedPowerperChannel(channel_i,:) = orderedPower(start:end_ind);
% % start = end_ind +1;
% % end
% % 
% % figure()
% % imagesc(1:nbfreq,1:1:nbchannels,orderedPowerperChannel)
% % set(gca,'YDir','normal')
% % colorbar
% % caxis([-0 0.1]);
% % xlabel('frequency [Hz]');
% % ylabel('Channel # ');
% % title('Feature Map');
% % 
