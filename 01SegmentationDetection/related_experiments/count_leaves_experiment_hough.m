%This code experiments with hough transform/ pre-post opening
clc;clear;close all;
img = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant008_rgb.png");

t = tiledlayout(4,3,'TileSpacing','Compact');

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
[c1, r1] = imfindcircles(BW,[6,30], 'Sensitivity', 0.95);
imshow(img);
hold on
leafCountPreOpen = length(c1);
viscircles(c1, r1,'EdgeColor','r');
title('Hough Transform');

nexttile;
se = strel("disk", 5);
op = imopen(BW, se);
imshow(op);
title('Opened Image')

nexttile;
[c1, r1] = imfindcircles(op,[6,30], 'Sensitivity', 0.9);
leafCountPostOpen = length(c1);
imshow(img);
hold on
viscircles(c1, r1,'EdgeColor','r');
title('Hough Transform After Opening');

%leaf counts
display(leafCountPreOpen);
display(leafCountPostOpen);

%try hough
%try opening + regionprops
%try mean shift
