% Example script

NbofTopFeatures = 20;
NbofNeighbors = 2;

% The order of puting 

%% Dataset1:
%%% kNN classifier
[ Accuracy_knn, MCC_train_knn, MCC_test_knn, CVLoss_knn ] = KNN_dataset1( 'Stroma', 'Necrosis', NbofTopFeatures, NbofNeighbors ) ;
%%% Decision tree classifier
[ Accuracy_tree, MCC_train_tree, MCC_test_tree, CVLoss_tree, Tree ] = Decision_Tree_dataset1( 'Stroma', 'Tumor', NbofTopFeatures ) ;

%% Dataset2:
%%% kNN classifier
[ Accuracy_knn, MCC_train_knn, MCC_test_knn, CVLoss_knn ] = KNN_dataset2( 'Stroma', 'Nexcrosis', NbofTopFeatures, NbofNeighbors ) ;
%%% Decision tree classifier
[ Accuracy_tree, MCC_train_tree, MCC_test_tree, CVLoss_tree, Tree ] = Decision_Tree_dataset2( 'Stroma', 'Tumor', NbofTopFeatures ) ;

%% Dataset3:
%%% kNN classifier
[ Accuracy_knn, MCC_train_knn, MCC_test_knn, CVLoss_knn ] = KNN_dataset3( 'Stroma', 'Nexcrosis', NbofTopFeatures, NbofNeighbors ) ;
%%% Decision tree classifier
[ Accuracy_tree, MCC_train_tree, MCC_test_tree, CVLoss_tree, Tree ] = Decision_Tree_dataset3( 'Stroma', 'Tumor', NbofTopFeatures ) ;

%% To view the tree:
view(DefaultTree,'mode','graph')

