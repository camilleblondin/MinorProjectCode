
% LOAD the data for one session
%% Precise the files to load
dim = [361,108,16];
%%
frequencies_nb = dim(1) ;
LRL_length = dim(2);
channels_nb = dim(3) ;

signal_Session = zeros(frequencies_nb,LRL_length,channels_nb,length(runs));
run = [];
for r = 1:length(runs)
   run =  load(char(runs(r)));
   LRLsignal_r = run.outputdata.psd.meanoverLRL(1:dim(1),1:dim(2),1:dim(3)) ; 
   signal_Session(:,:,:,r) =   LRLsignal_r ; 
end

events = run.outputdata.psd.LRL.event ;

