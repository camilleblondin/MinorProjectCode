function [ClassificationError] = getclassificationerror(data_label,data_prediction)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
CM_test = confusionmat(data_label,data_prediction);
ClassificationError = (CM_test(1,2)+CM_test(2,1))/sum(sum(CM_test));
end

