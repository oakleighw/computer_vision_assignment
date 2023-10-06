%Get's leaf counts for each method explored as a table, compares average error for each method (command window output).
clear; close all;

p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset";

file_list = dir(p);%get directory content
GTCountsFile = readmatrix('Leaf_counts.csv');
GTCounts = GTCountsFile(:,2);% Ground Truth leaf counts

seg_plant = segment_plant; %get created functions

OG = {}; %original images

fnames = []; %list of file names
Hough1counts = [];%leaf counts (Hough, no opening)
Hough2counts = [];%leaf counts (Hough, opening)
CCcounts = []; %leaf counts (Connected Components)
sifts = []; %sift points
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
    %get leaf counts using various methods
    [Hough1c,Hough2c] = seg_plant.segmentHoughCount(segmented); %hough pre and post opening
    ccC = seg_plant.connectedCompCount(segmented); %opening and counting connected components
    
    %append to lists
    Hough1counts = [Hough1counts,Hough1c];
    Hough2counts = [Hough2counts,Hough2c];
    CCcounts = [CCcounts ccC];
    sifts = [sifts seg_plant.returnSIFTPoints(og, segmented).Count];
    wss = [wss seg_plant.getWatershed(og, segmented)];
end

%reshape arrays for table
fnames = reshape(fnames,[length(fnames),1]);
Hough1counts = reshape(Hough1counts,[length(Hough1counts),1]);
Hough2counts = reshape(Hough2counts,[length(Hough2counts),1]);
CCcounts = reshape(CCcounts,[length(CCcounts),1]);
sifts = reshape(sifts,[length(sifts),1]);
wss = reshape(wss,[length(wss),1]);
 
%create & display table
metrics = table(fnames,GTCounts,Hough1counts,Hough2counts, CCcounts,sifts,wss);
display(metrics);

%get errors
method = ["Hough" , "HoughOpened", "ConnectedComp","SIFT","Watershed"];
error = [seg_plant.meanLeafCountError(GTCounts,Hough1counts), ...
    seg_plant.meanLeafCountError(GTCounts,Hough2counts), ...
    seg_plant.meanLeafCountError(GTCounts,CCcounts), ...
    seg_plant.meanLeafCountError(GTCounts,sifts), ...
    seg_plant.meanLeafCountError(GTCounts,wss)];

method = reshape(method,[length(method),1]);
error = reshape(error,[length(error),1]);

errorMetrics = table(method,error);
display(errorMetrics);



