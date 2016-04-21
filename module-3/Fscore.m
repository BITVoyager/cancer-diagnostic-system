function FSCORE = Fscore(X,Y)

% True positives 
TP = sum(X == 1 & Y == 1);
% False positives 
FP = sum(X == -1 & Y == 1);
% False negatives 
FN = sum(X == 1 & Y == -1);

TP_rate = TP/(TP+FN);

Precision = TP/(TP+FP);

Num = 2*((Precision * TP_rate));
Den = Precision + TP_rate ;

FSCORE = Num./Den;


