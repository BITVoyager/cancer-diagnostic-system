function [energy] = subMatrixEnergy(src)
% subMatrixEnergy Calculate energy of a submatrix
% Reference:
% K. Jafari-Khouzani and H. Soltanian-Zadeh, "Multiwavelet grading of 
% pathological images of prostate," IEEE Transactions on Biomedical Engineering, 
% vol. 50, pp. 697-704, 2003.

N = size(src, 1);
assert(size(src, 1) == size(src, 2));

temp = src.^2;
energy = sum(temp(:)) / (N * N);

end

