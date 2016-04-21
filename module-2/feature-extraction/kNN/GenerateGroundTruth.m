clear;
clc;
close all;

addpath ..\

%% select image folder
folder = 'C:\Users\Yao\Documents\Data\TCGA\Dataset1\training\Tumor';
imageDir = dir(folder);
allColors = [];

%% create GT
D1C1 = load('D1C1.mat');
D1C2 = load('D1C2.mat');
D1C3 = load('D1C3.mat');

D2C1 = load('D2C1.mat');
D2C2 = load('D2C2.mat');

D3C1 = load('D3C1.mat');
D3C2 = load('D3C2.mat');
D3C3 = load('D3C3.mat');
D3C4 = load('D3C4.mat');

GT = [D1C1.allColors; D1C2.allColors; D1C3.allColors; D2C1.allColors; D2C2.allColors;
      D3C1.allColors; D3C2.allColors; D3C3.allColors; D3C4.allColors];
  
GT1 = [D1C1.allColors; D1C2.allColors; D1C3.allColors];
GT2 = [D2C1.allColors; D2C2.allColors];
GT3 = [D3C1.allColors; D3C2.allColors; D3C3.allColors; D3C4.allColors];

%% select ground truth
for k = 4:16:240
    image = imread([folder '\' imageDir(k).name]);
    image = im2double(normalizeColor(image));
    
    figure(1);
    imshow(image);
 
    [cn, rn] = ginput(1); % nuclei
    cn = floor(cn);
    rn = floor(rn);
    temp = image(rn-1:rn+1, cn-1:cn+1, :);
    temp2 = reshape(temp, [9, 3]);
    colorN = sum(temp2, 1) / 9;
    hold on 
    scatter(cn, rn, '*', 'r');

    [cc, rc] = ginput(1); % cytoplasma
    cc = floor(cc);
    rc = floor(rc);
    temp = image(rc-1:rc+1, cc-1:cc+1, :);
    temp2 = reshape(temp, [9, 3]);
    colorC = sum(temp2, 1) / 9;
    hold on 
    scatter(cc, rc, '*', 'b');

    [cb, rb] = ginput(1); % background
    cb = floor(cb);
    rb = floor(rb);
    temp = image(rb-1:rb+1, cb-1:cb+1, :);
    temp2 = reshape(temp, [9, 3]);
    colorB = sum(temp2, 1) / 9;
    hold on 
    scatter(cb, rb, '*', 'k');

    allColors = [allColors; [colorN 1; colorC 2; colorB 3]];
    
    close gcf
    clear('image');
end



