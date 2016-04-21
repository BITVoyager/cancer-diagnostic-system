%% Decision trees classifier for dataset 3
function [ Accuracy, MCC_train_trees, MCC_test_trees, FSCORE, AUC, CVLoss, DefaultTree, goodFeatureIdx ] = Decision_Tree_dataset3( Binary_Data, Nb_features )

    %%% Load training dataset

    if ((strcmp(Binary_Data,'Binary Grade')))

        % Load training dataset
        temp1 = load('dataset3/training/C21/C21.mat');
        C1 = temp1.features;
        temp2 = load('dataset3/training/C22/C22.mat');
        C2 = temp2.features;
        temp3 = load('dataset3/testing/testing.mat');
        C3 = temp3.features;  
        temp4 = xlsread('dataset3/testing/testing_binary.xlsx');
        C4 = [];
        for k=1:size(temp4,1)
            C4 = [C4; repmat(temp4(k,2),16,1)];
        end

        % Selection of best features for training images

        p = zeros(size(C1, 2), 1);
        for k = 1:size(C1, 2)
            y = [C1(1:240, k) C2(:, k)];
            p(k) = anova1(y, {'a', 'b'}, 'off');
        end
        [~, sIdx] = sort(p, 'ascend');
        goodFeatureIdx = sIdx(1:Nb_features);

        [~, p, ~, ~] = ttest2(C1(1:240, :), C2, 'Vartype', 'unequal');
        [~, goodFeatureIdx] = sort(p, 2);
        goodFeatureIdx = goodFeatureIdx(1:Nb_features);

        N_train = size(C2,1);


    elseif ((strcmp(Binary_Data,'Binary Survival')))

        % Load training dataset
        temp1 = load('dataset3/training/C11/C11.mat');
        C1 = temp1.features;
        temp2 = load('dataset3/training/C12/C12.mat');
        C2 = temp2.features;
        temp3 = load('dataset3/testing/testing.mat');
        C3 = temp3.features;
        temp4 = xlsread('dataset3/testing/testing_binary.xlsx');
        C4 = [];
        for k=1:size(temp4,1)
            C4 = [C4; repmat(temp4(k,1),16,1)];
        end

        % Selection of best features for training images

    %     p = zeros(size(C1, 2), 1);
    %     for k = 1:size(C1, 2)
    %         y = [C1(:, k) C2(1:240, k)];
    %         p(k) = anova1(y, {'a', 'b'}, 'off');
    %     end
    %     [~, sIdx] = sort(p, 'ascend');
    %     goodFeatureIdx = sIdx(1:Nb_features);

        [~, p, ~, ~] = ttest2(C1, C2(1:240, :), 'Vartype', 'unequal');
        [~, goodFeatureIdx] = sort(p, 2);
        goodFeatureIdx = goodFeatureIdx(1:Nb_features);

        N_train = size(C1,1);

    else

        msgbox('The function is case sensitive! Please choose ''Binary Grade'' or ''Binary Survival''')

    end


    % Size of the training dataset
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

    DefaultTree = fitctree(X_train,Y_train);
    CVTree = crossval(DefaultTree);
    CVLoss = kfoldLoss(CVTree);
%     view(DefaultTree,'mode','graph')

    [Y_train2,~] = predict(DefaultTree,X_train);
    MCC_train_trees = MCC(Y_train,Y_train2);

    % We test our tree on our training dataset

    N_test = size(C3,1)/2;
    Y_test = C4;
    X_test = [];

    for i=1:size(goodFeatureIdx,1)
        X_test = [X_test C3(:,goodFeatureIdx(i))];
    end

    [Y_result,~] = predict(DefaultTree,X_test);
    MCC_test_trees = MCC(Y_test,Y_result);
    FSCORE = Fscore(Y_test,Y_result);
    [~,scores] = resubPredict(DefaultTree);
    [~,~,~,AUC] = perfcurve(Y_train,scores(:,2),'1'); 

    Error = abs(0.5*(Y_test-Y_result));
    Err = 0;
    for i= 1:N_test
        Err=Error(i)+Err;
    end

    Accuracy = (N_test-Err)*100/N_test;

end




