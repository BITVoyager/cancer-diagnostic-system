%% Script for combining the 3 classes 

%% KNN classifier
function [ ClassNb, knn_model, CVLoss, topFeatures ] = Global_KNN_classifier( Nb_features, Nb_Neighbors, C3 )

%%% Load training dataset

    temp1 = load('Dataset1/training/Necrosis/Necrosis.mat');
    C_Necrosis = temp1.features;
    temp2 = load('Dataset1/training/Stroma/Stroma.mat');
    C_Stroma = temp2.features;
    temp3 = load('Dataset1/training/Tumor/Tumor.mat');
    C_Tumor = temp3.features;
    temp4 = load('Ranked_Features_Necrosis_Stroma.mat');
    goodFeatureIdx1 = temp4.sIdx1(1:Nb_features);
    temp5 = load('Ranked_Features_Necrosis_Tumor.mat');
    goodFeatureIdx2 = temp5.sIdx2(1:Nb_features);
    temp6 = load('Ranked_Features_Stroma_Tumor.mat');
    goodFeatureIdx3 = temp6.sIdx3(1:Nb_features);
    
    goodFeatureIdx = [ goodFeatureIdx1 goodFeatureIdx2 goodFeatureIdx3 ];
    
    % Size of the training dataset
    N_train = size(C_Necrosis,1);
    Ycount = zeros(3,1);
    
    for l=1:3
        X_train = [];
        X_train1 = [];
        X_train2 = [];
        X_train3 = [];
        Y_result = [];

            for i=1:size(goodFeatureIdx,1)    
                X_train1 = [X_train1 C_Necrosis(1:N_train,goodFeatureIdx(i,l))];
                X_train2 = [X_train2 C_Stroma(1:N_train,goodFeatureIdx(i,l))];
                X_train3 = [X_train3 C_Tumor(1:N_train,goodFeatureIdx(i,l))];
            end
        X_train = [X_train1 ; X_train2 ; X_train3];
        Y_train = [ones(N_train,1); 2*ones(N_train,1);3*ones(N_train,1)];

        knn_model = fitcknn(X_train,Y_train, 'NumNeighbors', Nb_Neighbors);
        CVLoss = resubLoss(knn_model);

        % We test our tree on our training dataset

        N_test = size(C3,1);
        X_test = [];
        
        for i=1:size(goodFeatureIdx,1)
            X_test = [X_test C3(:,goodFeatureIdx(i,l))];
        end

        [Y_result,~] = predict(knn_model,X_test);
        Ref = [1; 2; 3];
        if size(Y_result,1) == 1
            Ycount = Ycount + histc(Y_result, Ref)';
        else
            Ycount = Ycount + histc(Y_result, Ref);
        end
    end
    
    X_train = [];
    X_train1 = [];
    X_train2 = [];
    X_train3 = [];
    Y_train = [];
    
    if max(Ycount) == Ycount(1)
        ClassNb = 1;
        display('Classification result: Necrosis');
        for i=1:size(goodFeatureIdx,1)    
            X_train1 = [X_train1 C_Necrosis(1:N_train,goodFeatureIdx(i,1))];
            X_train2 = [X_train2 C_Stroma(1:N_train,goodFeatureIdx(i,1))];
            X_train3 = [X_train3 C_Tumor(1:N_train,goodFeatureIdx(i,1))];
        end
        topFeatures = goodFeatureIdx1(1:7);
        
    elseif max(Ycount) == Ycount(2)
        ClassNb = 2;
        display('Classification result: Stroma');
        for i=1:size(goodFeatureIdx,1)    
            X_train1 = [X_train1 C_Necrosis(1:N_train,goodFeatureIdx(i,3))];
            X_train2 = [X_train2 C_Stroma(1:N_train,goodFeatureIdx(i,3))];
            X_train3 = [X_train3 C_Tumor(1:N_train,goodFeatureIdx(i,3))];
        end
        topFeatures = goodFeatureIdx3(1:7);
        
    elseif max(Ycount) == Ycount(3)
        ClassNb = 3;
        display('Classification result: Tumor');
        for i=1:size(goodFeatureIdx,1)    
            X_train1 = [X_train1 C_Necrosis(1:N_train,goodFeatureIdx(i,2))];
            X_train2 = [X_train2 C_Stroma(1:N_train,goodFeatureIdx(i,2))];
            X_train3 = [X_train3 C_Tumor(1:N_train,goodFeatureIdx(i,2))];
        end
        topFeatures = goodFeatureIdx2(1:7);
        
    end
    
    X_train = [X_train1 ; X_train2 ; X_train3];
    Y_train = [ones(N_train,1); 2*ones(N_train,1);3*ones(N_train,1)];

    knn_model = fitcknn(X_train,Y_train, 'NumNeighbors', Nb_Neighbors);
    CVLoss = resubLoss(knn_model);




