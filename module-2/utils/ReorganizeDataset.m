clear;
clc;
close all;

%% select input and output folders
inputDir = uigetdir('C:\Users\Yao\Documents\Data', 'Select Input Folder');
outputDir = uigetdir('C:\Users\Yao\Documents\Data', 'Select Output Folder');

%% create directories of each dataset
dataset1InputDir = [inputDir '\Dataset1'];
dataset2InputDir = [inputDir '\Dataset2'];
dataset3InputDir = [inputDir '\Dataset3'];

dataset1OutputDir = [outputDir '\Dataset1'];
dataset2OutputDir = [outputDir '\Dataset2'];
dataset3OutputDir = [outputDir '\Dataset3'];

%% delete all previous files in the output folder
if ~exist(dataset1OutputDir, 'dir')
    mkdir(dataset1OutputDir);
else
    rmdir(dataset1OutputDir, 's');
end

if ~exist(dataset2OutputDir, 'dir')
    mkdir(dataset2OutputDir);
else
    rmdir(dataset2OutputDir, 's');
end

if ~exist(dataset3OutputDir, 'dir')
    mkdir(dataset3OutputDir);
else
    rmdir(dataset3OutputDir, 's');
end

%% select 60 images for training and 40 images for testing in dataset 1
N = 60;

trainingNecrosisIdx = randperm(100, N);
trainingStromaIdx = randperm(100, N);
trainingTumorIdx = randperm(100, N);

testingNecrosisIdx = setdiff(1:100, trainingNecrosisIdx);
testingStromaIdx = setdiff(1:100, trainingStromaIdx);
testingTumorIdx = setdiff(1:100, trainingTumorIdx);

trainingDirNecrosis = [dataset1OutputDir '\training\Necrosis'];
trainingDirStroma = [dataset1OutputDir '\training\Stroma'];
trainingDirTumor = [dataset1OutputDir '\training\Tumor'];
mkdir(trainingDirNecrosis);
mkdir(trainingDirStroma);
mkdir(trainingDirTumor);

testingDir = [dataset1OutputDir '\testing'];
mkdir(testingDir);

% copy training images
for k = 1:N
    % C1: necrosis
    filenameNecrosis = ['\Necrosis_' num2str(trainingNecrosisIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameNecrosis], [trainingDirNecrosis filenameNecrosis]);
    
    % C2: stroma
    filenameStroma = ['\Stroma_' num2str(trainingStromaIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameStroma], [trainingDirStroma filenameStroma]);
    
    % C3: tumor
    filenameTumor = ['\Tumor_' num2str(trainingTumorIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameTumor], [trainingDirTumor filenameTumor]);        
end

% copy testing images
for k = 1:100-N
    % necrosis
    filenameNecrosis = ['\Necrosis_' num2str(testingNecrosisIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameNecrosis], [testingDir filenameNecrosis]);
    
    % stroma
    filenameStroma = ['\Stroma_' num2str(testingStromaIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameStroma], [testingDir filenameStroma]);
    
    % tumor
    filenameTumor = ['\Tumor_' num2str(testingTumorIdx(k)) '.png'];
    copyfile([dataset1InputDir filenameTumor], [testingDir filenameTumor]);        
end

%% reorganize files in dataset 2
trainingDirC11 = [dataset2OutputDir '\training\C11'];
trainingDirC12 = [dataset2OutputDir '\training\C12'];
trainingDirC21 = [dataset2OutputDir '\training\C21'];
trainingDirC22 = [dataset2OutputDir '\training\C22'];

mkdir(trainingDirC11);
mkdir(trainingDirC12);
mkdir(trainingDirC21);
mkdir(trainingDirC22);

testingDir = [dataset2OutputDir '\testing'];
mkdir(testingDir);

% read information
[num, txt, ~] = xlsread([dataset2InputDir '\KIRC_Training_Set.xlsx']);
imageDir = [dataset2InputDir '\KIRC_Tumor'];

% class 1: binary survival -1
mask11 = num(:, 2) == -1;
mask11 = logical([0; mask11]);
filenameC11 = txt(mask11, 1);
for j = 1:size(filenameC11, 1)
    for k = 1:16
        filename = ['\' filenameC11{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC11 filename]);   
    end
end

% class 2: binary survival 1
mask12 = num(:, 2) == 1;
mask12 = logical([0; mask12]);
filenameC12 = txt(mask12, 1);
for j = 1:size(filenameC12, 1)
    for k = 1:16
        filename = ['\' filenameC12{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC12 filename]);   
    end
end

% class 3: binary grade -1
mask21 = num(:, 4) == -1;
mask21 = logical([0; mask21]);
filenameC21 = txt(mask21, 1);
for j = 1:size(filenameC21, 1)
    for k = 1:16
        filename = ['\' filenameC21{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC21 filename]);   
    end
end

% class 4: binary survival 1 and binary grade 1
mask22 = num(:, 4) == 1;
mask22 = logical([0; mask22]);
filenameC22 = txt(mask22, 1);
for j = 1:size(filenameC22, 1)
    for k = 1:16
        filename = ['\' filenameC22{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC22 filename]);   
    end
end

% move testing images
[~, txt, ~] = xlsread([dataset2InputDir '\KIRC_Testing_Set.xlsx']);
filenameVec = txt(2:end, 1);
for j = 1:size(filenameVec, 1)
    for k = 1:16
        filename = ['\' filenameVec{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [testingDir filename]);   
    end
end

%% reorganize files in dataset 3
trainingDirC11 = [dataset3OutputDir '\training\C11'];
trainingDirC12 = [dataset3OutputDir '\training\C12'];
trainingDirC21 = [dataset3OutputDir '\training\C21'];
trainingDirC22 = [dataset3OutputDir '\training\C22'];

mkdir(trainingDirC11);
mkdir(trainingDirC12);
mkdir(trainingDirC21);
mkdir(trainingDirC22);

testingDir = [dataset3OutputDir '\testing'];
mkdir(testingDir);

% read information
[num, txt, ~] = xlsread([dataset3InputDir '\2016-01-28_selected_pancreatic_train.xlsx']);
imageDir = [dataset3InputDir '\PAAD_Tumor'];

% class 1: binary survival -1
mask11 = num(:, 2) == -1;
mask11 = logical([0; mask11]);
filenameC11 = txt(mask11, 1);
for j = 1:size(filenameC11, 1)
    for k = 1:16
        filename = ['\' filenameC11{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC11 filename]);   
    end
end

% class 2: binary survival 1
mask12 = num(:, 2) == 1;
mask12 = logical([0; mask12]);
filenameC12 = txt(mask12, 1);
for j = 1:size(filenameC12, 1)
    for k = 1:16
        filename = ['\' filenameC12{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC12 filename]);   
    end
end

% class 3: binary grade -1
mask21 = num(:, 4) == -1;
mask21 = logical([0; mask21]);
filenameC21 = txt(mask21, 1);
for j = 1:size(filenameC21, 1)
    for k = 1:16
        filename = ['\' filenameC21{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC21 filename]);   
    end
end

% class 4: binary survival 1 and binary grade 1
mask22 = num(:, 4) == 1;
mask22 = logical([0; mask22]);
filenameC22 = txt(mask22, 1);
for j = 1:size(filenameC22, 1)
    for k = 1:16
        filename = ['\' filenameC22{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [trainingDirC22 filename]);   
    end
end

% move testing images
[~, txt, ~] = xlsread([dataset3InputDir '\2016-01-28_selected_pancreatic_test.xlsx']);
filenameVec = txt(2:end, 1);
for j = 1:size(filenameVec, 1)
    for k = 1:16
        filename = ['\' filenameVec{j, 1} '_' num2str(k) '.png'];  
        copyfile([imageDir filename], [testingDir filename]);   
    end
end



