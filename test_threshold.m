clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in
I = imread("RealIce4.jpg");
%I = imcrop(I);     % Users have the option of only analysing a specific region of the image.

%% Grayscaling Image
ImG = im2gray(I);


%% Threshold Algorithms
                                                       
sen = 0.7;      % Sensitivity value of the Adaptive method.
Im_Adap = imbinarize(ImG,"adaptive","Sensitivity",sen);     % Output of the Adaptive method.

thresh = graythresh(ImG);       % OTSU thresholding value.
Im_Otsu = imbinarize(ImG);      % Output of OTSU's method.


                                                     
thresh_figures = figure;        % Thresholding figures display.
subplot('Position',[0 0 0.5 0.95]);
imshow(Im_Otsu);
title("OTSU Thresholding");

subplot('Position',[0.5 0 0.5 0.95]);
imshow(Im_Adap);
title("MATLAB imbinarize Thresholding");

num = numel(ImG);

binary_hist = figure; 
subplot('Position',[0.05 0.1 0.4 0.8]);
x = histogram(Im_Otsu);
xticks([0 1]);
xticklabels(["Black","White"]);

E = x.BinEdges;
y = x.BinCounts;
a = y/num
tyt = y+" ("+a+"%)";

xloc = E(1:end-1)+diff(E)/2;
text([-0.2 0.7], y+15000, tyt);
title("OTSU Thresholding");

subplot('Position',[0.55 0.1 0.4 0.8]); 
x = histogram(Im_Adap);
xticks([0 1]);
xticklabels(["Black","White"]);

E = x.BinEdges;
y = x.BinCounts;
a = y/num
tyt = y+" ("+a+"%)";

xloc = E(1:end-1)+diff(E)/2;
text([-0.2 0.7], y+15000, tyt);
title("Adaptive Thresholding");

