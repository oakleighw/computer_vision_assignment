%calculate shape features


clear;clc;close all;
p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions";

file_list = dir(p);

ims = {}; %images

featFuncs = feature_calc; %get created functions

%onion features
Ocircs = []; 
Oeccs = [];
Oss = [];
OnComps = [];

%weed features
Wcircs = []; 
Weccs = [];
Wss = [];
WnComps = [];



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
f = waitbar(0,'Calculating Shape Features');

for l=1:length(ims)
    im = cell2mat(ims(l));
    %extract weeds and onions using label threshold
    oni = im == 76;
    
    weed = im == 29;

    %get features for each class in image
    [~, oniFeats] = featFuncs.getFeatures(oni);
    [~, weedFeats] = featFuncs.getFeatures(weed);
    
    %update onion features
    Ocircs = [Ocircs ;oniFeats(:,1)]; 
    Oeccs = [Oeccs ;oniFeats(:,2)];
    Oss = [Oss ;oniFeats(:,3)];
    OnComps = [OnComps ;oniFeats(:,4)];

    %update weed features
    Wcircs = [Wcircs ;weedFeats(:,1)]; 
    Weccs = [Weccs ;weedFeats(:,2)];
    Wss = [Wss ;weedFeats(:,3)];
    WnComps = [WnComps ;weedFeats(:,4)];
    waitbar((l/length(ims)),f,'Calculating Shape Features');
    
end

featureNs = ["Circularity","Eccentricity","Solidity","NonCompactness"];
oFeats = [Ocircs Oeccs Oss OnComps];
wFeats = [Wcircs Weccs Wss WnComps];

%write shape features to text file
writematrix(oFeats,"./savedShapeFeats/OnionShapeFeatures.txt");
writematrix(wFeats,"./savedShapeFeats/WeedShapeFeatures.txt");

close(f)


t = tiledlayout(2,2,"TileSpacing","compact");

%display shape feature distributions
for i = 1:length(featureNs)
    nexttile;

    histogram(oFeats(:,i),Normalization="probability");
    t_name = featureNs(i);
    title(t_name);

    hold;

    histogram(wFeats(:,i),Normalization="probability");
    xlabel("Values");
    ylabel("Counts");
    legend(["Onion","Weed"]);
    %legend("Location","northwest");
    axis padded;
end



