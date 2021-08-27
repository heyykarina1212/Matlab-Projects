I = imread('VP_Swale.jpg');

J = rgb2hsv(I);
J_hue = single(J);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(J_hue,nColors,'NumAttempts',3);
sz = size(pixel_labels);
figure;
imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');

mask1 = pixel_labels==1;
cluster1 = I .* uint8(mask1);
figure;
imshow(cluster1)
title('Objects in Cluster 1');

mask2 = pixel_labels==2;
cluster2 = I .* uint8(mask2);
figure;
imshow(cluster2)
title('Objects in Cluster 2');

mask3 = pixel_labels==3;
cluster3 = I .* uint8(mask3);
figure;
imshow(cluster3)
title('Objects in Cluster 3');

rock_pt = [328 552];
rock_cat = pixel_labels(rock_pt(1), rock_pt(2));

rock_idx = find(pixel_labels==rock_cat);

BW_rocks = zeros(sz(1),sz(2));
BW_rocks(rock_idx) = 1;
figure;
imshow(BW_rocks);

se = strel('disk',5);
BW_rocks_temp = imclose(BW_rocks,se);
BW_rocks_temp = imopen(BW_rocks_temp,se);

figure;
imshow(BW_rocks_temp);

noSmallStructures = bwareaopen(BW_rocks_temp, 200);
figure;
imshow(noSmallStructures);

stats = regionprops(noSmallStructures, {'Centroid', 'Area'});

Rocks = I;

if ~isempty([stats.Area])
    for i = 1:length(stats)
        c = stats(i).Centroid;
        c = floor(fliplr(c));
        width = 2;
        row = c(1)-width:c(1)+width;
        col = c(2)-width:c(2)+width;
        Rocks(row,col,1) = 255;
        Rocks(row,col,2) = 0;
        Rocks(row,col,3) = 0;
    end
end

figure;
imshow(Rocks);

Total_Rock_Percent = sum([stats.Area])/(sz(1)*sz(2))
