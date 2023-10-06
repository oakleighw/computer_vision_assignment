%attempts separating using a change in contrast for individual leaves

clc;clear;close all;

t = tiledlayout(2,3,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant012_rgb.png");

[height, width] = size(rgbImage);
display(height)
display(width)
radius_metric = min(height,width);

seg_plant = segment_plant; %get created functions

segmented = seg_plant.getBinMask(rgbImage);

%get segment-masked original image
maskedRgbImage = bsxfun(@times, rgbImage, cast(segmented, 'like', rgbImage));


nexttile;

imshow(maskedRgbImage);

title('Original Image');

%Contrast Adjustment
maskedGrey = rgb2gray(maskedRgbImage);
J = imadjust(maskedGrey,[0.42 1],[]);

nexttile;
imshow(J);

%Binarize using custom threshold
T = adaptthresh(J,0.35);
BW = imbinarize(J,T);

nexttile;
imshow(BW);
title('Binarized with threshold');

