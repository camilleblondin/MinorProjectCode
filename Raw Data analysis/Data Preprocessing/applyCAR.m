function [CARsignal] = applyCAR(signal)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
CARsignal =  signal - mean(signal,2) ;

end

