%compares hough transform with high sensitivity vs watershed

clc;clear;close all;
img = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant006_rgb.png");

t = tiledlayout(2,3,'TileSpacing','Compact');

%https://uk.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering

%Display Original Image
nexttile;
imshow(img);
title("Original Image");

%Keeps green channel and converts B and R to 'black' channel
%https://uk.mathworks.com/help/images/display-separated-color-channels-of-rgb-image.html
[R,G,B] = imsplit(img);
allBlack = zeros(size(img,1,2),class(img));
justG = cat(3,allBlack,G,allBlack);

%Convert to Greyscale
grey = rgb2gray(justG);

%Median Filter
Kmedian = medfilt2(grey);

%Contrast Adjustment
J = imadjust(Kmedian,[0.15 1],[]);

%Binarize using custom threshold
T = adaptthresh(J,0.73);
BW = imbinarize(J,T);

%Remove components connected to border
CB = imclearborder(BW);


%Remove Small Objects
nexttile;
BW = bwareaopen(CB, 150);
imshow(BW);
title('Plant Segmentation');


%mask original image using binary mask
nexttile;
maskedRgbImage = bsxfun(@times, img, cast(BW, 'like', img));
imshow(maskedRgbImage);
title('Image cut by Mask')

%opening to segment leaves
nexttile;
%hough transform
[c1, r1] = imfindcircles(BW,[6,30], 'Sensitivity',0.99);
bbox = {};


imshow(img);
hold on
leafCountPreOpen = length(c1);
%bb = cell2mat(bbox(1));
% plot(rec(1,:),rec(2,:), 'r-');

display(c1(1,1));
display(c1(1,2));

%convert circles to boxes
for i=1:length(c1)
    re = [c1(i,1) - r1(i); c1(i,2) - r1(i); r1(i)*2; r1(i)*2];
    rectangle('Position',re,'EdgeColor','r');
end
% viscircles(c1, r1,'EdgeColor','r');
title('Hough Boxes');

grey = im2gray(maskedRgbImage);
bw = imbinarize(grey);

%opens to remove stems
%dilates to reduce leaf ridges

se = strel('disk',4);
se2 = strel('disk',2);
op = imopen(bw,se);
op = imdilate(op,se2);

%get watershed transform
nexttile;
D = bwdist(~op);
imshow(D,[]);

D= -D;
L = watershed(D);
L(~op) = 0;

%get components
bbox = regionprops(L,'BoundingBox');
stats = length(regionprops(L));
rgb = label2rgb(L,'jet',[.5 .5 .5]);
imshow(rgb)
title('Watershed Transform')

nexttile;
imshow(maskedRgbImage);
hold on 

%show bounding boxes
for k = 1:numel(bbox)
    rectangle('Position', bbox(k).BoundingBox, 'EdgeColor', 'r');
end
title('Watershed BBoxes')



