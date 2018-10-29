function load_data(gdf_file_path,newname,rawdata)
%load_data load the data from a gdf file and store it in a new structure of
%name 'newname'

[signal,headers] = sload(gdf_file_path);

%rawdata = [];
MAT_NAME = newname;

rawdata.events.type = headers.EVENT.TYP;
rawdata.events.position = headers.EVENT.POS;
rawdata.signal = signal;
rawdata.samplerate = headers.EVENT.SampleRate;
rawdata.time = [1:1:length(signal)]./rawdata.samplerate;
rawdata.events.time = rawdata.time(rawdata.events.position);

save([MAT_NAME '_rawData.mat'],'rawdata');
%load([newname '_rawData.mat'], 'rawdata');
end

