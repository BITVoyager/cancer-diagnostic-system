%% KNN classifier for dataset 2
function [ Accuracy, MCC_train_knn, MCC_test_knn, FSCORE, AUC, CVLoss, knn_model, goodFeatureIdx ] = KNN_dataset2( Binary_Data, Nb_features, Nb_Neighbors )

%%% Load training dataset

if ((strcmp(Binary_Data,'Binary Grade')))
    % Load training dataset
    temp1 = load('dataset2/training/C21/C21.mat');
    C1 = temp1.features;
    temp2 = load('dataset2/training/C22/C22.mat');
    C2 = temp2.features;
    temp3 = load('dataset2/testing/testing.mat');
    C3 = temp3.features;  
    temp4 = xlsread('dataset2/testing/testing_binary.xlsx');
    C4 = [];
    for k=1:size(temp4,1)
        C4 = [C4; repmat(temp4(k,2),16,1)];
    end
elseif ((strcmp(Binary_Data,'Binary Survival')))
    % Load training dataset
    temp1 = load('dataset2/training/C11/C11.mat');
    C1 = temp1.features;
    temp2 = load('dataset2/training/C12/C12.mat');
    C2 = temp2.features;
    temp3 = load('dataset2/testing/testing.mat');
    C3 = temp3.features;
    temp4 = xlsread('dataset2/testing/testing_binary.xlsx');
    C4 = [];
    for k=1:size(temp4,1)
        C4 = [C4; repmat(temp4(k,1),16,1)];
    end
else
    msgbox('The function is case sensitive! Please choose ''Binary Grade'' or ''Binary Survival''')
end

%%% Selection of best features for training images

p = zeros(size(C1, 2), 1);
for k = 1:size(C1, 2)
    y = [C1(:, k) C2(:, k)];
    p(k) = anova1(y, {'a', 'b'}, 'off');
end
[~, sIdx] = sort(p, 'ascend');
goodFeatureIdx = sIdx(1:Nb_features);

% [~, p, ~, ~] = ttest2(C1, C2, 'Vartype', 'unequal');
% [~, goodFeatureIdx] = sort(p, 2);
% goodFeatureIdx = goodFeatureIdx(1:Nb_features);

% Size of the training dataset

N_train = size(C1,1);
X_train = [];
X_train1 = [];
X_train2 = [];

for i=1:size(goodFeatureIdx,1)    
    X_train1 = [X_train1 C1(1:N_train,goodFeatureIdx(i))];
    X_train2 = [X_train2 C2(1:N_train,goodFeatureIdx(i))];
end

X_train = [X_train1 ; X_train2];

C1_bin = -ones(N_train,1);
C2_bin = ones(N_train,1);
Y_train = [C1_bin; C2_bin];

knn_model = fitcknn(X_train,Y_train, 'NumNeighbors', Nb_Neighbors);
CVLoss = resubLoss(knn_model);
[Y_train2,~] = predict(knn_model,X_train);
MCC_train_knn = MCC(Y_train,Y_train2);

% We test our tree on our training dataset
N_test = size(C3,1)/2;
Y_test = C4;
X_test = [];

for i=1:size(goodFeatureIdx,1)
    X_test = [X_test C3(:,goodFeatureIdx(i))];
end

[Y_result,~] = predict(knn_model,X_test);
MCC_test_knn = MCC(Y_test,Y_result);
FSCORE = Fscore(Y_test,Y_result);
[~,scores] = resubPredict(knn_model);
[~,~,~,AUC] = perfcurve(Y_train,scores(:,2),'1');

    Error = abs(0.5*(Y_test-Y_result));
    Err = 0;
    for i= 1:N_test
        Err=Error(i)+Err;
    end

    Accuracy = (N_test-Err)*100/N_test;

end


