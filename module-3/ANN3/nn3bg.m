function [eval,MCC_perf,performance,errors] = nn3bg(test,train_algo,nfeat)

temp1 = load('.\dataset3\training\C21\C21.mat');
C2_1 = temp1.features;

temp2 = load('.\dataset3\training\C22\C22.mat');
C2_2 = temp2.features;

temp3 = load('.\dataset3\testing\testing.mat');
temp = temp3.features;

g = load('goodFeatureIdx_BG.mat');
goodFeatureIdx = g.goodFeatureIdx(1:nfeat);

C_test = temp((16*(test-1))+1:16*test,:);
C_temp1 = [];
C_temp2 = []; 
C_temp3 = [];

for i = 1:size(goodFeatureIdx,1)
    C_temp1 = [C_temp1,C2_1(:,goodFeatureIdx(i))];
    C_temp2 = [C_temp2,C2_2(:,goodFeatureIdx(i))];
    C_temp3 = [C_temp3,C_test(:,goodFeatureIdx(i))];
end 

C_train_nn = [C_temp1;C_temp2;C_temp3].';

Y_temp = xlsread('testing.xlsx');

if(Y_temp(test,2) == -1)
    Y_train_nn = [ones(1,size(C_temp1,1)),zeros(1,size(C_temp2,1)),ones(1,size(C_temp3,1));zeros(1,size(C_temp1,1)),ones(1,size(C_temp2,1)),zeros(1,size(C_temp3,1))];
else
    Y_train_nn = [ones(1,size(C_temp1,1)),zeros(1,size(C_temp2,1)),ones(1,size(C_temp3,1));zeros(1,size(C_temp1,1)),ones(1,size(C_temp2,1)),zeros(1,size(C_temp3,1))];
end

net = fitnet(10,train_algo);
net.trainParam.showWindow = 0;

inputs = C_train_nn;
targets = Y_train_nn;

% Set up Division of Data for Training, Validation, Testing
net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:500;
net.divideParam.valInd = 501:560;
net.divideParam.testInd = 561:576;


% Train the Network
[net,tr] = train(net,inputs,targets);

yTrn = net(inputs(:,tr.trainInd));
tTrn = targets(:,tr.trainInd);

yVal = net(inputs(:,tr.valInd));
tVal = targets(:,tr.valInd);

yTst = net(inputs(:,tr.testInd));
tTst = targets(:,tr.testInd);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets(:,tr.testInd),outputs(:,tr.testInd));
performance = perform(net,targets(:,tr.testInd),outputs(:,tr.testInd));

for i = 1:size(tr.testInd,2)
    if(outputs(1,tr.testInd(i)) <= 1)
        X(i,1) = -1;
    else
        X(i,1) = 1;
    end
end

for i = 1:size(tr.testInd,2)
    if(targets(1,tr.testInd(i)) == 0)
        Y(i,1) = -1;
    else
        Y(i,1) = 1;
    end
end

MCC_perf = MCC(X.',Y.');
eval = Evaluate(X.',Y.');

% View the Network
% view(net)
% 
% % Plots
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(tTst,yTst,'High Grade vs Low Grade Dataset 3')
% figure, ploterrhist(errors)
% figure, plotroc(tTst,yTst,'High Grade vs Low Grade Dataset 3');
end