clear;
clc;

I = imread('img_gps-0794.jpg');
J = im2gray(I);
J = double(J)/255;

J = imrotate(J,90);
K = fft2(J);
K_shift = fftshift(K);

K_edit = K_shift;

K_edit(321,1:240) = 0;
K_edit(321,242:end) = 0;
K_edit(1:320,241) = 0;
K_edit(322:end,241) = 0;

K_invshift = ifftshift(K_edit);
L = abs(ifft2(K_invshift));

BW = imbinarize(L,122/255);
BW2 = imcomplement(BW);

onlyBirds = bwareaopen(BW2,4);

stats = regionprops(onlyBirds,{'Centroid','Area'});
markedBirds = imrotate(I,90);

for i = 1:length(stats)
    c = stats(i).Centroid;
    c = floor(fliplr(c));
    width = 2;
    row = c(1): c(1)+width;
    col = c(2): c(2)+width;
    markedBirds(row,col,1) = 255;
    markedBirds(row,col,2) = 0;
    markedBirds(row,col,3) = 0;
end

marks = imbinarize(markedBirds(:,:,1),254/255);
markedBirds = imoverlay(L,marks,'red');

figure;
imshow(markedBirds);

NumberOfBirds = length(stats) %178