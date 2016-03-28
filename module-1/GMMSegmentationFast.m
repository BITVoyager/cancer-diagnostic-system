function [output, I] = GMMSegmentationFast(filename, initMeans, colorSpace)
%EMSegmentation This is the optimized version.
%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial conditions for testing
% FOR rgb initCenter = [118 243 180; 72 238 71; 134 241 111];
% For hsv initCenter = [0.8 0.92 0; 0.6 0.46 0; 0.36 0.8 0.94];
% For lab initCenter = [50 93 56; 25 3 40; -20 -0.7 -7];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load image and convert the color space if needed
I = imread(filename);
[image, ~, ~] = normalizeColor(I, 255); % normalize color
image = im2double(image); % convert image to [0, 1]

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

% get paramters for the gaussians
K = size(initMeans, 1);   % number of clusters
dim = size(initMeans, 2); % dimensions of the feature space

% parse initial means and initialize covariances
means = initMeans; % means
covs = [0.01*eye(3) 1*eye(3) 0.01*eye(3)];

% for k = 1:K
%     if strcmp(colorSpace, 'RGB') || strcmp(colorSpace, 'HSV')
%         covs = [1*eye(3) 0.1*eye(3) 0.1*eye(3)];
%     else
%         covs = [covs [12 0 0; 0 12 0; 0 0 12]];
%     end
% end

% set up other paramters related to the E-M
weights = 1 / K * ones(1, K);
maxIter = 50;   % maximum number of iterations
thresh = 1e-5;  % threshold for terminating the loop

% image information
rows = size(image, 1); % rows
cols = size(image, 2); % columns
nrData = rows * cols;  % total number of pixels

% p(i|x_j, Theta)
% i: index of cluster
% j: index of pixel
% Theta: parameters
clusterMap2D = zeros(nrData, K); % cluster map in 2D

% feature space in 2D
X = reshape(image, [nrData, dim]); 

% apply E-M here
for iter = 1:maxIter
    % E step
    for k = 1:K
        clusterMap2D(:, k) = weights(k) * mvnpdf(X, means(k, :), covs(:, 3 * k - 2:3 * k));
    end
    
    sums = repmat(sum(clusterMap2D, 2), 1, dim);
    clusterMap2D = clusterMap2D ./ sums;
    
    % M step    
    % update weights 
    weights = sum(clusterMap2D, 1) / nrData;
    
    % update means and covariances
    for k = 1:K
        % update mean
        temp = repmat(clusterMap2D(:, k), 1, dim);
        means(k, :) = sum(temp .* X, 1) / (nrData * weights(k));
        
        % update covariance
        temp1 = repmat(means(k, :), nrData, 1);
        
        covMat = 1e-3 * eye(dim) + ...
            (temp .* (X - temp1))' * (X - temp1) / (nrData * weights(k));
        covs(:, 3 * k - 2:3 * k) = covMat;
    end
end

% process the cluster map
[~, maxIdx] = max(clusterMap2D, [], 2);
output = reshape(maxIdx, [rows, cols]);

end

