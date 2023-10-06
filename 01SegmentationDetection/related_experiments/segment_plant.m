%This file contains home-made functions for the segmentation/detection tasks
%Replicated in this folder such that experiments that use the functions
%work

classdef segment_plant
    methods
      %get binary mask (uses morphology) other functions may use this mask
      %'segmentmask'
        function [mask] = getBinMask(~,im)
            %Keeps green channel and converts B and R to 'black' channel
            %https://uk.mathworks.com/help/images/display-separated-color-channels-of-rgb-image.html
            [~,G,~] = imsplit(im);
            allBlack = zeros(size(im,1,2),class(im));
            justG = cat(3,allBlack,G,allBlack);
            
            %Convert to Greyscale
            grey = rgb2gray(justG);
            
            %Median Filter to remove noise
            Kmedian = medfilt2(grey);
            
            %Contrast Adjustment
            J = imadjust(Kmedian,[0.15 1],[]);
            
            %Binarize using custom threshold
            T = adaptthresh(J,0.73);
            BW = imbinarize(J,T);
            
            %Remove components connected to border
            CB = imclearborder(BW);
            
            %Remove Small Objects
            m = bwareaopen(CB, 150);
            
            %get original image segmented by mask
            maskedRgbImage = bsxfun(@times, im, cast(m, 'like', im));
               
            %now remove remaining 'brown' areas stuck to leaves by
            %converting to 'lab' colour space
            lab = rgb2lab(maskedRgbImage);
            
            labRemover = imbinarize(1-(~lab(:,:,1) + lab(:,:,2)));
            
            mask = bwareaopen(labRemover,5);
             
        end
        function [leafCountPreOpen,leafCountPostOpen] = segmentHoughCount(~,segmentMask)
            %hough transform
            [c1, ~] = imfindcircles(segmentMask,[6,30], 'Sensitivity', 0.9);
            leafCountPreOpen = length(c1);
            
            %opening to segment leaves
            se = strel("disk", 4);
            op = imopen(segmentMask, se);
            
            %hough transform
            [c1, ~] = imfindcircles(op,[6,30], 'Sensitivity', 0.9);
            leafCountPostOpen = length(c1);

        end
        function [CCCount] = connectedCompCount(~,segmentMask)
            %opening and connected component count
            se = strel("disk", 4);
            op = imopen(segmentMask, se);
            CCCount = bwconncomp(op).NumObjects;
            
        end 
        %get sift points to see if there is a way to match leaf count
        function [sift_points] = returnSIFTPoints(~,im, segmentmask) % returns SIFT points from image
            
            %get original image segmented by mask
            maskedRgbImage = bsxfun(@times, im, cast(segmentmask, 'like', im));


            grey = rgb2gray(maskedRgbImage);


            sift_points = detectSIFTFeatures(grey, ContrastThreshold= 0.06);
        

        end
        %watershed transform to segment contiguous regions of interest
        %(i.e. split 'connected' leaves)
        %https://uk.mathworks.com/help/images/ref/watershed.html
        function [ws_count] = getWatershed(~,im, segmentmask) % returns watershed count
            
            %get original image segmented by mask
            maskedRgbImage = bsxfun(@times, im, cast(segmentmask, 'like', im));

            grey = im2gray(maskedRgbImage);
            bw = imbinarize(grey);
            
            %open to remove stalks; dilate to remove unwanted leave
            %'ridges' (which watershed is sensitive to)
            se = strel('disk',4); 
            se2 = strel('disk',2); 
            op = imopen(bw,se); %open
            op = imdilate(op,se2); %dilate

            D = bwdist(~op);

            D= -D;
            L = watershed(D);
            L(~op) = 0;
            L = bwareaopen(L, 105); % remove small detections (not leaves)
            ws_count = length(regionprops(L));
        

        end
        function [mlce] = meanLeafCountError(~,GT,Pred)
            %gets mean leaf count error when given ground truth and
            %predicted value array.
            errors = [];
            for i = 1:length(GT)
                error = abs(GT(i)-Pred(i));
                errors = [errors error];
            end
            mlce = mean(errors);

        end
    end
end