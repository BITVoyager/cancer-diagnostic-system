function [dstImage] = quantizeColor(srcImage)
% quanztizeColor Quantize the colors into 64 levels using self-organizing
% map.

image = im2double(srcImage);

rows = size(image, 1);
cols = size(image, 2);

X = reshape(image, rows*cols, 3)';
x = X(:, randperm(rows*cols, 5000));

net = selforgmap([1 64], 'topologyFcn', 'gridtop');
net.trainParam.showWindow = 0;
net = train(net, x);

y = net(X);
classes = vec2ind(y);
dstImage = reshape(classes, rows, []);
end

