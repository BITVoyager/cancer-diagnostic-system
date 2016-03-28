function [model, cv] = train_ensemble( ground_truth, number )
cv = [0 0 0];
X= ground_truth(:, 1:3);
Y = ground_truth(:, 4);
model = fitensemble(X,Y,'AdaBoostM2',number,'Tree','Type','Classification');
% cv = fitensemble(X,Y,'AdaBoostM2',number,'Tree','type','classification','kfold',5);
ensemble_model = fullfile('ensemble_model.mat');
save(ensemble_model, 'model');
end



