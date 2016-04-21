clear;
clc;
close all;

inputDirPre = 'C:\Users\Yao\Documents\Data\TCGA\Dataset3\training\' ;

for classIdx = 1:4
    switch classIdx
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
    features = [];
    inputDir = [inputDirPre datasetName];   
    ttt = dir([inputDir '\*.png']);
    for j = 1:size(ttt, 1)/16
        fprintf('\t Processing Patient %d...\n', j);
        for k = 1:16
            temp = load([inputDir '\features' num2str(k) '.mat']);
            C = temp.features;
            features = [features; C(j, :)];
            fprintf('\t \t Adding features from image %d...\n', k);
        end
    end
    matFilename = fullfile([inputDir '\' datasetName '.mat']);
    save(matFilename, 'features');
    fprintf('\n');
end