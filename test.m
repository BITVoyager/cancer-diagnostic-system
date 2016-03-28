clear;
clc;
close all;

%% load images
Necrosis_images = cell(15, 1);
Stroma_images = cell(15, 1);
Tumor_images = cell(15, 1);
for i = 51:65
    Necrosis_images{i - 50} = imread(sprintf('Dataset1/Necrosis_%d.png', i));
    Stroma_images{i - 50} = imread(sprintf('Dataset1/Stroma_%d.png', i));    
    Tumor_images{i - 50} = imread(sprintf('Dataset1/Tumor_%d.png', i));    
end

mode = 'RGB';
priN = zeros(15, 3);
gceN = zeros(15, 3);
accN = zeros(15, 3);


%% test GMMs
% for k = 1:15
%     
%     D = [];
%     if strcmp(mode, 'RGB')
%         D = [78 44 87; 215 179 203; 255 255 255] / 255;
%     end
%     if strcmp(mode, 'HSV')
%         D = [0.75177 0.51648 0.35686; 0.93791 0.3088 0.86; 0.1666 0.012 0.97];
%     end
%     if strcmp(mode, 'Lab')
%         D = [27 24 -20; 60 30 -2; 94 0 0];
%     end
%     
%     % Necrosis
%     S1 = GMMSegmentationFast(sprintf('Dataset1/Necrosis_%d.png', k+50), D, mode);
%     filename = sprintf('Necrosis%d.GTfile.mat', k+50);
%     tt = load(filename);
%     GT1 = tt.idxMap;
%     [priN(k, 1), gceN(k, 1), accN(k, 1)] = evaluate(S1, GT1);
%     
%     
%     % Stroma
%     S2 = GMMSegmentationFast(sprintf('Dataset1/Stroma_%d.png', k+50), D, mode);
%     filename = sprintf('Stroma%d.GTfile.mat', k+50);
%     tt = load(filename);
%     GT2 = tt.idxMap;
%     [priN(k, 2), gceN(k, 2), accN(k, 2)] = evaluate(S2, GT2);
%     
%     % Tumor
%     S3 = GMMSegmentationFast(sprintf('Dataset1/Tumor_%d.png', k+50), D, mode);
%     filename = sprintf('Tumor%d.GTfile.mat', k+50);
%     tt = load(filename);
%     GT3 = tt.idxMap; 
%     [priN(k, 3), gceN(k, 3), accN(k, 3)] = evaluate(S3, GT3);
%     disp('!!!!!')
% end
% 
% figure
% subplot(1,3,1), plot(priN(:, 1)), title('Necrosis-GMMs-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 1))),text(3,0.2,str)
% subplot(1,3,2), plot(priN(:, 2)), title('Stroma-GMMs-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 2))),text(3,0.2,str)
% subplot(1,3,3), plot(priN(:, 3)), title('Tumor-GMMs-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 3))),text(3,0.2,str)
% 
% figure
% subplot(1,3,1), plot(gceN(:, 1)), title('Necrosis-GMMs-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 1))),text(3,0.8,str)
% subplot(1,3,2), plot(gceN(:, 2)), title('Stroma-GMMs-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 2))),text(3,0.8,str)
% subplot(1,3,3), plot(gceN(:, 3)), title('Tumor-GMMs-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 3))),text(3,0.8,str)
% 
% figure
% subplot(1,3,1), plot(accN(:, 1)), title('Necrosis-GMMs-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 1))),text(3,0.2,str)
% subplot(1,3,2), plot(accN(:, 2)), title('Stroma-GMMs-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 2))),text(3,0.2,str)
% subplot(1,3,3), plot(accN(:, 3)), title('Tumor-GMMs-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 3))),text(3,0.2,str)

load('RGB_GT1.mat')
model = train_knn( GTmat, 5 )

%% kNN
for k = 1:15
    
    % Necrosis
    S1 = segment_knn(model, Necrosis_images{k });
    S1 = reshape(S1, [512, 512]);
    filename = sprintf('Necrosis%d.GTfile.mat', k + 50);
    tt = load(filename);
    GT1 = tt.idxMap;
    [priN(k, 1), gceN(k, 1), accN(k, 1)] = evaluate(S1, GT1);
    
    
    % Stroma
    S2 = segment_knn(model, Stroma_images{k});
    S2 = reshape(S2, [512, 512]);
    filename = sprintf('Stroma%d.GTfile.mat', k + 50);
    tt = load(filename);
    GT2 = tt.idxMap;
    [priN(k, 2), gceN(k, 2), accN(k, 2)] = evaluate(S2, GT2);
    
    % Tumor
    S3 = segment_knn(model, Tumor_images{k});
    S3 = reshape(S3, [512, 512]);
    filename = sprintf('Tumor%d.GTfile.mat', k +50);
    tt = load(filename);
    GT3 = tt.idxMap; 
    [priN(k, 3), gceN(k, 3), accN(k, 3)] = evaluate(S3, GT3);
    disp('????')
end

figure
subplot(1,3,1), plot(priN(:, 1)), title('Necrosis-kNN-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 1))),text(3,0.2,str)
subplot(1,3,2), plot(priN(:, 2)), title('Stroma-kNN-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 2))),text(3,0.2,str)
subplot(1,3,3), plot(priN(:, 3)), title('Tumor-kNN-PRI'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(priN(:, 3))),text(3,0.2,str)

figure
subplot(1,3,1), plot(gceN(:, 1)), title('Necrosis-kNN-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 1))),text(3,0.8,str)
subplot(1,3,2), plot(gceN(:, 2)), title('Stroma-kNN-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 2))),text(3,0.8,str)
subplot(1,3,3), plot(gceN(:, 3)), title('Tumor-kNN-GCE'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(gceN(:, 3))),text(3,0.8,str)

figure
subplot(1,3,1), plot(accN(:, 1)), title('Necrosis-kNN-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 1))),text(3,0.2,str)
subplot(1,3,2), plot(accN(:, 2)), title('Stroma-kNN-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 2))),text(3,0.2,str)
subplot(1,3,3), plot(accN(:, 3)), title('Tumor-kNN-Accuracy'),axis square, axis([0 16 0 1]),str=sprintf('Mean = %d',mean(accN(:, 3))),text(3,0.2,str)




