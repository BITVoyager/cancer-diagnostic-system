function MCC = MCC(X, Y)

% True positives 
TP = sum(X == 1 & Y == 1);
% False positives 
FP = sum(X == -1 & Y == 1);
% True negatives 
TN = sum(X == -1 & Y == -1);
% False negatives 
FN = size(X, 1) - TP - FP - TN;

Num = TP.* TN - FP.*FN ;
Den = sqrt( (TP + FP) .* (TP + FN) .* (TN + FP) .* (TN + FN) ) ;

MCC = Num./Den;
% MCC = (TP.* TN - FP.*FN) ./ ...
%     sqrt( (TP + FP) .* (TP + FN) .* (TN + FP) .* (TN + FN) );