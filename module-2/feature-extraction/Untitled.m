clear;
clc;
close all;

%% select input directory
inputDirPre = 'C:\Users\Yao\Documents\Data\TCGA\Dataset3\training\' ;

%features = zeros(size(imageDir, 1), 1031);
for idx = 1:4
    switch idx
        case 1
            datasetName = 'C11';
        case 2
            datasetName = 'C12';
        case 3
            datasetName = 'C21';
        case 4
            datasetName = 'C22';
    end
    disp(['Processing ' datasetName '...']);
    
    inputDir = [inputDirPre datasetName];    
    imageDir = dir([inputDir '\*.png']);
    for ss = 1:2:15
        features = [];
        for k = ss:16:size(imageDir, 1)
            disp(['Processing the ' num2str(ss) ' th image of patient ' imageDir(k).name(6:12) '...']);
            features = [features; extractFeatures([inputDir '\' imageDir(k).name])];
        end
        matFilename = fullfile([inputDir '\features' num2str(ss) '.mat']);
        save(matFilename, 'features');
        fprintf('\n');
    end
    fprintf('\n');
end

