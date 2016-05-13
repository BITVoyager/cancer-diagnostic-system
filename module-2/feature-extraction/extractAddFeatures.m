function [f] = extractAddFeatures(filename)
%extractFeatures Extract all features

% create several images
originalColorImage = imread(filename);
normalizedColorImage = normalizeColor(originalColorImage);
p = rgb2gray(normalizedColorImage);

fprintf('Size of all features is %d.\n', size(f, 2));
end

