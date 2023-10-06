clear;clc;close all;
%Plot Texture Features for Each Channel (reads txt file)

redOnionFeat = readmatrix("./savedTextureFeats/redOnionFeatures.txt");
redWeedFeat = readmatrix("./savedTextureFeats/redWeedFeatures.txt");

greenOnionFeat = readmatrix("./savedTextureFeats/greenOnionFeatures.txt");
greenWeedFeat = readmatrix("./savedTextureFeats/greenWeedFeatures.txt");

blueOnionFeat = readmatrix("./savedTextureFeats/blueOnionFeatures.txt");
blueWeedFeat = readmatrix("./savedTextureFeats/blueWeedFeatures.txt");

infOnionFeat = readmatrix("./savedTextureFeats/INFOnionFeatures.txt");
infWeedFeat = readmatrix("./savedTextureFeats/INFWeedFeatures.txt");

featureNs = ["Mean Ang 2nd Moment", "Range Ang 2nd Moment", "Mean Contrast", "Range Contrast", "Mean Correlation", "Range Correlation"];

%plotting hists

figure;
t = tiledlayout(2,3,"TileSpacing","compact");
for i = 1:length(featureNs)
    nexttile;

    histogram(redOnionFeat(:,i),Normalization="probability");
    t_name = "Red Channel " + featureNs(i);
    title(t_name);
    
    hold;
    histogram(redWeedFeat(:,i),Normalization="probability");
    xlabel("Values");
    ylabel("Counts");
    legend(["Onion","Weed"]);
    %legend("Location","northwest");
    axis padded;
end

figure;
t = tiledlayout(2,3,"TileSpacing","compact");
for i = 1:length(featureNs)
    nexttile;
    
    histogram(greenOnionFeat(:,i),Normalization="probability");
    
    t_name = "Green Channel " + featureNs(i);
    title(t_name);
    
    hold;
    histogram(greenWeedFeat(:,i),Normalization="probability");
    xlabel("Values");
    ylabel("Counts");
    legend(["Onion","Weed"]);
    %legend("Location","northwest");
    axis padded;
end

figure;
t = tiledlayout(2,3,"TileSpacing","compact");
for i = 1:length(featureNs)
    nexttile;
    
    histogram(blueOnionFeat(:,i),Normalization="probability");
    
    t_name = "Blue Channel " + featureNs(i);
    title(t_name);
    
    hold;
    histogram(blueWeedFeat(:,i),Normalization="probability");
    xlabel("Values");
    ylabel("Counts");
    legend(["Onion","Weed"]);
    %legend("Location","northwest");
    axis padded;
end

figure;
t = tiledlayout(2,3,"TileSpacing","compact");
for i = 1:length(featureNs)
    nexttile;

    histogram(infOnionFeat(:,i),Normalization="probability");   
    t_name = "NearInfraRed Channel " + featureNs(i);
    title(t_name);
    
    hold;
    histogram(infWeedFeat(:,i),Normalization="probability");
    xlabel("Values");
    ylabel("Counts");
    legend(["Onion","Weed"]);
    %legend("Location","northwest");
    axis padded;
end

