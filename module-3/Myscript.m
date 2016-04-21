%% Myscript

% define the tested feature matrix
temp3 = load('Dataset1/testing/testing.mat');
C3_temp = temp3.features;
C3 = C3_temp(85,:); % choose the image or group of images

NbFeatures = 10;
Neighbors = 5;

[ knn_classNb, knn_model, knn_CVLoss ] = Global_KNN_classifier( NbFeatures, Neighbors , C3)

[ tree_classNb, tree_model, tree_CVLoss ] = Global_Tree_classifier( NbFeatures, C3 )
 