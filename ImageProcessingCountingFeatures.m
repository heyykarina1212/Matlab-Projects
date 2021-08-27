I = imread('Parking_Lot.jpg');

J = double(rgb2gray(I))/255;
figure ;
imshow(J);

BW = imbinarize(J, 185/255);

sedisk = strel('disk',6);

noSmallStructures = imopen(BW, sedisk);

noSmallStructures = bwareaopen(noSmallStructures, 160);
figure;
imshow(noSmallStructures);
stats = regionprops(noSmallStructures, {'Centroid','Area'});

taggedCars = I;
    if ~isempty([stats.Area])
        for i = 1:length(stats)
        c = stats(i).Centroid;
        areaArray = [stats.Area];
        [junk,idx] = max(areaArray);
        c = floor(fliplr(c));
        width = 2;
        row = c(1)-width:c(1)+width;
        col = c(2)-width:c(2)+width;
        taggedCars(row,col,1) = 255;
        taggedCars(row,col,2) = 0;
        taggedCars(row,col,3) = 0;
        end
    end
    
imshow(taggedCars);