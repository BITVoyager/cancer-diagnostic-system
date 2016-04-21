clear;
clc;
close all;

%% select input directory
inputDir = uigetdir('C:\Users\Yao\Documents\Data\TCGA', 'Select Input Folder');
imageDir = dir([inputDir '\*.png']);
%features = zeros(size(imageDir, 1), 1031);
features = [];
for k = 4:16:size(imageDir, 1)
    disp(['Processing Image ' num2str(k) '...']);
    features = [features; extractFeatures([inputDir '\' imageDir(k).name])];
end
matFilename = fullfile([inputDir '\features4.mat']);
save(matFilename, 'features');