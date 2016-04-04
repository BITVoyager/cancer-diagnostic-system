%Make the Below path as the Current Folder
cd('C:\Users\win 8\Downloads\Georgia Tech Course Work\Semester II\Medical Image Processing\Project\Dataset1\Dataset1\Stroma');

%Obtain all the JPEG format files in the current folder
Files = dir('*.png');

%Number of JPEG Files in the current folder
NumFiles= size(Files,1);

glcm1 = zeros(1,NumFiles);
% stats1 = zeros(1,NumFiles);

for i = 1:NumFiles
    
   %Read the Image from the current Folder
    I = imread(Files(1).name);
    I = reshape(I,[],3);
    glcm1 = graycomatrix(I, 'offset', [0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1]);
%     stats1 = graycoprops(glcm1,{'contrast','homogeneity','energy','correlation'});
end
%%
I = imread('C:\Users\win 8\Downloads\Georgia Tech Course Work\Semester II\Medical Image Processing\Project\Dataset1\Dataset1\Stroma\Stroma_1.png');
figure();
imshow(I);
I1 = rgb2gray(I);
imshow(uint8(I1));
A = detectSURFFeatures(I1);

%%
I_fft = fft2(I1);
Y = fftshift(I_fft);
imshow(Y);
