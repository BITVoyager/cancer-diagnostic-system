function [S, nuclearMask, cytoplasmMask] = segmentkNN(image, mode, colorSpace, nrNN)
%segment Implement color-based segmentation using kNNs
%   Detailed explanation goes here

useNewGT = 1;

if useNewGT ~= 1
    % parse arguments
    if strcmp(colorSpace, 'RGB')
        I = image;
        if strcmp(mode, '450')
            A = open('RGB_GT1.mat');
            GT = A.GTmat;
        else
            A = open('RGB_GT2.mat');
            GT = A.GTmatrix;
        end   
    elseif strcmp(colorSpace, 'Lab')
        I = rgb2lab(image);
        if strcmp(mode, '450')
            A = open('Lab_GT1.mat');
            GT = A.LabGT1;
        else
            A = open('Lab_GT2.mat');
            GT = A.LabGT2;
        end 
    else
        I = rgb2hsv(image);
        if strcmp(mode, '450')
            A = open('HSV_GT1.mat');
            GT = A.HSV_GT1;
        else
            A = open('HSV_GT2.mat');
            GT = A.HSV_GT2;
        end 
    end
else
    I = im2double(image);
    temp = open('GT.mat');
    GT = temp.GT;
end

% apply kNNs
model = train_knn(GT, nrNN);
segmented = segment_knn(model, I);
    
% reshape the result
S = reshape(segmented, [size(I, 1), size(I, 2)]);

% segment the masks
nuclearMask = (S == 1);
cytoplasmMask = (S == 2);

% save results
% imwrite(nuclearMask, 'nuclearMask.jpg');
% imwrite(cytoplasmMask, 'cytoplasmMask.jpg');
end

