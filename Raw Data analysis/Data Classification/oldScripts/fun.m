function [criterion ] = fun(xT,yT,xt,yt,classifiertype)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   

%trainingResponse = yT;
%trainingPredictors = xT;


Mdl = callmyclassifier2(classifiertype,trainingPredictors, ...
        trainingResponse);
    
criterion = length(yt)*getclasserror(yt,predict(Mdl,xt));


end

