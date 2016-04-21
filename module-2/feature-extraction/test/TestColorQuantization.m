clear;
clc;
close all;

addpath ..\

%% load an image
[filename, imageDir] = uigetfile('C:\Users\Yao\Documents\Data\ECE6780\*.png', 'Select the image file');
image = imread([imageDir filename]);

%% apply SOM to quantize the image
tic;
method = 'SOM';
image = im2double(image);

rows = size(image, 1);
cols = size(image, 2);

X = reshape(image, rows*cols, 3)';

if strcmp(method, 'SOM')
    x = X(:, randperm(rows*cols, 5000));
    net = selforgmap([1 64], 'topologyFcn', 'gridtop');
    net.trainParam.showWindow = 0;
    net = train(net, x);

    % output
    y = net(X);
    classes = vec2ind(y);
    quantizedImage = reshape(classes, rows, []);
    
elseif strcmp(method, 'KMeans')
    Options.MaxIter = 1000;
    [IDX, C] = kmeans(X', 64, 'options', Options);
    quantizedImage = reshape(IDX, size(image, 1), size(image, 2));
    
elseif strcmp(method, 'FCM')
    [C, U] = fcm(X', 64);
    [MaxU, IDX] = max(U);
    quantizedImage = reshape(IDX, size(image, 1), size(image, 2));
else
    
end
toc

%GCT1 = extractHaralickFeatures(quantizedImage, 64);
nrLevels = 64;
offset = [0 1; -1 1; -1 0; -1 -1; 1 0; 1 -1; 0 -1; 1 1];
nrDirs = size(offset, 1);
glcms = graycomatrix(quantizedImage/64, 'NumLevels', nrLevels, 'Offset', offset);

%% show result
figure(1);
imshow(image);
title('Original Image');

figure(2);
imshow(quantizedImage, []);
title('Quantized Image');