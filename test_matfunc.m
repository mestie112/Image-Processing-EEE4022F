clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in

I = imread('Ice3.jpg');
I = im2gray(I);
bw = imbinarize(I);


stats = regionprops(bw,'Area','Centroid','Perimeter');
sz = numel(stats);

area = zeros(sz,1);
x = [[0,0]];
per_m = zeros(sz,1);
i = 1;
for i = 1:sz
    area(i) = stats(i).Area;
    per_m(i) = stats(i).Perimeter;
 %   center(i) = stats(i).Centroid;
    i = i+1;
end
x = stats(2).Centroid;
r = uint8 (sqrt(area/pi));
imshow(I);
roi = drawcircle("Center",x);
mask = createMask(roi);

% Active contour
iterations = 100;
BW = activecontour(bw, mask, iterations, 'edge');
%BW = imdilate(BW,ones(3,3));
%imshowpair(BW,mask);
imshow(BW)

