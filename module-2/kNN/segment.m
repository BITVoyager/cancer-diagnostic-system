clear;
clc;
close all;

%% select an image
[FileName, PathName] = uigetfile('*.png', 'Select an image');
filename = [PathName FileName];
image = imread(filename);
image = im2double(image);

%% set up parameters
mode = '450';
nrNN = 5;
colorSpace = 'RGB';
mapColor = [0, 0, 255; 204, 0, 0; 255 255 255] / 255;

%% segment image and show results
[S, NM, CM] = segmentkNN(image, mode, colorSpace, nrNN);
figure('Name', 'Nuclear Mask');
imshow(NM);

figure('Name', 'Cytoplasm Mask');
imshow(CM);

figure('Name', 'Results');
imshow(S, []), colormap(gcf, mapColor);