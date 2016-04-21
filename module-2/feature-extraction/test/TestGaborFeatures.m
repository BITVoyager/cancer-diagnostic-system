clear;
clc;
close all;

addpath ../

%% load image
[filename, imageDir] = uigetfile('C:\Users\Yao\Documents\Data\ECE6780\*.png', 'Select the image file');
image = imread([imageDir filename]);

image = im2double(rgb2gray(image));

%% prepare input data
tic;
orientation = [0 45 90 135];
wavelength = 1 ./ [sqrt(2)/256 sqrt(2)/128 sqrt(2)/64 sqrt(2)/32 ...
                  sqrt(2)/16 sqrt(2)/8 sqrt(2)/4];
           
%% calculate all features  
nrOrientations = size(orientation, 2);
nrWaveLength = size(wavelength, 2);
f = zeros(nrOrientations*nrWaveLength, 2);

for i = 1:nrOrientations
    for j = 1:nrWaveLength
        [mag, ~] = imgaborfilt(image, wavelength(1, j), orientation(1, i));
        idx = (i - 1) * nrWaveLength + j;
        f(idx, 1) = subMatrixEntropy(mag);
        f(idx, 2) = subMatrixEnergy(mag);
    end
end

f(:, 2) = f(:, 2) / 1e7;
%f = f(:)';
toc
