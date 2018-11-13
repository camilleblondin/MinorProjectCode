function [ClassError] = getclasserror(data_label,data_prediction)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
CM_test = confusionmat(data_label,data_prediction);
ClassError = 0.5*CM_test(1,2)/sum(CM_test(1,:)) + 0.5*CM_test(2,1)/sum(CM_test(2,:));
end

