clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.


%% Reading image in

I = imread('Ice1.jpg');
%I = im2gray(I);

bw = imbinarize(I);
I = imcrop(I);
I = padarray(I,[1 1],0,'both');

inp = 2;
iterations = 400;
rc = 30;


imshow(I);
coor = ginput(inp);
floe = 0;

for i = 1:inp
    roi = drawassisted();
  %  roi = drawcircle("Center",coor(i,1:2),'Radius',rc);
    mask = createMask(roi);
    % Active contour
    BW = activecontour(I, mask, iterations, 'Chan-vese');
    floe = floe + BW;
end

rd = 3;
cls = figure;
se = strel('disk',rd);
floe = imdilate(floe,se,'notpacked');


%dil = imfill(edge(floe,"canny"),'holes');
imshowpair(I,floe)
stats = regionprops(floe, 'Area','Centroid','EquivDiameter')

%}

%{
stats = regionprops(floe, 'Area','Centroid','EquivDiameter');
rad = uint8 (sum(stats.EquivDiameter)/1.5);
cent = stats.Centroid;

roi = drawcircle("Center",cent,'Radius',rad);
mask = createMask(roi);

% Active contour
BW1 = activecontour(I, mask, 1000, 'Chan-vese');
se = strel('disk',double (rad));
floe = imdilate(floe,se,'notpacked');
figure;
imshowpair(I,BW1);
%}
