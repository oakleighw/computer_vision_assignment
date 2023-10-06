# CMP9135 Computer Vision Assessment (100%)

This is the code portion of the Computer Vision assignment. The structure of code is as follows;

## Image segmentation & detection (Plant leaf)
Contains code for plant segmentation and leaf detection/count.

+ **segment_plant.m**
    - Contains defined functions for segmenting plant, segmenting leaves (various methods), returning sift features and getting mean lead count.

+ **getPlantDice.m**
    - Gets DICE score of segmented whole-plant,  plots a histogram for each image, displays scores as a table and displays mean score (command window output) (0.96).
    
+ **count_leaves.m**
    - Get's leaf counts for each method explored as a table, compares average error for each method (command window output).
    
+ **watershed_bbox.m**
    - Visualises bounding boxes using watershed method.
    
+ related_experiments (directory)
    - Contains snippets of code used to display and compare methods of planet/leaf segmentation.
    - **segment_plant_experiments.m**: Contains experiments to segment plant from image
    - testLab.m: Color-Based Segmentation Using the L\*a\*b\* Color Space, removes the remaining 'brown' connected to leaves.
    
    - **count_leaves_experiment_connectedComponents.m**: Experiments with counting leaves via opening/ connected components.
    
    - **count_leaves_experiment_hough.m**: Experiments with hough transform/ pre-post opening to count leaves.
    
    - **MeanShiftCluster.m**: Stock meanshift function from https://uk.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering.
    
    - **testContrastDiff.m**: Attempts separating leaves using a change in contrast.
    
    - **testHarris.m**: Harris corner detection to attempt to find leaf splits.
    
    - **testHough_watershed.m**: compares hough transform with high sensitivity vs watershed method of leaf separation.

    - **testMarkovRFields.m**: Deprecated boilerplate code. Cannot count leaves with it as need initial k classes.
    
    - **testMeanShift.m**: Uses mean shift clustering to try and segment leaves.
    
    - **testSIFT.m**: Uses SIFT to attempt to count leaves as features (scale-invariant features).
    
    - **testSnakes.m**: Uses active contour to try and segment leaves.
    
+ savedShapeFeats (directory)
    - Contains saved extracted shape features for onions and weeds as text files.

+ savedTextureFeats (directory)
    - Contains saved extracted texture features for onions and weeds as text files, for each colour channel.
    


## Feature Calculation
Contains code for Onion/Weed feature extraction, analysis and classification.

- **feature_calc.m**: This file contains home-made core functions for feature calculation.
    
- **shape_feature_calc_all.m**: calculates shape features, displays distribution histograms, and saves them to text file.

- **texture_feature_calc_experiments_all.m**: calculates texture features (takes some time), and saves to text file.

- **feature_calc_readTXT_hist.m**: reads texture features from text files, and plots distribution histograms for each channel.

- **countObs1_18.m**: Counts onions/weeds for SVM train/test splitting.

- **SVM_importance.m**: Classifies different feature bunches with an SVM, performs importance analysis, reclassifies x2, visualizes classified test images.



## Object Tracking
Contains code for object tracking using Kalman Filter.

+ **kalmanTrackingSol.m**: Contains code for displaying ground truth trajectory, noisy observations trajectory, and computed predicted trajectory from observations. Displays mean error, standard deviation and root mean squared error (command window table output).


