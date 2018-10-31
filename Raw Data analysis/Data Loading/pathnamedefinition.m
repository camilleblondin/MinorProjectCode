clc;
clear all;
close all;

MATNAME = 'PathName';
pathname = [];

commonpath = '/Users/camilleblondin/Desktop/MinorProjectCode/BCI_FTW/Data/';
pathname.s01.s3.r1 = [commonpath 's01/session3/s01.20180523.140947.offline.mi.mi_cst.gdf'];
pathname.s02.s3.r1 = [commonpath 's02/session3/s02.20180525.133904.offline.mi.mi_cst.gdf'];
pathname.s02.s2.r1 = [commonpath 's02/session2/s02.20180420.093531.offline.mi.mi_cst.gdf'];

pathname.s03.s3.r1 = [commonpath 's03/session3/s03.20180518.134257.offline.mi.mi_cst.gdf'];
pathname.s03.s3.r2 = [commonpath 's03/session3/s03.20180518.140440.offline.mi.mi_cst.gdf'];
pathname.s04.s3.r1 = [commonpath 's04/session3/s04.20180530.131907.offline.mi.mi_cst.gdf'];
pathname.s05.s3.r1 = [commonpath 's05/session3/s05.20180525.162339.offline.mi.mi_cst.gdf'];
pathname.s06.s3.r1 = [commonpath 's06/session3/s06.20180530.104249.offline.mi.mi_cst.gdf'];
pathname.s07.s3.r1 = [commonpath 's07/session3/s07.20180523.085317.offline.mi.mi_cst.gdf'];
pathname.s08.s3.r1 = [commonpath 's08/session3/s08.20180518.161224.offline.mi.mi_cst.gdf'];
pathname.s09.s3.r1 = [commonpath 's09/session3/s09.20180523.112129.offline.mi.mi_cst.gdf'];

save([MATNAME '.mat'],'pathname');
load([MATNAME '.mat'], 'pathname');
