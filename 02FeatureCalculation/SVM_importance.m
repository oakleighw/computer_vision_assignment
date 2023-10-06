clear;clc;close all;

%SVM comparison & Importance analysis


p = "C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions";

%%%%%%%%%%%%%%%%%%%%
%Only Shape Features
%%%%%%%%%%%%%%%%%%%%

%train onions = 918 train weeds = 453 
shapeFeatsO = readmatrix("./savedShapeFeats/OnionShapeFeatures.txt");
shapeFeatsW = readmatrix("./savedShapeFeats/WeedShapeFeatures.txt");


%onions = label 0; weeds = label 1;
%train
shapeTrainFeats = [shapeFeatsO(1:918,:) ; shapeFeatsW(1:453,:)];
trainLabels = [zeros(918,1); ones(453,1)];

%test
testFeats = [shapeFeatsO(919:end,:) ; shapeFeatsW(454:end,:)]; %198
testLabels = [zeros(88,1) ; ones(109,1)];

%fit SVM
SVMModel = fitcsvm(shapeTrainFeats,trainLabels);

%predict
[predictions,~] = predict(SVMModel,testFeats);

%confusion matrix
C = confusionmat(testLabels,predictions);

%get precision and recall for each class
shapePrecision = diag(C) ./ sum(C,2);
shapeRecall = diag(C) ./ sum(C,1)';

shapeF1 = 2 * (mean(shapePrecision) * mean(shapeRecall))/ (mean(shapePrecision) + mean(shapeRecall));

figure;
shapeCc = confusionchart(C);
shapeCc.Title = "Onions/Weeds Shape Confusion Matrix";


%%%%%%%%%%%%%%%%%%%%
%Only Texture Features
%%%%%%%%%%%%%%%%%%%%
textFeatsRedO = readmatrix("./savedTextureFeats/redOnionFeatures.txt");
textFeatsRedW = readmatrix("./savedTextureFeats/redWeedFeatures.txt");

textFeatsGreenO = readmatrix("./savedTextureFeats/greenOnionFeatures.txt");
textFeatsGreenW = readmatrix("./savedTextureFeats/greenWeedFeatures.txt");

textFeatsBlueO = readmatrix("./savedTextureFeats/blueOnionFeatures.txt");
textFeatsBlueW = readmatrix("./savedTextureFeats/blueWeedFeatures.txt");

textFeatsInfO = readmatrix("./savedTextureFeats/INFOnionFeatures.txt");
textFeatsInfW = readmatrix("./savedTextureFeats/INFWeedFeatures.txt");

textFeatsO = [textFeatsRedO textFeatsGreenO textFeatsBlueO textFeatsInfO];
textFeatsW = [textFeatsRedW textFeatsGreenW textFeatsBlueW textFeatsInfW];

%train
textTrainFeats = [textFeatsO(1:918,:) ; textFeatsW(1:453,:)];
trainLabels = [zeros(918,1); ones(453,1)];

%test
testFeats = [textFeatsO(919:end,:) ; textFeatsW(454:end,:)]; 
testLabels = [zeros(88,1) ; ones(109,1)];

%fit SVM
SVMModel = fitcsvm(textTrainFeats,trainLabels);

%predict
[predictions,~] = predict(SVMModel,testFeats);

%confusion matrix
C = confusionmat(testLabels,predictions);

%get precision and recall for each class
textPrecision = diag(C) ./ sum(C,2);
textRecall = diag(C) ./ sum(C,1)';
textF1 = 2 * (mean(textPrecision) * mean(shapeRecall)) / (mean(textPrecision) + mean(shapeRecall));

figure;
textCc = confusionchart(C);
textCc.Title = "Onions/Weeds Texture Confusion Matrix";

%%%%%%%%%%%%%%%%%%%%
%Shape & Texture Features
%%%%%%%%%%%%%%%%%%%%
shapeTextO = [shapeFeatsO textFeatsO];
shapeTextW = [shapeFeatsW textFeatsW];

%train
shapeTextTrainFeats = [shapeTextO(1:918,:) ; shapeTextW(1:453,:)];
trainLabels = [zeros(918,1); ones(453,1)];

%test
testFeats = [shapeTextO(919:end,:) ; shapeTextW(454:end,:)]; 
testLabels = [zeros(88,1) ; ones(109,1)];

%fit SVM
SVMModel = fitcsvm(shapeTextTrainFeats,trainLabels);

%predict
[predictions,~] = predict(SVMModel,testFeats);

%confusion matrix
C = confusionmat(testLabels,predictions);

%get precision and recall for each class
shapeTextPrecision = diag(C) ./ sum(C,2);
shapeTextRecall = diag(C) ./ sum(C,1)';
shapeTextF1 = 2 * (mean(shapeTextPrecision) * mean(shapeTextRecall)) / (mean(shapeTextPrecision) + mean(shapeTextRecall));

figure;
shapeTextCc = confusionchart(C);
shapeTextCc.Title = "Onions/Weeds Shape & Texture Confusion Matrix";

%%%%%%%%%%%%%%%%%%%%
%Importance Scores
%%%%%%%%%%%%%%%%%%%%
full_data = [shapeTextTrainFeats trainLabels];
%Create table from data
full_data_T = array2table(full_data,'VariableNames', ...
    {'Circularity','Eccentricity','Solidity','NonCompactness'...
    'Red_Mean_Ang_2nd_Moment', 'Red_Range_Ang_2nd_Moment', 'Red_Mean_Contrast', 'Red_Range_Contrast', 'Red_Mean_Correlation', 'Red_Range_Correlation', ...
    'Green_Mean_Ang_2nd_Moment', 'Green_Range_Ang_2nd_Moment', 'Green_Mean_Contrast', 'Green_Range_Contrast', 'Green_Mean_Correlation', 'Green_Range_Correlation', ...
    'Blue_Mean_Ang_2nd_Moment', 'Blue_Range_Ang_2nd_Moment', 'Blue_Mean_Contrast', 'Blue_Range_Contrast', 'Blue_Mean_Correlation', 'Blue_Range_Correlation', ...
    'INF_Mean_Ang_2nd_Moment', 'INF_Range_Ang_2nd_Moment', 'INF_Mean_Contrast', 'INF_Range_Contrast', 'INF_Mean_Correlation', 'INF_Range_Correlation',...
    'patch_type'});

[idx,scores] = fscchi2(full_data_T,'patch_type');
figure;
bar(scores(idx));
set(gca,'xtick',1:28);
xticklabels(strrep(full_data_T.Properties.VariableNames(idx),'_','\_'));
xtickangle(45);
xlabel('Predictor rank')
ylabel('Predictor importance score')

%%%%%%%%%%%%%%%%%%%%
%Importance-Chosen (10) Features
%%%%%%%%%%%%%%%%%%%%
%10 most important are:
%Solidity; Circularity; NonCompactness; Red_Range_Contrast;
%Green_Range_Contrast; Blue_Range_Contrast; INF_Range_Contrast;
%Green_Mean_Contrast; Blue_Range_Correlation; Red_Mean_Contrast;

import_features = full_data_T{:,["Solidity","Circularity","NonCompactness","Red_Range_Contrast",...
    "Green_Range_Contrast","Blue_Range_Contrast","INF_Range_Contrast","Green_Mean_Contrast","Blue_Range_Correlation","Red_Mean_Contrast"]};


trainLabels = [zeros(918,1); ones(453,1)];



%test
testFeats = [shapeTextO(919:end,:) ; shapeTextW(454:end,:)];


%Extract important features from test too
full_test_T = array2table(testFeats,'VariableNames', ...
    {'Circularity','Eccentricity','Solidity','NonCompactness'...
    'Red_Mean_Ang_2nd_Moment', 'Red_Range_Ang_2nd_Moment', 'Red_Mean_Contrast', 'Red_Range_Contrast', 'Red_Mean_Correlation', 'Red_Range_Correlation', ...
    'Green_Mean_Ang_2nd_Moment', 'Green_Range_Ang_2nd_Moment', 'Green_Mean_Contrast', 'Green_Range_Contrast', 'Green_Mean_Correlation', 'Green_Range_Correlation', ...
    'Blue_Mean_Ang_2nd_Moment', 'Blue_Range_Ang_2nd_Moment', 'Blue_Mean_Contrast', 'Blue_Range_Contrast', 'Blue_Mean_Correlation', 'Blue_Range_Correlation', ...
    'INF_Mean_Ang_2nd_Moment', 'INF_Range_Ang_2nd_Moment', 'INF_Mean_Contrast', 'INF_Range_Contrast', 'INF_Mean_Correlation', 'INF_Range_Correlation'});

import_test = full_test_T{:,["Solidity","Circularity","NonCompactness","Red_Range_Contrast",...
    "Green_Range_Contrast","Blue_Range_Contrast","INF_Range_Contrast","Green_Mean_Contrast","Blue_Range_Correlation","Red_Mean_Contrast"]};


testLabels = [zeros(88,1) ; ones(109,1)];

%fit SVM
SVMModel = fitcsvm(import_features,trainLabels);

%predict
[predictions,~] = predict(SVMModel,import_test);

%confusion matrix
C = confusionmat(testLabels,predictions);

%get precision and recall for each class
ImportPrecision = diag(C) ./ sum(C,2);
ImportRecall = diag(C) ./ sum(C,1)';
ImportF1 = 2 * (mean(ImportPrecision) * mean(ImportRecall)) / (mean(ImportPrecision) + mean(ImportRecall));

figure;
ImportCc = confusionchart(C);
ImportCc.Title = "Onions/Weeds Importance (10) Confusion Matrix";

%%%%%%%%%%%%%%%%%%%%
%Less (4) Importance-Chosen Features
%%%%%%%%%%%%%%%%%%%%
import_features = full_data_T{:,["Solidity","Circularity","NonCompactness","Red_Range_Contrast"]};


trainLabels = [zeros(918,1); ones(453,1)];



%test
testFeats = [shapeTextO(919:end,:) ; shapeTextW(454:end,:)];


import_test = full_test_T{:,["Solidity","Circularity","NonCompactness","Red_Range_Contrast"]};


testLabels = [zeros(88,1) ; ones(109,1)];

%fit SVM
SVMModel = fitcsvm(import_features,trainLabels);

%predict
[predictions,~] = predict(SVMModel,import_test);

%confusion matrix
C = confusionmat(testLabels,predictions);

%get precision and recall for each class
ReducedImpPrecision = diag(C) ./ sum(C,2);
ReducedImpRecall = diag(C) ./ sum(C,1)';
ReducedImpF1 = 2 * (mean(ReducedImpPrecision) * mean(ImportRecall)) / (mean(ReducedImpPrecision) + mean(ImportRecall));

figure;
ReducedImpCc = confusionchart(C);
ReducedImpCc.Title = "Onions/Weeds Reduced Importance (4) Confusion Matrix";



%get table of metrics
SVM_Features = ["All_Shape", "All_Texture", "Shape_Texture", "10_Important", "4_Important"]';

Onion_Precision = [shapePrecision(1),textPrecision(1),shapeTextPrecision(1),ImportPrecision(1),ReducedImpPrecision(1)]';
Weed_Precision = [shapePrecision(2),textPrecision(2),shapeTextPrecision(2),ImportPrecision(2),ReducedImpPrecision(2)]';

Onion_Recall = [shapeRecall(1),textRecall(1),shapeTextRecall(1),ImportRecall(1),ReducedImpRecall(1)]';
Weed_Recall = [shapeRecall(2),textRecall(2),shapeTextRecall(2),ImportRecall(2),ReducedImpRecall(2)]';

F1 = [shapeF1,textF1,shapeTextF1,ImportF1,ReducedImpF1]';

SVM_metrics = table(SVM_Features,Onion_Precision,Weed_Precision,Onion_Recall,Weed_Recall,F1);
display(SVM_metrics);


%%%%%%%%%%%%%%%%%%%%%%%%
%Output Image Predictions
%%%%%%%%%%%%%%%%%%%%%%%%
figure;
test1 = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions\19_truth.png");
test2 = imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\onions\20_truth.png");
test1O = predictions'; test1O= test1O(1:44);
test2O = predictions'; test2O= test2O(45:88);

test1W = predictions'; test1W= test1W(89:132);
test2W = predictions'; test2W= test2W(133:end);

t = tiledlayout(2,1,"TileSpacing","compact");
nexttile;
im = im2gray(test1);

%extract objects from ground truth
oni = im == 76;

weed = im == 29;

[lOnion,n_onion] = bwlabel(oni);
[lWeed,n_weed] = bwlabel(weed);

%go through each onion/weed and relabel(colour) with prediction
for i = 1:n_onion
    onionN = ismember(lOnion,i);

    if test1O(i) == 0
        labl = 100;
    else
        labl = 300;
    end

    im(onionN) = labl;
end 

for i = 1:n_weed
    weedN = ismember(lWeed,i);

    if test1W(i) == 0
        labl = 300;
    else
        labl = 100;
    end

    im(weedN) = labl;
end 

imshowpair(test1,label2rgb(im,"turbo"),"montage");
title("Sample 19 GT vs Predictions");
nexttile;

im = im2gray(test2);
oni = im == 76;

weed = im == 29;

[lOnion,n_onion] = bwlabel(oni);
[lWeed,n_weed] = bwlabel(weed);


for i = 1:n_onion-1
    onionN = ismember(lOnion,i);

    if test2O(i) == 0
        labl = 100;
    else
        labl = 300;
    end

    im(onionN) = labl;
end 

for i = 1:n_weed
    weedN = ismember(lWeed,i);
    try %catches an error arose from txt file feature extraction indexing
        if test2W(i) == 0
            labl = 300;
        else
            labl = 100;
        end
    catch
        labl = 100;
    end
        im(weedN) = labl;      
end 

%show comparison.
imshowpair(test2,label2rgb(im,"turbo"),"montage");
title("Sample 20 GT vs Predictions");



