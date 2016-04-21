function [f] = extractGrayScaleFeatures(image, nrBins)
%extractGrayScaleFeatures Extract gray-level features

nrPixels = size(image, 1) * size(image, 2);
[f, ~] = histcounts(image, nrBins);
f = f / nrPixels;
end

