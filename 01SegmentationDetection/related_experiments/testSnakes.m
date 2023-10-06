%Uses active contour to try and segment leaves
%https://uk.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering

clc;clear;close all;

t = tiledlayout(2,3,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant006_rgb.png");

[height, width] = size(rgbImage);
display(height)
display(width)
radius_metric = min(height,width);

seg_plant = segment_plant; %get created functions

segmented = seg_plant.getBinMask(rgbImage);

%mask original image using binary mask
maskedRgbImage = bsxfun(@times, rgbImage, cast(segmented, 'like', rgbImage));


nexttile;

imshow(maskedRgbImage);
grey = rgb2gray(maskedRgbImage);

title('Original Image');

nexttile;
mask = zeros(size(grey));
mask(5:end-5,5:end-5) = 1;
imshow(mask)
title('Initial Contour Location')

J = imadjust(grey,[0.3 1],[]);

nexttile;
imshow(J);
title('Contrast-Adjusted')

nexttile;
bw = activecontour(J,mask);
imshow(bw)
title('Segmented Image, 100 Iterations')

nexttile;
bw = activecontour(J,mask,500);
imshow(bw)
title('Segmented Image, 400 Iterations')


