function [pri, gce, acc] = evaluate(result, gt)
%evaluate Summary of this function goes here
%   Detailed explanation goes here

[rows, cols] = size(result);

% compute the count matrix
countMat = zeros(3, 3);

for r = 1:rows
    for c = 1:cols
        u = result(r, c);
        v = gt(r, c);
        countMat(u, v) = countMat(u, v) + 1;
    end
end

pri = randIndex(countMat);
gce = globalConsistencyError(countMat);
acc = trace(countMat) / sum(countMat(:));

return;

% probablistic rand index
function pri = randIndex(countMat)
N = sum(countMat(:));
nrU = sum(countMat, 2);
nrV = sum(countMat, 1);
N_choose_2 = N * (N - 1) / 2;
pri = 1 - ( sum(nrU .* nrU)/2 + sum(nrV .* nrV)/2 - sum(sum(countMat.*countMat)) )/N_choose_2;

% global cinsistency error
function gce = globalConsistencyError(countMat)
N = sum(countMat(:));
marginal1 = sum(countMat, 2);
marginal2 = sum(countMat, 1);

E1 = 1 - sum( sum(countMat .* countMat, 2) ./ (marginal1 + (marginal1 == 0)) ) / N;
E2 = 1 - sum( sum(countMat .* countMat, 1) ./ (marginal2 + (marginal2 == 0)) ) / N;
gce = min(E1, E2);

