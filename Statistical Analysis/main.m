% main
clc;
clear all;
close all;

addpath('/Users/camilleblondin/Desktop/MinorProjectCode/EEGDataAnalysis/Raw Data analysis/results');
[BeforeEventMat,AftereventMAT ] = getdataset2('s02s3r1_OutPutStruct.mat',0.0625,1);


% %% ttest
% addpath('/Users/camilleblondin/Desktop/MinorProject/CodeSpectrogramDisplayer/statistics');
% BeforeEventClassLabel = BeforeEventMat(1,:);
% group1 = BeforeEventMat(1:end,find(BeforeEventClassLabel==0));
% group2 = BeforeEventMat(1:end,find(BeforeEventClassLabel==1));
% testType = 'ttest';
% label1 = 'Classe 0';
% label2 = 'Classe 1';
% verbose = false;
% S_ind= [];
% 
% for j = 1:size(group2,2)
%     for i = 1:size(group1,2)
%         [meanDiff, pvalue, rejectedHypothesis] = testSignificance(group1(:,i), group2(:,j), testType, label1, label2, verbose);
%     
%         if rejectedHypothesis == 1
%             
%             S_ind = [S_ind,[i ;j]];
%             
%         end
%     
%     end
% end