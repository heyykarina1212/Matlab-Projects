I = imread('pears.png');
G = I;
I = double(I);

Rc = I(:, :, 1);
Gc = I(:, :, 2);
Bc = I(:, :, 3);

h = [1 2 1; 2 4 2; 1 2 1]./16;
K = imfilter(I,h);

RcF = imfilter(Rc,h);
GcF = imfilter(Gc,h);
BcF = imfilter(Bc,h);

res_img = cat(3, RcF, GcF, BcF);

res_img = res_img ./ 255;
figure
subplot(1,2,1)
imshow(res_img);
title('Gaussian Filter')
subplot(1,2,2)
imshow('pears.png');
title('Without Gaussian Filter');
new = imgaussfilt(G,1);
figure(4)
imshow(new);