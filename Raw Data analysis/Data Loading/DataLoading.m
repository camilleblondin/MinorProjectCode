
% Data Loading loads the data from the gdf file 
% It is also the place to name the output data!!

gdf_file_path = pathname.s03.s3.r1;
outputdata.filename = gdf_file_path;

newname = 's03s3r1';
rawdata = [];

load_data(gdf_file_path,newname,rawdata);
load([newname '_rawData.mat'], 'rawdata');

