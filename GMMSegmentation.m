function [output] = GMMSegmentation(filename, initMeans, colorSpace)
%EMSegmentation This is the slow version.
%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial conditions for testing
% FOR rgb initCenter = [118 243 180; 72 238 71; 134 241 111];
% For hsv initCenter = [0.8 0.92 0; 0.6 0.46 0; 0.36 0.8 0.94];
% For lab initCenter = [50 93 56; 25 3 40; -20 -0.7 -7];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load image and convert the color space if needed
image = im2double(imread(filename));
dim = size(initMeans, 2); % dimensions of the feature space

if strcmp(colorSpace, 'HSV')
    disp('The target color space is HSV');
    image = rgb2hsv(image);
    disp('Done converting RGB to HSV');
end

if strcmp(colorSpace, 'Lab')
    disp('The target color space is Lab');
    image = RGB2Lab(image);
    disp('Done converting RGB to Lab');
end

% parse initial means and initialize covariances
means = initMeans;
covs = [];
for k = 1:dim
    if strcmp(colorSpace, 'RGB') || strcmp(colorSpace, 'HSV')
        covs = [covs 0.2 * eye(dim)];
    else
        covs = [covs 7 * eye(dim)];
    end
end

% set up other paramters related to the E-M
weights = 1 / dim * ones(dim, 1);  % initial weights
maxIter = 50;   % maximum number of iterations
thresh = 1e-5;  % threshold for terminating the loop

% image information
rows = size(image, 1); % rows
cols = size(image, 2); % columns
nrData = rows * cols;  % total number of pixels

% p(j|x_i, Theta)
% j: index of cluster
% i: index of pixel
% Theta: parameters
clusterMap = zeros(rows, cols, dim);

% initialize the log likelihood
oldL = -1e10; % choose a very small value

% apply E-M here
for iter = 1:maxIter
    % E step
    newL = 0;
    for r = 1:rows
        for c = 1:cols
            % update p(j|x_i, Theta) by Bayes' Rule
            x = reshape(image(r, c, :), [dim 1]);
            probVec = multiGaussian(weights, means, covs, x);
            clusterMap(r, c, :) = probVec / sum(probVec);
            % compute the new log liklihood
            newL = newL + log(sum(probVec));
        end
    end
    
    % check whether the loop can be terminated
    if abs((newL - oldL) / oldL) < thresh
        break;
    else
        oldL = newL
    end
    
    
    % M step
    for k = 1:dim
        % update weights
        cluster = clusterMap(:, :, k);
        weights(k) = sum(cluster(:)) / nrData;
        
        % update mean
        mean = zeros(dim, 1);
        for r = 1:rows
            for c = 1:cols 
                x = reshape(image(r, c, :), [dim 1]);
                mean = mean + x * cluster(r, c);
            end
        end
        mean = mean / sum(cluster(:));
        means(:, k) = mean;
        
        % update covariance
        cov = zeros(dim, dim);
        for r = 1:rows
            for c = 1:cols 
                x = reshape(image(r, c, :), [dim 1]);
                cov = cov + cluster(r, c) * (x - mean) * (x - mean)';
            end
        end
        cov = cov / sum(cluster(:));
        covs(:, 3 * k - 2: 3 * k) = cov;
    end 
end

% process the cluster map
output = zeros(size(image, 1), size(image, 2));
for r = 1:rows
    for c = 1:cols
        x = reshape(clusterMap(r, c, :), [dim 1]);
        [~, maxIdx] = max(x);
        output(r, c) = maxIdx;
    end
end

end

