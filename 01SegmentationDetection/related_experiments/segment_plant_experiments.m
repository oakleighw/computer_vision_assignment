%experiments to segment whole plant

clc;clear;close all;
img = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant005_rgb.png");

t = tiledlayout(2,5,'TileSpacing','Compact');

%Display Original Image
nexttile;
imshow(img);
title("Original Image");

nexttile;
%Keeps green channel and converts B and R to 'black' channel
%https://uk.mathworks.com/help/images/display-separated-color-channels-of-rgb-image.html
[R,G,B] = imsplit(img);
allBlack = zeros(size(img,1,2),class(img));
justG = cat(3,allBlack,G,allBlack);
imshow(justG);
title("Extracted Green Channel");

%Convert to Greyscale
nexttile;
grey = rgb2gray(justG);
imshow(grey);
title("Greyscale")

%Median Filter
nexttile;
Kmedian = medfilt2(grey);
imshow(Kmedian);
title("Median filter")

%Contrast Adjustment
nexttile;
J = imadjust(Kmedian,[0.15 1],[]);
imshow(J);
title('Contrast adjustment');

%Binarize using custom threshold
nexttile;
T = adaptthresh(J,0.73);
BW = imbinarize(J,T);
imshow(BW);
title('Binarized');

%Remove components connected to border
nexttile;
CB = imclearborder(BW);
imshow(CB);
title('Cleared Border');

%Remove Small Objects
nexttile;
BW = bwareaopen(CB, 150);
imshow(BW);
title('Removed Small Objects');

nexttile;
%Erode to show edge
s =strel('disk',1); % morphological structuring element
ime =imerode(BW,s);
imshow(BW-ime);
title('Edge (Erosion Subtraction)');

%mask original image using binary mask
nexttile;
maskedRgbImage = bsxfun(@times, img, cast(BW, 'like', img));
imshow(maskedRgbImage);
title('Image cut by Mask')