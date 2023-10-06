clc;clear;close all;

clear
I=imread("C:\Users\oakle\OneDrive - University of Lincoln\MSc Intelligent Vision\CompVision\assessment\data\plant image dataset\plant001_rgb.png");
I=double(I);
class_number=3;
potential=0.5;
maxIter=30;
%seg=ICM(I,class_number,potential,maxIter);
figure;
imshow(I);

%cant use this or k-means clustering --> requires specific amount of
%classes (cant know leaves initial value)