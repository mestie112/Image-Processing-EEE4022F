clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

% Reading image in
I = imread("Ice3.jpg");
%Icrop = imcrop(I);
Ipad = padarray(I,[1 1],0,'both');
ImG = im2gray(I);
Ibin = imbinarize(ImG);

%% Image Pack
%%{
for i = 1:2      
    I_inp = Ibin;
    Ipack_in = bwpack(I_inp);
    Ip1 = imdilate(Ipack_in,ones(3,5),'ispacked');
    Ipack_out = bwunpack(Ip1, size(I,1));
    I_inp = Ipack_out;
    i = i+1;
end
%imshow(Ipack_out);
%imshowpair(Ibin,Ipack_out,"checkerboard");
%}

%% Stats
%{
stats = regionprops("table",Ibin,"Centroid","MajorAxisLength","MinorAxisLength");

centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
%{
hold on
viscircles(centers,radii)

hold off
%}


se = strel('disk',15);
%}

%% Morph Image
%%{
r1 = 1;
r2 = 9;
r3 = 20;
se = strel('disk',r1);
se2 = strel('disk',r2);
se3 = strel('disk',r3);
Imorpho1 = imopen(Ibin,se);
Imorpho2 = imopen(Ibin,se2);
Imorpho3 = imopen(Ibin,se3);

Imorphop = imopen(Ipack_out,se2);

%{
fig = figure;
subplot('Position',[0 0 0.49 1]);
imshowpair(I,Imorpho2);
%title("Radius = "+r1);
title("Non-Packed Image");

subplot('Position',[0.5 0 0.49 1]);
imshowpair(I,Imorphop);
%title("Radius = "+r2);
title("Packed Image");
%}


%{
fig = figure;
subplot('Position',[0 0 0.3 1]);
imshow(Imorph);
title("Radius = "+r1);


subplot('Position',[0.35 0 0.3 1]);
imshow(Imorph2);
title("Radius = "+r2);

subplot('Position',[0.7 0 0.3 1]);
imshow(Imorph3);
title("Radius = "+r3);

%}


