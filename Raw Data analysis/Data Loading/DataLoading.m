
% Data Loading loads the data from the gdf file 
% It is also the place to name the output data!!

gdf_file_path = pathname.s02.s2.r1;
outputdata.filename = gdf_file_path;

newname = 's02s2r1';
rawdata = [];

load_data(gdf_file_path,newname,rawdata);
load([newname '_rawData.mat'], 'rawdata');

