function model = train_knn( ground_truth, number )

X= ground_truth(:, 1:3);
Y = ground_truth(:, 4);
model = fitcknn(X,Y, 'NumNeighbors', number);

end

