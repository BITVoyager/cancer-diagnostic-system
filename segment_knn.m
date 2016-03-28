function segmented = segment_knn(model, image)

image = im2double(image);
n = size(image, 1);
l = size(image, 2);
segmented = predict(model, reshape(image, [n * l, 3]));

end
          
            