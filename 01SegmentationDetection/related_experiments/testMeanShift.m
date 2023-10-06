%Uses mean shift clustering to try and segment leaves
%https://www.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering

clc;clear;close all;

t = tiledlayout(2,3,'TileSpacing','Compact');

rgbImage = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant004_rgb.png");

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

title('Original Image');

nexttile;

%adjust contrast
h = imadjust(maskedRgbImage,[0.58 0.9]);

imshow(h);
title('Contrast Adjustment');

ax=gca;


redChannel=h(:, :, 1);

greenChannel=h(:, :, 2);

blueChannel=h(:, :, 3);

data=double([redChannel(:), greenChannel(:), blueChannel(:)]);

[n,m,~] = MeanShiftCluster(data',14,0);

n=n';

m=reshape(m',size(maskedRgbImage,1),size(maskedRgbImage,2));

n=n/255;

%Return clustered image to rgb
clusteredImage=label2rgb(m,n);


nexttile;

imshow(clusteredImage);

title('Mean Shift');


%get specific clusters
imagethreshold = m;
imagethreshold(m>4) = 0;
imagethreshold(m<4) = 0;
nexttile;

imshow(imagethreshold);
title('Mean Shift Thresholded Clusters');

%dilate specific clusters
nexttile;
se = strel('disk',2);
dltd = imdilate(imagethreshold,se);
imshow(dltd);
title('Dilated Thresholded Clusters');


%Binarize original mean shift
nexttile;
g = rgb2gray(clusteredImage);
T = adaptthresh(g,0.5);         
BW = imbinarize(g,T);
imshow(BW)
title('Binarized M.S');