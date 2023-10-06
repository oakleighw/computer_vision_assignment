clear;clc;close all;

%counts objects for SVM train/test splitting 

p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions";
ims = {};

%calculate how many weeds/onions are in images 1-18 for split
file_list = dir(p);

%add to list of images and labels to be processed
for i = 1:numel(file_list)
    
    file = file_list(i);
    [filepath,name,ext] = fileparts(file.name);
    abs_path = fullfile(file.folder, file.name);

    %if file name contains label, add to GT (Ground Truth) list
    if regexp(file.name, "\d\d_truth\.png")
        logIm = imread(abs_path); % load image
        greyIm = rgb2gray(logIm);%convert to greyscale
        ims{end+1} = greyIm; % append to image array
    end   
    
end

trainWCount = 0;
trainOCount = 0;

testWcounts = [];
testOcounts = [];


for i=1:18
    im = cell2mat(ims(i));
    weed = im == 29;
    oni = im == 76;

    wcount = bwconncomp(weed).NumObjects;
    ocount = bwconncomp(oni).NumObjects;
    trainWCount = trainWCount + wcount;
    trainOCount = trainOCount + ocount;
end

% Train WeedCount 452 OnionCount 918


%%%%%%%
%Find weeds/ onions in test images for visualisation%
%%%%%%%
for i=19:20
    im = cell2mat(ims(i));
    weed = im == 29;
    oni = im == 76;

    wcount = bwconncomp(weed).NumObjects;
    ocount = bwconncomp(oni).NumObjects;
    testWcounts = [testWcounts wcount];
    testOcounts = [testOcounts ocount];
end

display(trainWCount);
display(trainOCount);
display(testWcounts);
display(testOcounts);
