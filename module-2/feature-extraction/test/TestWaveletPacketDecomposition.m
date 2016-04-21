clear;
clc;
close all;

addpath ../

%% load image
[filename, imageDir] = uigetfile('C:\Users\Yao\Documents\Data\ECE6780\*.png', 'Select the image file');
image = im2double(imread([imageDir filename]));
image = rgb2gray(image);

tic;
T1 = wpdec2(image, 3, 'db6', 'shannon');
T2 = wpdec2(image, 3, 'db20', 'shannon');

data1 = read(T1, 'data', (21:84)');
data2 = read(T2, 'data', (21:84)');

f1 = zeros(64, 2);
f2 = zeros(64, 2);

for k = 1:64
    subMat1 = data1{1, k};
    f1(k, 1) = subMatrixEntropy(subMat1);
    f1(k, 2) = subMatrixEnergy(subMat1);
    
    subMat2 = data2{1, k};
    f2(k, 1) = subMatrixEntropy(subMat2);
    f2(k, 2) = subMatrixEnergy(subMat2);
end

% f1 = f1(:);
% f2 = f2(:);
% f = [f1' f2'];
toc