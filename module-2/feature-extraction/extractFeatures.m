function [f] = extractFeatures(filename)
%extractFeatures Extract all features

% create several images
originalColorImage = imread(filename);
normalizedColorImage = normalizeColor(originalColorImage);
quantizedColorImage = quantizeColor(originalColorImage);
grayScaleImage = rgb2gray(normalizedColorImage);

% GC
GC = extractColorFeatures(normalizedColorImage, 16);

% GT
GT1 = extractHaralickFeatures(grayScaleImage, 8);
GT2 = extractGaborFeatures(grayScaleImage);
GT3 = extractWaveletPacketFeatures(grayScaleImage);
GT4 = extractGrayScaleFeatures(grayScaleImage, 64);
GT = [GT1 GT2 GT3 GT4];

% GCT
quantizedColorImage = im2uint8(quantizedColorImage / 64);
GCT1 = extractHaralickFeatures(quantizedColorImage, 64);
GCT2 = extractGaborFeatures(quantizedColorImage);
GCT3 = extractWaveletPacketFeatures(quantizedColorImage);
GCT = [GCT1 GCT2 GCT3];

% NM
[fs, ft, fte] = extractNuclearFeatures(normalizedColorImage);
NM = [fs ft fte];

f = [GC GT GCT NM];
end

