%% This file can be used to rename all files in data set 3 
clear;
clc;
close all;

%% rename filenames 
imageDir = dir('C:\Users\Yao\Documents\Data\ECE6780\Dataset3\PAAD_Tumor\*.png');
path = 'C:\Users\Yao\Documents\Data\ECE6780\Dataset3\PAAD_Tumor\';
for j = 1:size(imageDir, 1)
    tempFilename = imageDir(j).name;
    k = mod(j, 16);
    if k == 0
        k = 16;
    end
    filename = [tempFilename(1, 1:13) num2str(k) '.png'];
    movefile([path tempFilename], ['C:\Users\Yao\Documents\Data\ECE6780\Dataset4\PAAD_Tumor\' filename]);
end