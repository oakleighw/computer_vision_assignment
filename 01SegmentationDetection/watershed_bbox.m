%Visualises bounding boxes using watershed method.
clc;clear;close all;

%read images and compare
clear; close all;

t = tiledlayout(4,4,'TileSpacing','Compact');

p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset";

file_list = dir(p);%get directory content
GTCountsFile = readmatrix('Leaf_counts.csv');
GTCounts = GTCountsFile(:,2);% Ground Truth leaf counts

seg_plant = segment_plant; %get created functions

OG = {}; %original images

fnames = []; %list of file names
wss = []; %watershed count

%add to list of images and labels to be processed
for i = 1:numel(file_list)
    
    file = file_list(i);
    [filepath,name,ext] = fileparts(file.name);
    abs_path = fullfile(file.folder, file.name);
    
    %if file name rgb, add to image list
    if regexp(file.name, "plant[0-9]+_rgb\.png")
        fn = string(file.name);
        fnames = [fnames fn];
        I = imread(abs_path); % load image
        OG{end+1} = I; % append to image array
    end  
end

for l=1:length(OG)
    og = cell2mat(OG(l));
    %get segmented mask
    segmented = seg_plant.getBinMask(og);

    maskedRgbImage = bsxfun(@times, og, cast(segmented, 'like', og));

    grey = im2gray(maskedRgbImage);
    bw = imbinarize(grey);
    
    se = strel('disk',4);
    se2 = strel('disk',3);
    op = imopen(bw,se);
    op = imdilate(op,se2);
    
    
    
    D = bwdist(~op);
    D= -D;
    L = watershed(D);
    L(~op) = 0;
    L = bwareaopen(L, 105);
    bbox = regionprops(L,'BoundingBox');
    stats = length(regionprops(L));
    rgb = label2rgb(L,'jet',[.5 .5 .5]);
    

    nexttile;
    imshow(maskedRgbImage);
    hold on 
    
    for k = 1:numel(bbox)
        rectangle('Position', bbox(k).BoundingBox, 'EdgeColor', 'r');
    end
    title(fnames(l))
end



