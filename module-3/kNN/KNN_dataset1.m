%% KNN classifier for dataset 1
function [ Accuracy, MCC_train_knn, MCC_test_knn, FSCORE, AUC, CVLoss, knn_model, goodFeatureIdx ] = KNN_dataset1( dataset1, dataset2, Nb_features, Nb_Neighbors )

    %%% Load training dataset

    if ((strcmp(dataset1,'Necrosis') && strcmp(dataset2,'Stroma')) || (strcmp(dataset1,'Stroma') && strcmp(dataset2,'Necrosis')))
        temp1 = load('Dataset1/training/Necrosis/Necrosis.mat');
        C1 = temp1.features;
        temp2 = load('Dataset1/training/Stroma/Stroma.mat');
        C2 = temp2.features;
        temp3 = load('Dataset1/testing/testing.mat');
        C3_temp = temp3.features;
        C3 = C3_temp(1:80,:);

    elseif ((strcmp(dataset1,'Necrosis') && strcmp(dataset2,'Tumor')) || (strcmp(dataset1,'Tumor') && strcmp(dataset2,'Necrosis')))
        temp1 = load('Dataset1/training/Necrosis/Necrosis.mat');
        C1 = temp1.features;
        temp2 = load('Dataset1/training/Tumor/Tumor.mat');
        C2 = temp2.features;
        temp3 = load('Dataset1/testing/testing.mat');
        C3_temp = temp3.features;
        C3 = [C3_temp(1:40,:); C3_temp(81:120,:)];

    elseif ((strcmp(dataset1,'Tumor') && strcmp(dataset2,'Stroma')) || (strcmp(dataset1,'Stroma') && strcmp(dataset2,'Tumor')))
        temp1 = load('Dataset1/training/Stroma/Stroma.mat');
        C1 = temp1.features;
        temp2 = load('Dataset1/training/Tumor/Tumor.mat');
        C2 = temp2.features;
        temp3 = load('Dataset1/testing/testing.mat');
        C3_temp = temp3.features;
        C3 = C3_temp(41:120,:);

    else
        msgbox('The function is case sensitive! Please choose between Necrocis, Stroma and Tumor','Error message')
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
    C1_bin = -ones(N_test,1);
    C2_bin = ones(N_test,1);
    Y_test = [C1_bin; C2_bin];
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


