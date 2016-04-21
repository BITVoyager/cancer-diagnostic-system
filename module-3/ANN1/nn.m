function [eval_NS,eval_ST,eval_NT,MCC_NS,MCC_ST,MCC_NT,performance_NS,performance_ST,performance_NT,performance,errors_NS,errors_ST,errors_NT,errors] = nn(train_algo,nfeat)
addpath  ..\
%train_algo = 'trainlm';
% nfeat = 200;
temp1 = load('.\dataset1\training\Necrosis\Necrosis.mat');
temp2 = load('.\dataset1\training\Stroma\Stroma.mat');
temp3 = load('.\dataset1\training\Tumor\Tumor.mat');
% t = load('C:\Users\win 8\Downloads\Georgia Tech Course Work\Semester II\Medical Image Processing\Project\Module 3\Dataset 1\testing.mat');
C1 = temp1.features;
C2 = temp2.features;
C3 = temp3.features;
% test_t = t.features;

g = load('goodFeatureIdx.mat');
goodFeatureIdx = g.goodFeatureIdx(1:nfeat);

C_temp1 = [];
C_temp2 = []; 
C_temp3 = [];
% t = [];

for i = 1:size(goodFeatureIdx,1)
C_temp1 = [C_temp1,C1(:,goodFeatureIdx(i))];
C_temp2 = [C_temp2,C2(:,goodFeatureIdx(i))];
C_temp3 = [C_temp3,C3(:,goodFeatureIdx(i))];
% t = [t,test_t(:,goodFeatureIdx(i))];
end

% Necrosis vs Stroma
C_train_nn = [C_temp1;C_temp2].';
Y_train_nn = [ones(1,size(C_temp1,1)),zeros(1,size(C_temp2,1));zeros(1,size(C_temp1,1)),ones(1,size(C_temp2,1))];

net = fitnet(10,train_algo);
net.trainParam.showWindow = 0;

inputs = C_train_nn;
targets = Y_train_nn;

% Set up Division of Data for Training, Validation, Testing
% net.divideFcn = 'divideind';
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net1,tr1] = train(net,inputs,targets);

yTrn1 = net1(inputs(:,tr1.trainInd));
tTrn1 = targets(:,tr1.trainInd);

yVal1 = net1(inputs(:,tr1.valInd));
tVal1 = targets(:,tr1.valInd);

yTst1 = net1(inputs(:,tr1.testInd));
tTst1 = targets(:,tr1.testInd);

% Test the Network
outputs = net1(inputs);
errors_NS = gsubtract(targets(:,tr1.testInd),outputs(:,tr1.testInd));
performance_NS = perform(net1,targets(:,tr1.testInd),outputs(:,tr1.testInd));

for i = 1:size(outputs,2)
    if(outputs(1,i) <= 1)
        X(i,1) = -1;
    else
        X(i,1) = 1;
    end
end

for i = 1:size(targets,2)
    if(targets(1,i) == 0)
        Y(i,1) = -1;
    else
        Y(i,1) = 1;
    end
end

MCC_NS = MCC(X.',Y.');
eval_NS = Evaluate(X.',Y.');

% View the Network
% view(net)

% Plots
% figure, plotperform(tr1)
% figure, plottrainstate(tr1)
% figure, plotconfusion( tTst1, yTst1, 'Necrosis vs Stroma')
% figure, ploterrhist(errors_NS)
% figure, plotroc(tTst1,yTst1,'Necrosis vs Stroma');


% Stroma vs Tumor
C_train_nn = [C_temp2;C_temp3].';
Y_train_nn = [ones(1,size(C_temp2,1)),zeros(1,size(C_temp3,1));zeros(1,size(C_temp2,1)),ones(1,size(C_temp3,1))];

net = fitnet(10,train_algo);
net.trainParam.showWindow = 0;

inputs = C_train_nn;
targets = Y_train_nn;

% Set up Division of Data for Training, Validation, Testing
% net.divideFcn = 'divideind';
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net2,tr2] = train(net,inputs,targets);

yTrn2 = net2(inputs(:,tr2.trainInd));
tTrn2 = targets(:,tr2.trainInd);

yVal2 = net2(inputs(:,tr2.valInd));
tVal2 = targets(:,tr2.valInd);

yTst2 = net2(inputs(:,tr2.testInd));
tTst2 = targets(:,tr2.testInd);

% Test the Network
outputs = net2(inputs);
errors_ST = gsubtract(targets(:,tr2.testInd),outputs(:,tr2.testInd));
performance_ST = perform(net2,targets(:,tr2.testInd),outputs(:,tr2.testInd));

for i = 1:size(outputs,2)
    if(outputs(1,i) <= 1)
        X(i,1) = -1;
    else
        X(i,1) = 1;
    end
end

for i = 1:size(targets,2)
    if(targets(1,i) == 0)
        Y(i,1) = -1;
    else
        Y(i,1) = 1;
    end
end

MCC_ST = MCC(X.',Y.');
eval_ST = Evaluate(X.',Y.');

% View the Network
% view(net)

% Plots
% figure, plotperform(tr2)
% figure, plottrainstate(tr2)
% figure, plotconfusion( tTst2, yTst2, 'Stroma vs Tumor')
% figure, ploterrhist(errors_ST)
% figure, plotroc(tTst2,yTst2,'Stroma vs Tumor');

% Necrosis vs Tumor
C_train_nn = [C_temp1;C_temp3].';
Y_train_nn = [ones(1,size(C_temp2,1)),zeros(1,size(C_temp3,1));zeros(1,size(C_temp2,1)),ones(1,size(C_temp3,1))];

net = fitnet(10,train_algo);
net.trainParam.showWindow = 0;

inputs = C_train_nn;
targets = Y_train_nn;

% Set up Division of Data for Training, Validation, Testing
% net.divideFcn = 'divideind';
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net3,tr3] = train(net,inputs,targets);

yTrn3 = net3(inputs(:,tr3.trainInd));
tTrn3 = targets(:,tr3.trainInd);

yVal3 = net3(inputs(:,tr3.valInd));
tVal3 = targets(:,tr3.valInd);

yTst3 = net3(inputs(:,tr3.testInd));
tTst3 = targets(:,tr3.testInd);

% Test the Network
outputs = net3(inputs);
errors_NT = gsubtract(targets(:,tr3.testInd),outputs(:,tr3.testInd));
performance_NT = perform(net3,targets(:,tr3.testInd),outputs(:,tr3.testInd));

for i = 1:size(outputs,2)
    if(outputs(1,i) <= 1)
        X(i,1) = -1;
    else
        X(i,1) = 1;
    end
end

for i = 1:size(targets,2)
    if(targets(1,i) == 0)
        Y(i,1) = -1;
    else
        Y(i,1) = 1;
    end
end

MCC_NT = MCC(X.',Y.');
eval_NT = Evaluate(X.',Y.');

% View the Network
% view(net)

% Plots
% figure, plotperform(tr3)
% figure, plottrainstate(tr3)
% figure, plotconfusion( tTst3, yTst3, 'Necrosis vs Tumor')
% figure, ploterrhist(errors_NT)
% figure, plotroc(tTst3,yTst3,'Necrosis vs Tumor');

% Necrosis vs Stroma vs Tumor

C_train_nn = [C_temp1;C_temp2;C_temp3].';
Y_train_nn = [ones(1,size(C_temp1,1)),zeros(1,size(C_temp2,1)),zeros(1,size(C_temp3,1));zeros(1,size(C_temp1,1)),ones(1,size(C_temp2,1)),zeros(1,size(C_temp3,1));zeros(1,size(C_temp1,1)),zeros(1,size(C_temp2,1)),ones(1,size(C_temp3,1))];

net = fitnet(10,train_algo);
net.trainParam.showWindow = 0;

inputs = C_train_nn;
targets = Y_train_nn;

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


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

% View the Network
% view(net)

% Plots
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion( tTst, yTst, 'Necrosis vs Stroma vs Tumor')
% figure, ploterrhist(errors)
% figure, plotroc(tTst,yTst,'Necrosis vs Stroma vs Tumor');
% end