%https://uk.mathworks.com/help/images/color-based-segmentation-using-the-l-a-b-color-space.html
%Color-Based Segmentation Using the L*a*b* Color Space
%removes the remaining 'brown' connected to leaves

clc;clear;close all;

t = tiledlayout(4,1,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant011_rgb.png");

[~,G,~] = imsplit(rgbImage);
allBlack = zeros(size(rgbImage,1,2),class(rgbImage));
justG = cat(3,allBlack,G,allBlack);

%Convert to Greyscale
grey = rgb2gray(justG);

%Median Filter to remove noise
Kmedian = medfilt2(grey);

%Contrast Adjustment
J = imadjust(Kmedian,[0.15 1],[]);

%Binarize using custom threshold
T = adaptthresh(J,0.73);
BW = imbinarize(J,T);

%Remove components connected to border
CB = imclearborder(BW);

%Remove Small Objects
m = bwareaopen(CB, 150);

%get original image segmented by mask
maskedRgbImage = bsxfun(@times, rgbImage, cast(m, 'like', rgbImage));


nexttile;
imshow(maskedRgbImage);
title('Original Image');

lab = rgb2lab(maskedRgbImage);

nexttile;
imshow(lab);
title('LAB colour space');

nexttile;
labRemover = imbinarize(1-(~lab(:,:,1) + lab(:,:,2)));
imshow(labRemover);
title("Cut 'brown' in lab-space");

nexttile;
labRemover = bwareaopen(labRemover,5);
imshow(labRemover);
title("Remove remaining small items");

