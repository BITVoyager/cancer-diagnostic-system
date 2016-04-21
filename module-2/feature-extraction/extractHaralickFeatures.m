function [f] = extractHaralickFeatures(image, nrLevels)
% extractHaralickFeatures extract 13 Haralick features
% image: the input image in uint8 format
% nrLevels: levels of the GLCM
% f: the 13 Haralick features in a row vector 

offset = [0 1; -1 1; -1 0; -1 -1; 1 0; 1 -1; 0 -1; 1 1];
nrDirs = size(offset, 1);
glcms = graycomatrix(image, 'NumLevels', nrLevels, 'Offset', offset);

% normalized GLCM in a 2-D matrix format
tGLCM = reshape(glcms, nrLevels*nrLevels, []);
sums = sum(tGLCM, 1);
tGLCM = bsxfun(@rdivide, tGLCM, sums);

% normalized GLCM in a 3-D matrix format
p = reshape(tGLCM, nrLevels, nrLevels, []);

% calculate some statistics and distributions
[y, x] = meshgrid(1:nrLevels, 1:nrLevels);

% calculate the marginal distributions: px and py
px = zeros(nrLevels, nrDirs);
py = zeros(nrLevels, nrDirs);
for k = 1:nrDirs
    pk = p(:, :, k);
    px(:, k) = sum(pk, 2);
    py(:, k) = sum(pk, 1)';
end

% calculate the means: mux, muy and mu
k = (1:nrLevels)';
tmux = bsxfun(@times, px, k);
mux = sum(tmux, 1);

tmuy = bsxfun(@times, py, k);
muy = sum(tmuy, 1);

mu = (mux + muy) / 2;

% calculate standard deviations: sigmax and sigmay
kk = repmat(k, 1, nrDirs);
muxx = repmat(mux, nrLevels, 1);
muyy = repmat(muy, nrLevels, 1);

tsigmax = (kk - muxx).^2 .* px;
sigmax = sqrt(sum(tsigmax, 1));

tsigmay = (kk - muyy).^2 .* py;
sigmay = sqrt(sum(tsigmay, 1));

% calculate the distributions: p_{x+y} and p_{x-y}
ref = x + y;
pxpy = zeros(2 * nrLevels - 1, nrDirs);
for dirIdx = 1:nrDirs
    for k = 2:2 * nrLevels
        mask = ref == k;
        pp = p(:, :, dirIdx);
        tempMat = pp(mask);
        pxpy(k - 1, dirIdx) = sum(tempMat(:));
    end
end

ref = abs(x - y);
pxmy = zeros(nrLevels, nrDirs);
for dirIdx = 1:nrDirs
    for k = 1:nrLevels
        mask = ref == (k - 1);
        pp = p(:, :, dirIdx);
        tempMat = pp(mask);
        pxmy(k, dirIdx) = sum(tempMat(:));
    end
end

% calculate HXY1 and HXY2
HXY1 = zeros(1, nrDirs);
HXY2 = zeros(1, nrDirs);
for k = 1:nrDirs
    ppp = px(:, k) * py(:, k)';
    
    temp = log(ppp + eps) .* p(:, :, k);   % remove NaN
    HXY1(1, k) = -sum(temp(:));
    
    temp = log(ppp + eps) .* ppp;
    HXY2(1, k) = -sum(temp(:));
end

% calculate HX and HY
HX = zeros(1, nrDirs);
HY = zeros(1, nrDirs);
for k = 1:nrDirs
    temp = px(:, k) .* log(px(:, k) + eps);
    HX(1, k) = -sum(temp(:));
    
    temp = py(:, k) .* log(py(:, k) + eps);
    HY(1, k) = -sum(temp(:));
end

% 1: Angular Second Moment/
f1 = sum(tGLCM.^2, 1);

% 2: Contrast
k = (1:nrLevels)' - 1;
temp = bsxfun(@times, pxmy, k.^2);
f2 = sum(temp, 1) / (nrLevels - 1)^2;

% 3: Correlation
f3 = zeros(1, nrDirs);
i = 1:nrLevels;
for k = 1:nrDirs
    temp = (i - mux(1, k) * ones(1, nrLevels))' * (i - muy(1, k) * ones(1, nrLevels)) .* p(:, :, k);
    f3(1, k) = sum(temp(:)) / (sigmax(1, k) * sigmay(1, k));
end

% 4: Inverse Difference Moment
f4 = zeros(1, nrDirs);
for k = 1:nrDirs
    den = abs(x - y) + 1;
    temp = p(:, :, k) ./ den;
    f4(1, k) = sum(temp(:));
end

% 5: Sum of Sqaures/Variance
j = (1:nrLevels)';
temp = bsxfun(@minus, j, mu);
temp = temp.^2 .* px;
f5 = sum(temp, 1) / (nrLevels - 1)^2;

% 6: Sum Average
j = (2:2*nrLevels)';
temp = bsxfun(@times, pxpy, j);
f6 = sum(temp, 1) / (2 * nrLevels);

% 7: Sum Variance
j = (2:2*nrLevels)';
temp = bsxfun(@minus, j, f6);
temp = temp.^2 .* pxpy;
f7 = sum(temp, 1) / (2 * nrLevels)^2;

% 8: Sum Entropy
temp = pxpy .* log(pxpy + eps);
f8 = -sum(temp, 1) / 10.24;

% 9: Entropy
temp = tGLCM .* log(tGLCM + eps);
f9 = -sum(temp, 1) / 10.24;

% 10: Difference Variance
j = (1:nrLevels)' - 1;
temp = bsxfun(@times, pxmy, j.^2);
f10 = sum(temp, 1) / (nrLevels - 1)^2;

% 11: Difference Entropy
temp = pxmy .* log(pxmy + eps);
f11 = -sum(temp, 1) / 10.24;

% 12: Information of Correlation Measurement 1
f12 = (f9 - HXY1) ./ max(HX, HY);

% 13: Information of Correlation Measurement 2
f13 = 1 - exp(-2 * (HXY2 - f9));
f13 = sqrt(f13);

% calculate the Haralick features
f = [mean(f1) mean(f2) mean(f3) mean(f4) mean(f5) mean(f6) mean(f7) ...
     mean(f8) mean(f9) mean(f10) mean(f11) mean(f12) mean(f13)];

end

