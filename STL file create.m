clc; clear all; close all;

FILES = dir("*.stl");
FILE1 = stlread(FILES(1).name);
FILE2 = stlread(FILES(2).name);

save('STL.mat');