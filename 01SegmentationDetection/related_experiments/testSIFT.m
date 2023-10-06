%Uses SIFT to attempt to count leaves as features (scale-invariant features)
%https://uk.mathworks.com/help/vision/ref/detectsiftfeatures.html

clc;clear;close all;

t = tiledlayout(1,2,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant004_rgb.png");


seg_plant = segment_plant; %get created functions

segmented = seg_plant.getBinMask(rgbImage);
%mask original image using binary mask
maskedRgbImage = bsxfun(@times, rgbImage, cast(segmented, 'like', rgbImage));


nexttile;

imshow(maskedRgbImage);
grey = rgb2gray(maskedRgbImage);

title('Original Image');

nexttile;
points = detectSIFTFeatures(grey, ContrastThreshold= 0.06);
imshow(grey);
hold on;
plot(points)
title('SIFT detections');