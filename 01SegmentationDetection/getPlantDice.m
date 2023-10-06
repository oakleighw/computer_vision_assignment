%Gets DICE score of segmented whole-plant,  plots a histogram for each image, displays scores as a table and displays mean score (command window output) (0.96)
clear; close all;

% p = pwd;
% d = pwd + "\plant image dataset";
p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset";

file_list = dir(p);

seg_plant = segment_plant; %get created functions

GT = {}; %ground truth
OG = {}; %original images

scores = []; %dice scores
fnames = []; %list of file names

%add to list of images and labels to be processed
for i = 1:numel(file_list)
    
    file = file_list(i);
    [filepath,name,ext] = fileparts(file.name);
    abs_path = fullfile(file.folder, file.name);

    %if file name contains label, add to GT (Ground Truth) list
    if regexp(file.name, "plant[0-9]+_label\.png")
        I = imread(abs_path); % load image
        I = I > 0; %binarize
        GT{end+1} = I; % append to image array
    end
    
    %if file name rgb, add to image list
    if regexp(file.name, "plant[0-9]+_rgb\.png")
        fn = string(file.name);
        fnames = [fnames fn];
        I = imread(abs_path); % load image
        OG{end+1} = I; % append to image array
    end
    
end

for l=1:length(GT)
    label = cell2mat(GT(l));
    og = cell2mat(OG(l));
    pred = seg_plant.getBinMask(og);
    score = dice(pred,label);
    scores = [scores score];
    
end

%reshape arrays for table
fnames = reshape(fnames,[length(fnames),1]);
scores = reshape(scores,[length(scores),1]);

%create & display table
metrics = table(fnames,scores);
display(metrics);

%bar chart of dice scores
bar(scores);
title("Dice Scores of Plant Segmentation");
xlabel("Image Number");
xticks(1:length(scores));
ylabel("Dice Score");
%display mean dice score
fprintf("Mean Dice:");
m = mean(scores);
fprintf(string(m));
fprintf("\n");