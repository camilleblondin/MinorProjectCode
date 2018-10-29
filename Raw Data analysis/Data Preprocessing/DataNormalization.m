% DataNormalization, shows how to use the function normalize data


event_position = rawdata.psd.events.position;
event_label = rawdata.psd.events.labels;
data = rawdata.psd.signal_of_allchannels;

normalizedData = normalize_data(data,event_position,event_label);
rawdata.psd.normalized = normalizedData;