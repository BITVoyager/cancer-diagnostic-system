clear;
clc;
close all;

%% select input directory
inputDir = uigetdir('C:\Users\Yao\Documents\Data\TCGA', 'Select Input Folder');
imageDir = dir([inputDir '\*.png']);
features = [];
for k = 1:1:size(imageDir, 1)
    disp(['Processing Image ' num2str(k) '...']);
    features = [features; extractAddFeatures([inputDir '\' imageDir(k).name])];
end
matFilename = fullfile([inputDir '\addfeatures.mat']);
save(matFilename, 'features');