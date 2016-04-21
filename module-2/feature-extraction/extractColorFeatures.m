function [f] = extractColorFeatures(image, nrBins)
%extractColorFeatures Extract color features

R = image(:, :, 1);
G = image(:, :, 2);
B = image(:, :, 3);

nrPixels = size(R, 1) * size(R, 2);

[histR, ~] = histcounts(R, nrBins);
[histG, ~] = histcounts(G, nrBins);
[histB, ~] = histcounts(B, nrBins);

histR = histR / nrPixels;
histG = histG / nrPixels;
histB = histB / nrPixels;

f = [histR histG histB];
end

