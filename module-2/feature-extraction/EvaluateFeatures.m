clear;
clc;
close all;

%% load features
temp1 = load('C:\Users\Yao\Documents\Data\TCGA\Dataset1\training\Necrosis\features.mat');
C1 = temp1.features;

temp2 = load('C:\Users\Yao\Documents\Data\TCGA\Dataset1\training\Tumor\features.mat');
C2 = temp2.features;

% temp1 = load('D2C3.mat');
% C1 = temp1.D2C3;
% temp2 = load('D2C4.mat');
% C2 = temp2.D2C4;

%% selection
p = zeros(size(C1, 2), 1);
for k = 1:size(C1, 2)
    y = [C1(:, k) C2(:, k)];
    p(k) = anova1(y, {'a', 'b'}, 'off');
end
[~, sIdx] = sort(p, 'ascend');
goodFeatureIdx = sIdx(1:30);

% [~, p, ~, ~] = ttest2(C1, C2, 'Vartype', 'unequal');
% [~, goodFeatureIdx] = sort(p, 2);
% goodFeatureIdx = goodFeatureIdx(1:50);
% 
% C = [C1(:, goodFeatureIdx);C2(:, goodFeatureIdx)];
% y = cell(size(C, 1), 1);
% for k = 1:size(y, 1)
%     if k <= size(C1, 1)
%         y(k, 1) = {'C1'};
%     end
%     if k > size(C1, 1) && k <= size(C1, 1) + size(C2, 1)
%         y(k, 1) = {'C2'};
%     end
% end
% 
% c = cvpartition(y, 'kFold', 10);
% opts = statset('display', 'iter');
% fun = @(XT, yT, Xt, yt) (sum(~strcmp(yt, classify(Xt, XT, yT))));
% try
%     [fs, ~] = sequentialfs(fun, C, y, 'cv', c, 'mcreps', 1, 'options', opts, 'direction', 'backward');
% catch
%     [fs, ~] = sequentialfs(fun, C, y, 'cv', c, 'options', opts, 'direction', 'backward');
% end
% topFeatureIdx = goodFeatureIdx(fs);
% % error = history.Crit(1, end);

%% transformation
features = [C1(:, goodFeatureIdx); C2(:, goodFeatureIdx)];
% 
% labels = [ones(size(C1, 1), 1); 10*ones(size(C2, 1), 1)];
% [pc, ~] = lda(features, labels, 2);
% pc = pc';

[W, pc, ~] = pca(features);     
pc = pc';

group1 = pc(:, 1:size(C1, 1));
group2 = pc(:, size(C1, 1) + 1:size(C1, 1) + size(C2, 1));

figure(1);
plot3(group1(1,:), group1(2,:), group1(3,:), 'r.', group2(1,:), group2(2,:), group2(3,:), 'g.');    
hold on
% plot(group1(1,:), 0, 'g.');
% plot(group2(1,:), 0, 'r.');
title('Largest 2 Principle Axes');
legend('C1', 'C2');