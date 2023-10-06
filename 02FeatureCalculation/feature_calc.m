%This file contains home-made functions for feature calculation
%tasks
classdef feature_calc
    methods
        %get shape feature calculations
        function [featNames, featCalcs] = getFeatures(self,binIm)
            %gets feature calculations
            %single out onions, compute features
            rp = regionprops(binIm,"Circularity","Eccentricity","Solidity","Perimeter","Area");
            
            circs = [];
            eccs = [];
            ss = [];
            nComps = [];
            
            for i = 1: length(rp)
                circs = [circs; rp(i).Circularity];
                eccs = [eccs; rp(i).Eccentricity];
                ss = [ss ; rp(i).Solidity];
                p = rp(i).Perimeter;
                a = rp(i).Area;               

                nComp = (p/(2*pi*(sqrt(a/pi))));     %inverse of Schwartzberg           
                nComps = [nComps; nComp]; 
                
            end  
            featNames = ["Circularity","Eccentricity","Solidity","NonCompactness"]; 
            featCalcs = [circs eccs ss nComps]; 
        end
        
        %get texture feature calculations
        function [featNames, featCalcs] = getTextureFeatures(self, patch_type, patch_im, rgbIm, chan_type)
            
            %label individual connected components
            wCC = bwlabel(patch_im);
            wCC_count = bwconncomp(wCC).NumObjects;
            
            chann = self.getChannel(rgbIm,chan_type);
            
            %orientations for greycomatrix
            angles = [[0 1];[-1 1];[-1 0];[-1 -1]];

            
            %mean features
            Masms = zeros(wCC_count,1);
            Mconts = zeros(wCC_count,1);
            Mcorrs = zeros(wCC_count,1);
            
            %range features
            Rasms = zeros(wCC_count,1);
            Rconts = zeros(wCC_count,1);
            Rcorrs = zeros(wCC_count,1);
            
            %waitbar ('cos it takes a while!)
            waitbar_text = "Calculating " + chan_type +" channel texture features: " + patch_type; 
            f = waitbar(0,waitbar_text);
            
            %for each object
            for j = 1: wCC_count
                chan = chann;
                binaryImage = ismember(wCC, j);
                chan(~binaryImage) = NaN;
            
                asms = zeros(1,4);
                conts = zeros(1,4);
                corrs = zeros(1,4);
            
                %for each angle
                for i=1: length(angles)
                    %get graylevel covariance matrix
                    glcm = graycomatrix(chan, 'offset', angles(i,:),'NumLevels', 256, 'Symmetric', false);  
                    asm = sum(glcm(:).^2);%get Mean angular 2nd moment
                    asms(i) = asm;
                    stats = graycoprops(glcm,["Contrast","Correlation"]);
                    conts(i) = stats.Contrast;
                    corrs(i) = stats.Correlation;
                end
                
                Masms(j,1) = mean(asms);
                Rasms(j,1) = range(asms);
                
                Mconts(j,1) = mean(conts);
                Rconts(j,1) = range(conts);
                
                Mcorrs(j,1) = mean(corrs);
                Rcorrs(j,1) = range(corrs);
                
            
                waitbar((j/wCC_count),f);
            end
            featNames = ["Mean Ang 2nd Moment", "Range Ang 2nd Moment", "Mean Contrast", "Range Contrast", "Mean Correlation", "Range Correlation"];
            featCalcs = [Masms Rasms Mcorrs Rcorrs Mconts Rconts];
            close(f)
        end
        
        %gets image channel based on input
        function [chanIm] = getChannel(~, im, chanString)
            if chanString == "red"
                [R,G,B] = imsplit(im);
                chanIm = R;
            
            elseif chanString == "green"
                [R,G,B] = imsplit(im);
                chanIm = G;

            elseif chanString == "blue"
                [R,G,B] = imsplit(im);
                chanIm = B;

            elseif chanString == "inf"
                chanIm = im;

            end
        end  
    end
end