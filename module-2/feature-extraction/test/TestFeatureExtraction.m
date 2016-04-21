clear;
clc;
close all;

addpath ..\

[filename, imageDir] = uigetfile('C:\Users\Yao\Documents\Data\TCGA\*.png', 'Select the image file');
tic;
f = extractFeatures([imageDir filename]);
toc