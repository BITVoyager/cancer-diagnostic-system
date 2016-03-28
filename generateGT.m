close all; 
clear;
clc;

%% creating new big ground truth 
Necrosis_images = cell(1,100);
Stroma_images = cell(1,100);
Tumor_images = cell(1,100);
NewGT = [];
A = open('RGB_GT1.mat');
GTmat = A.GTmat;

%% load images 
for i=1:100
    Necrosis_images{i} = im2double(imread(sprintf('/home/yao/Data/ECE6780/Dataset1/Dataset1/Necrosis_%d.png', i)));
    Stroma_images{i} = im2double(imread(sprintf('/home/yao/Data/ECE6780/Dataset1/Dataset1/Stroma_%d.png', i)));
    Tumor_images{i} = im2double(imread(sprintf('/home/yao/Data/ECE6780/Dataset1/Dataset1/Tumor_%d.png', i)));
end
msgbox('Images are ready','Information Box');

%% generating ground truth mat
for i= 1:49
    rgbImage = Necrosis_images{i};
    pixels(:, 1) = GTmat(3*i-2, 1:3)'; % Nucleous pixel
    pixels(:, 2) = GTmat(3*i-1, 1:3)'; % plasma pixel
    pixels(:, 3) = GTmat(3*i, 1:3)'; % backgroung pixel 
    
    n = size(rgbImage, 1);
    l = size(rgbImage, 2);
    
    colors = reshape(rgbImage(:, :, :), [n * l, 3])';
    
    dists = zeros(3, n * l);
    
    for k = 1:3
        ppixels = repmat(pixels(:, k), 1, n * l);
        dists(k, :) = sum(abs(ppixels - colors).^2, 1);
    end
    
    [~, minIdx] = min(dists, [], 1);
    
    NewGT = [NewGT ; [colors' minIdx']];
        
    display(sprintf('Image number %d done!', i));

end 

for i= 1:50
    rgbImage = Stroma_images{i};
    pixels(:, 1) = GTmat(3*i-2, 1:3)'; % Nucleous pixel
    pixels(:, 2) = GTmat(3*i-1, 1:3)'; % plasma pixel
    pixels(:, 3) = GTmat(3*i, 1:3)'; % backgroung pixel 
    
    n = size(rgbImage, 1);
    l = size(rgbImage, 2);
    
    colors = reshape(rgbImage(:, :, :), [n * l, 3])';
    
    dists = zeros(3, n * l);
    
    for k = 1:3
        ppixels = repmat(pixels(:, k), 1, n * l);
        dists(k, :) = sum(abs(ppixels - colors).^2, 1);
    end
    
    [~, minIdx] = min(dists, [], 1);
    
    NewGT = [NewGT ; [colors' minIdx']];
        
    display(sprintf('Image number %d done!', i+49));

end 

for i= 1:50
    rgbImage = Tumor_images{i};
    pixels(:, 1) = GTmat(3*i-2, 1:3)'; % Nucleous pixel
    pixels(:, 2) = GTmat(3*i-1, 1:3)'; % plasma pixel
    pixels(:, 3) = GTmat(3*i, 1:3)'; % backgroung pixel 
    
    n = size(rgbImage, 1);
    l = size(rgbImage, 2);
    
    colors = reshape(rgbImage(:, :, :), [n * l, 3])';
    
    dists = zeros(3, n * l);
    
    for k = 1:3
        ppixels = repmat(pixels(:, k), 1, n * l);
        dists(k, :) = sum(abs(ppixels - colors).^2, 1);
    end
    
    [~, minIdx] = min(dists, [], 1);
    
    NewGT = [NewGT ; [colors' minIdx']];
        
    display(sprintf('Image number %d done!', i+99));

end 

    BigGroundTruthMatrix = fullfile('BigGroundTruthMatrix.mat');
    save(BigGroundTruthMatrix, 'NewGT');
