%DataPreprocessing

%Spacial filtering using CAR (common average reference)

%% now we apply a spacial filter using common average reference (CAR) 
rawdata.CARsignal = applyCAR(rawdata.signal(:,1:16));

figure()
plot(rawdata.signal(:,1));
hold on;
plot(rawdata.CARsignal(:,1));
legend('raw signal','filtered signal ');
title('Signal before and after spacial filtering by CAR');