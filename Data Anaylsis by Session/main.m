% main
clc;
clear all;
close all;

addpath('/Users/camilleblondin/Desktop/MinorProject/matlab/EEG Data Analysis');

%% Set parameters for DataLoading
sessionname = 'Session3';
subject = 'S03';
runs = {'s03s3r1_OutPutStruct.mat','s03s3r2_OutPutStruct.mat'};
DataSessionLoading; % here you precise the files to load
%%
DataSessionVisualisation
savefig(fig,[subject ,sessionname]);