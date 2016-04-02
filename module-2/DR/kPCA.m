function [Y, V, D] = kPCA(X, td, kType, para)
%kPCA Implementation of kernel PCA
%   Input arguments:
%       X: raw data matrix. The dimension is N-by-d, where d is the dimension
%       and N is the number of data.
%       td: the target dimensions that we want to reduce to.
%       kTyper: type of the kernel. 
%       para: parameter specific to a certain kernel type
%   Output arguments:
%       Y: data mapped to new basis
%       V: eigenvectors
%       D: eigenvalues

% calculate kernel matrix
[N, ~] = size(X);
K0 = calculateKernel(X, kType, para);
oneN = ones(N, N) / N;
K = K0 - oneN * K0 - K0 * oneN - oneN * K0 * oneN;

% calculate the eigenvalues and eigenvectors
[V, D] = eig(K / N);
D = diag(D);

% sort the eigenvalues in descending order and rearrange V and D
[~, idx] = sort(D, 'descend');
V = V(:, idx);
D = D(idx);

% normailize the eigenvectors
normV = sqrt(sum(V.^2, 1));
V = V ./ repmat(normV, N, 1);

% reduce dimensions
V = V(:, 1:td);
Y = K0 * V;
end

function K = calculateKernel(X, kType, para)
    % number of data
    N = size(X, 1);
    
    % prepare different kernels without centering
    if strcmp(kType, 'linear')
        K = X * X';   
    elseif strcmp(kType, 'polynomial')
        c = para;
        K = (X * X' + 1).^c;   
    elseif strcmp(kType, 'gaussian')
        sigma = para;        
        XX = sum(X .* X, 2);
        XX1 = repmat(XX, 1, N);
        XX2 = repmat(XX', N, 1);
        dist = XX1 + XX2 - 2 * (X * X');
        dist(dist < 0) = 0;  % clip negative distance in some exception cases    
        K = exp(-dist./(2 * sigma.^2));       
    else
        fprintf(['\nError: Kernel type ' type ' is not supported. \n']);
    end
end

%% hello world