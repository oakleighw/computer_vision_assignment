%Uses harris corner detection to segment leaves
%https://uk.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering

clc;clear;close all;

t = tiledlayout(2,3,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant006_rgb.png");


seg_plant = segment_plant; %get created functions

segmented = seg_plant.getBinMask(rgbImage);
maskedRgbImage = bsxfun(@times, rgbImage, cast(segmented, 'like', rgbImage));


nexttile;

imshow(maskedRgbImage);
grey = rgb2gray(maskedRgbImage);
title('Original Image');

nexttile;
corners = detectHarrisFeatures(grey);
imshow(grey); hold on;
plot(corners);
title('Detected Edges');