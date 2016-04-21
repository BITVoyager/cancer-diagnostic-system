clear;
clc;
close all;

addpath ..\kNN
addpath ..\
addpath C:\Users\Yao\Documents\Sandboxes\mexopencv

%% load an image
[filename, imageDir] = uigetfile('C:\Users\Yao\Documents\Data\TCGA\*.png', 'Select the image file');
image = normalizeColor(imread([imageDir filename]));
[~, nuclearMask, ~] = segmentkNN(image, '450', 'RGB', 5);

bw = nuclearMask;
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 4);

%% find contours
tic;
minArea = 4;
maxArea = 20000;
minSize = 5;
[tempContours, hierarchy] = cv.findContours(bw, 'Mode', 'Tree', 'Method', 'None');

%% prune the contours
nrContours = size(tempContours, 2);
contours = {};
cIdx = 0;
for  k = 1:nrContours
    tempContour = tempContours{1, k};
    
    % remove too small regions
    if size(tempContour, 2) < minSize
        continue;
    end
    
    % remove holes
    currNode = hierarchy{1, k};
    if currNode(1, 4) ~= -1 && currNode(1, 3) == -1
        idx = currNode(1, 4);
        parentArea = cv.contourArea(tempContours{1, idx});
        if parentArea < maxArea
            continue;
        end
    end
    
    % filter out too small contours
    currArea = cv.contourArea(tempContour);
    if currArea < maxArea && currArea > minArea
        cIdx = cIdx + 1;
        contours{1, cIdx} = tempContour;       
    end
end


%% calculate shape features
features = zeros(cIdx, 29);
centers = zeros(cIdx, 2);
fs = zeros(1, 216);
if cIdx ~= 0
    for k = 1:cIdx
        % 1: pixel area
        pxArea = cv.contourArea(contours{1, k});
        features(k, 1) = pxArea / 700;

        % 2: convex hull area
        hull = cv.convexHull(contours{1, k});
        chArea = cv.contourArea(hull);
        features(k, 2) = chArea / 800;

        % 3: solicity
        features(k, 3) = pxArea / chArea;

        % 4: perimeter
        perimeter = cv.arcLength(contours{1, k}, 'Closed', true);
        features(k, 4) = perimeter / 250;

        % 5-9: elliptical properties
        rct = cv.fitEllipse(contours{1, k});
        imin = min(rct.size);
        features(k, 5) = imin / 30;

        imax = max(rct.size);
        features(k, 6) = imax / 40;

        eccentric = sqrt(1 - (imin/imax)^2);
        features(k, 7) = eccentric;

        area = pi * imin * imax / 4;
        features(k, 8) = area / 800;

        angle = rct.angle;
        features(k, 9) = angle / 180;
        
        centers(k, :) = rct.center;
        
        % 10-29: RMS error of Fourier shape descriptors
        pts1 = cell2mat(contours{1, k});
        pts = reshape(pts1, 2, [])';
        for j = 1:20
            fd = fEfourier(pts, j, 0, 0);
            pts2 = rEfourier(fd, j, size(pts, 1));
            temp = (pts - pts2).^2;
            RMS = sqrt(sum(temp(:)) / size(pts, 1));
            features(k, 9 + j) = RMS / 15;
        end
    end

    % calculate all statistics of shape features
    % 1: mean
    tempMean = mean(features, 1);

    % 2: std
    tempStd = std(features, 1);

    % 3: min
    [tempMin, ~] = min(features);

    % 4: max
    [tempMax, ~] = max(features);

    % 5: median
    tempMedian = median(features, 1);

    % 6: inter-quartile range
    tempIqr = iqr(features, 1);

    % 7: skewness
    if cIdx < 3
        tempSkewness = 0;
    else
        tempSkewness = skewness(features, 1);
    end

    % 8: kurtosis
    if cIdx < 3
        tempKurtosis = 0;
    else
        tempKurtosis = kurtosis(features, 1);
    end
    fs = [tempMean tempStd tempMin tempMax tempMedian tempIqr];
end


%% calculate topological features
ft = zeros(1, 24);
if cIdx > 3
    % Delaunay Triangulation
    dt = delaunayTriangulation(centers);
    tri = dt.ConnectivityList;
    
    nrTriangles = size(tri, 1);
    X = zeros(3, nrTriangles);
    Y = zeros(3, nrTriangles);
    for k = 1:3
        X(k, :) = centers(tri(:, k), 1)';
        Y(k, :) = centers(tri(:, k), 2)';
    end
    triAreas = polyarea(X, Y) / 4e3;
    
    sideIdx = edges(dt);
    P1 = centers(sideIdx(:, 1), :);
    P2 = centers(sideIdx(:, 2), :);
    
    temp = (P1 - P2).^2;
    triSideLengths = sqrt(sum(temp, 2)) / 200;
    
    [~, dists] = knnsearch(centers, centers, 'K', 6);
    triNNDists = mean(dists, 2) / 50;
    
    ft = [calculateStatistics(triAreas) calculateStatistics(triSideLengths) ...
          calculateStatistics(triNNDists)] ;
end
toc

%% show images
figure(1);
imshow(image);
title('Original Image');

figure(2);
imshow(bw);
title('Nuclear Mask');

figure(3);
dispImage = image;
dispImage = cv.drawContours(dispImage, contours, 'Color', [0 0 255]);
imshow(dispImage);
title('Contours');
