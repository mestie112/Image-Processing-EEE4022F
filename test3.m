%%{
clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in

I = imread('Ice1.jpg');
I = padarray(I,[1 1],0,'both');
ImG = im2gray(I);
%I = imcrop(I);


inp = 1;
iterations = 100;
rc = 40;
rd = 3;

imshow(I);
%coor = ginput(inp);
floe = 0;

for i = 1:inp
    roi = drawassisted();
   % roi = drawcircle("Center",coor,'Radius',rc);
    mask = createMask(roi);
    % Active contour
    BW = activecontour(I, mask, iterations, 'Chan-vese');
    floe = floe + BW;
    %floe = imbinarize(floe);  
end

floe = padarray(floe,[1 1],0,'both');
result = imfuse(I,floe,'blend');

mont = figure;
imshowpair(I,result,'montage')

cls = figure;
se = strel('disk',rd);
floe = imopen(floe,se);

dil = imfill(edge(floe,"canny"),'holes');
imshowpair(I,dil)




stats = regionprops(floe)
%}
