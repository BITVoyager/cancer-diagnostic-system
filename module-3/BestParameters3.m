% clc
% clear all
% close all
%%% Test best combinations for dataset 3

Best_Accuracy = 0;

%% KNN
% Best for dataset 3 Binary Grade / Survival


% for i = 1:5:100
%     for j = 1:5
% %         [ Accuracy, CVLoss ] = KNN_dataset3( 'Binary Grade', i, j );
%         [ Accuracy, CVLoss ] = KNN_dataset3( 'Binary Survival', i, j );
%         if Accuracy > Best_Accuracy
%             Best_Accuracy = Accuracy;
%             Best_CVLoss = CVLoss;
%             Best_NbofFeatures = i;
%             Best_NbofNeighbors = j;
%         end
%     end
%     txt=sprintf('Loop number: %d',i);
%     disp(txt)
% end

% DATASET 3 kNN
% Binary Grade: Accuracy = 61.46% ; CV loss 0.1417 ; Number of features = 61 ; Best of neighbors = 2
% Binary Survival: Accuracy = 50.52% ; CV loss 0.2021 ; Number of features = 26 ; Best of neighbors = 3

%% Deision trees

Best_Accuracy = 0;

for i = 1:200
%     [ DefaultTree, Accuracy, CVLoss ] = Decision_Tree_dataset3( 'Binary Grade', i );
    [ DefaultTree, Accuracy, CVLoss ] = Decision_Tree_dataset3( 'Binary Survival', i );
    if Accuracy > Best_Accuracy
        Best_Accuracy = Accuracy;
        Best_CVLoss = CVLoss;
        Best_NbofFeatures = i;
    end
    txt=sprintf('Loop number: %d',i);
    disp(txt)
end

% DATASET 3 decision trees
% Binary Grade: Accuracy = 56.51% ; CV loss = 0.3688 ; Number of features = 9
% Binary Survival: Accuracy = 56.25 % ; CV loss = 0.3521 ; Number of features = 92



