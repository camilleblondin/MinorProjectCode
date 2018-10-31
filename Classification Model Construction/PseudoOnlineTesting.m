% Pseudo Online Testing
clc;
clear all;
close all;

%% 1 Load data
load('s02s3r1_rawData.mat'); % load data set
load('TRainedModelKnn.mat'); % load classification model 
%% 2 train Classifier we will use with training data
WindowDuration = 0.2;
WindowOfInterest = 0.8;
dataset = load('s02s3r1_OutPutStruct.mat');
[EventMatLRL] = getdatasetLRL(dataset,WindowDuration,WindowOfInterest);
[trainedClassifier, validationAccuracy] = trainClassifierKnn(EventMatLRL);

%% 3 testing data 
channel_nb = 16;
TestRawData = rawdata.signal(:,1:channel_nb);
TestRawDataPsd = rawdata.psd.signal;
events = rawdata.psd.events;

%% 4 testing data - labelling
[DataSet] = getSignalLabelling(TestRawDataPsd,events,WindowDuration,WindowOfInterest);

%% 5 From testing data take only a small window and process and predict the labels with the classifier
 % TestData Window
 % TestData Window Preprocessing
 % TestData Window Prediction
freq_of_interest = rawdata.frequencies_of_interest;

%[~,~,psdtime,psdsignal] = spectrogram(TestRawData(1:(256+32),1),window,overlap,freq_of_interest,samplingfreq);

int = (256+32);
yFITfinal = [];

for i = 1:int:size(TestRawData,1)-int
[PSDdata] = getPSDforallchannels(TestRawData(i:i+int,:),freq_of_interest);
testingDataWindow = reshape(permute(PSDdata.data,[2,1,3]),size(PSDdata.data,2),[])';
yfit = trainedClassifier.predictFcn(testingDataWindow);
yFITfinal = [yFITfinal; yfit];

end
%% 6 Performance calculation


