clear;clc;close all;
%Calculate the normalised grey-level co-occurrence matrix in four orientations (0°, 45°, 90°, 135°)
%for the patches from both classes
%, separately for each of the colour channels (red, green, blue, near infra-red)
% For each orientation, calculate the first three features proposed by Haralick et al. (Angular Second Moment, Contrast, Correlation)
% and produce per-patch features by calculating the feature average and range across the 4 orientations


p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions";

fc = feature_calc;


file_list = dir(p);

imsRGB = {}; %images
imsINF = {};

featFuncs = feature_calc; %get created functions

gt_ims = {}; %onion gt images

%add to list of images and labels to be processed
for i = 1:numel(file_list)
    
    file = file_list(i);
    [filepath,name,ext] = fileparts(file.name);
    abs_path = fullfile(file.folder, file.name);

    %if file name contains label, add to GT (Ground Truth) list
    if regexp(file.name, "\d\d_truth\.png")
        logIm = imread(abs_path); % load image
        greyIm = rgb2gray(logIm);%convert to greyscale
        gt_ims{end+1} = greyIm; % append to image array
    end
    
    if regexp(file.name, "\d\d_rgb\.png")
        rgb = imread(abs_path); % load image
        imsRGB{end+1} = rgb; % append to image array
    end
    
    if regexp(file.name, "\d\d_depth\.png")
        dep = imread(abs_path); % load image
        imsINF{end+1} = dep; % append to image array
    end   
    
end

%per image waitbar
wb = waitbar(0,'Calculating texture features for image: 1');

WeedredFeats = zeros(1,6);
OnionredFeats = zeros(1,6);
WeedgreenFeats = zeros(1,6);
OniongreenFeats = zeros(1,6);
WeedblueFeats = zeros(1,6);
OnionblueFeats = zeros(1,6);
WeedinfFeats = zeros(1,6);
OnioninfFeats = zeros(1,6);

for l=1: length(gt_ims)
    im = cell2mat(gt_ims(l));
    oniM = im == 76;
    
    weedM = im == 29;
    
    %get texture features for each channel, and each class...
    [~, wFeatsR] = fc.getTextureFeatures("Weeds",weedM,cell2mat(imsRGB(l)),"red");
    [~, oFeatsR] = fc.getTextureFeatures("Onions",oniM,cell2mat(imsRGB(l)),"red");
    
    [~, wFeatsG] = fc.getTextureFeatures("Weeds",weedM,cell2mat(imsRGB(l)),"green");
    [~, oFeatsG] = fc.getTextureFeatures("Onions",oniM,cell2mat(imsRGB(l)),"green");

    [~, wFeatsB] = fc.getTextureFeatures("Weeds",weedM,cell2mat(imsRGB(l)),"blue");
    [~, oFeatsB] = fc.getTextureFeatures("Onions",oniM,cell2mat(imsRGB(l)),"blue");

    [~, wFeatsINF] = fc.getTextureFeatures("Weeds",weedM,cell2mat(imsINF(l)),"inf");
    [~, oFeatsINF] = fc.getTextureFeatures("Onions",oniM,cell2mat(imsINF(l)),"inf");
    
    WeedredFeats = [WeedredFeats; wFeatsR];
    OnionredFeats = [OnionredFeats; oFeatsR];
    
    WeedgreenFeats = [WeedgreenFeats; wFeatsG];
    OniongreenFeats = [OniongreenFeats; oFeatsG];
    
    WeedblueFeats = [WeedblueFeats; wFeatsB];
    OnionblueFeats = [OnionblueFeats; oFeatsB];
    
    WeedinfFeats = [WeedinfFeats; wFeatsINF];
    OnioninfFeats = [OnioninfFeats; oFeatsINF];
    
    image_no = int2str((l+1));
    waitbar_update = "Calculating texture features for image: " + image_no;
    waitbar((l/length(gt_ims)),wb,waitbar_update);
    
end

close(wb)



featureNs = ["Mean Ang 2nd Moment", "Range Ang 2nd Moment", "Mean Contrast", "Range Contrast", "Mean Correlation", "Range Correlation"];


%removing first row from zeros instantiation
WeedredFeats(1,:) = [];
OnionredFeats(1,:) = [];
WeedgreenFeats(1,:)= [];
OniongreenFeats(1,:)= [];
WeedblueFeats(1,:)= [];
OnionblueFeats(1,:)= [];
WeedinfFeats(1,:)= [];
OnioninfFeats(1,:)= [];

%Save to text files... do not want to run again
writematrix(WeedredFeats,"./savedTextureFeats/redWeedFeatures.txt");
writematrix(OnionredFeats,"./savedTextureFeats/redOnionFeatures.txt");
writematrix(WeedgreenFeats,"./savedTextureFeats/greenWeedFeatures.txt");
writematrix(OniongreenFeats,"./savedTextureFeats/greenOnionFeatures.txt");
writematrix(WeedblueFeats,"./savedTextureFeats/blueWeedFeatures.txt");
writematrix(OnionblueFeats,"./savedTextureFeats/blueOnionFeatures.txt");
writematrix(WeedinfFeats,"./savedTextureFeats/INFWeedFeatures.txt");
writematrix(OnioninfFeats,"./savedTextureFeats/INFOnionFeatures.txt");
