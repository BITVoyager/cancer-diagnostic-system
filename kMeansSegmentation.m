function [clusterMap] = kMeansSegmentation(filename, initCenters)
%kMeansSegmentation Summary of this function goes here
%   Detailed explanation goes here

% load image
image = imread(filename);
image = im2double(image); % convert the original image from uint8 to double

% set up parameters
threshold  = 0.0;                 % threshold for turminating the loop 
[rows, cols, ~] = size(image);    % get image size
nrCenters = size(initCenters, 2); % number of clusters
clusterMap = zeros(rows, cols);  
centers = initCenters;

% loop until convergence
while(1)
    % calculate the nearest center which a certain pixel belongs to
    for r = 1:rows
        for c = 1:cols
            distance = zeros(nrCenters, 1); % distance between two points in feature space
            point = [image(r, c, 1); image(r, c, 2); image(r, c, 3)]; % a point in feature space
            for k = 1:nrCenters
                distance(k, 1) = norm(centers(:, k) - point);
            end
            [~, minIdx] = min(distance(:)); % find the nearest center
            clusterMap(r, c) = minIdx;      % assign the index of the nearest cluster
        end
    end

    % calculate the new center for each cluster
    newCenters = zeros(size(centers)); % new centers
    counter = zeros(1, nrCenters);     % count how many points are in one cluster
    for r = 1:rows
        for c = 1:cols
            clusterIdx = clusterMap(r, c);
            point = [image(r, c, 1); image(r, c, 2); image(r, c, 3)];  
            newCenters(:, clusterIdx) = newCenters(:, clusterIdx) + point;
            counter(1, clusterIdx) = counter(1, clusterIdx) + 1;
        end
    end
    % calculate the new center for each cluster by taking the mean value
    for k = 1:nrCenters
        newCenters(:, k) = newCenters(:, k) / counter(1, k);
    end

    % check whether the loop should be terminated (meet the convergence criteria)
    difference = 0;
    for k = 1:nrCenters
        tempDiffVec = newCenters(:, k) - centers(:, k);
        difference = difference + norm(tempDiffVec);
    end
    if difference == threshold
        break;
    else
        centers = newCenters;
    end
end

end

