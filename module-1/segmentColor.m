function output = segmentColor(nrNN, GT, image)
%segmentColor A combination of kNNs and GMMs-EM
%   Detailed explanation goes here

% apply kNN here
model = train_knn(GT, nrNN);
S0 = segment_knn(model, image);

% GMMs
K = 3;   % number of clusters
dim = 3; % dimensions of the feature space

% image information
rows = size(image, 1); % rows
cols = size(image, 2); % columns
nrData = rows * cols;  % total number of pixels

% feature space in 2D
X = reshape(image, [nrData, dim]); 

% initialize weights
weights = zeros(1, K);

% initialize means and covariance matrices
means = zeros(K, dim);
covs = zeros(dim, K * dim);
for k = 1:K
    idx = find(S0 == k);
    cluster = X(idx, :);
    N = size(cluster, 1);
    weights(k) = N;
    
    meanVec = mean(cluster, 1)
    means(k, :) = meanVec;
 
    cluster1 = bsxfun(@minus, cluster, meanVec);
    covMat = cluster1' * cluster1 / (N - 1)
    covs(:, 3 * k - 2:3 * k) = covMat;
end
weights = weights / sum(weights);

% set up E-M parameters
maxIter = 50;   % maximum number of iterations

% p(i|x_j, Theta)
% i: index of cluster
% j: index of pixel
% Theta: parameters
clusterMap2D = zeros(nrData, K); % cluster map in 2D

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
        
        covMat = 1e-8 * eye(dim) + ...
            (temp .* (X - temp1))' * (X - temp1) / (nrData * weights(k));
        covs(:, 3 * k - 2:3 * k) = covMat;
    end
end

% process the cluster map
[~, maxIdx] = max(clusterMap2D, [], 2);
output = reshape(maxIdx, [rows, cols]);

end

