clear;
clc;
close all;

addpath ../kNN

%% select an image
[FileName, PathName] = uigetfile('*.png', 'Select an image');
filename = [PathName FileName];
tic;
originalImage = imread(filename);
image = im2double(originalImage);

%% set up parameters
mode = '450';
nrNN = 5;
colorSpace = 'RGB';
mapColor = [0, 0, 255; 204, 0, 0; 255 255 255] / 255;

%% segment image and show results
[S, NM, CM] = segmentkNN(image, mode, colorSpace, nrNN);
% figure('Name', 'Nuclear Mask');
% imshow(NM);
% 
% figure('Name', 'Cytoplasm Mask');
% imshow(CM);
% 
% figure('Name', 'Results');
% imshow(S, []), colormap(gcf, mapColor);

%% run the exe file and import data
paraList = 'nuclearMask.jpg 0 1 10.0 20000.0 0';
system(['NuclearShapeFeatureExtraction.exe ', paraList]);

features = importdata('features.txt');
tempContours = dlmread('contours.txt');
tempContourCenters = dlmread('centers.txt');

%% convert the results into readable format
contourCenters = reshape(tempContourCenters, 2, [])';
contours = cell(size(features, 1), 1);
for j = 1:size(features, 1)
    tempPts = tempContours(j, :);
    pts = zeros(round(tempPts(1)), 2);
    for k = 1:round(tempPts(1))
        pts(k, :) = [tempPts(2 * k) tempPts(2 * k + 1)];
    end
    contours(j, 1) = {pts};
end

toc

%% calculate the fourier shape descriptors
fdfs = zeros(size(features, 1), 80);
for k = 1:size(features, 1)
    fd = fEfourier(contours{k, 1}, 20, 1, 0);
    fdfs(k, :) = reshape(fd', 1, []);
end
features = [features fdfs];

%% calculate all statistics of shape features
% 1: mean
tempMean = mean(features, 1);

% 2: std
tempStd = std(features, 1);

% 3: min
[tempMin, ~] = min(features);

% 4: max
[tempMax, ~] = max(features);

% 5: median
tempMedian = median(features, 1);

% 6: inter-quartile range
tempIqr= iqr(features, 1);

% 7: skewness
tempSkewness = skewness(features);

% 8: kurtosis
tempKurtosis = kurtosis(features);

shapeFeatures = [tempMean; tempStd; tempMin; tempMax; tempMedian; tempIqr; tempSkewness; tempKurtosis];
shapeFeatures = reshape(shapeFeatures', 1, []);

%% calculate the histogram
R = originalImage(:, :, 1);
G = originalImage(:, :, 2);
B = originalImage(:, :, 3);
nrPixels = size(R, 1) * size(R, 2);
[histR, ~] = histcounts(R, 16);
[histG, ~] = histcounts(G, 16);
[histB, ~] = histcounts(B, 16);
histR = histR / nrPixels;
histG = histG / nrPixels;
histB = histB / nrPixels;
histoFeatures = [histR histG histB];

%% calculate the texture features



