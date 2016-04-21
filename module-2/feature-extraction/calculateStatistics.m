function [f] = calculateStatistics(src)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% calculate all statistics of shape features
% 1: mean
tempMean = mean(src);

% 2: std
tempStd = std(src);

% 3: min
[tempMin, ~] = min(src);

% 4: max
[tempMax, ~] = max(src);

% 5: median
tempMedian = median(src);

% 6: inter-quartile range
tempIqr = iqr(src);

% 7: skewness
tempSkewness = skewness(src);

% 8: kurtosis
tempKurtosis = kurtosis(src);

f = [tempMean tempStd tempMin tempMax tempMedian tempIqr];

end

