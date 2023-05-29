clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in
I = imread("Ice3.jpg");
%I = imcrop(I);
I = padarray(I,[1 1],0,'both');

%% Grayscaling Image
ImG = im2gray(I);
Ibin = imbinarize(ImG);

%% Gaussian Blur
s = 0.6;
ImG = gaussianBlur(ImG,s);


%% Edge Detection
edge_prewitt = edge(ImG,"prewitt");

edge_sobel = edge(ImG,"sobel");

edge_canny = edge(ImG,"canny");

%% Results

% Display Results
fig2 = figure;
imshow(ImG);
title("Standard Deviation = "+ s);

fig = figure;
subplot('Position',[0 0 0.3 1]);
imshow(imfill(edge_sobel,'holes'));
title("Sobel Edge");


subplot('Position',[0.35 0 0.3 1]);
imshow(imfill(edge_canny,'holes'));
title("Canny Edge");

subplot('Position',[0.7 0 0.3 1]);
imshow(imfill(edge_prewitt,'holes'));
title("Prewitt Edge");




%% Combining Results
%%{
s1 = s;         % Setpoint standard deviation
s2 = s + 1;
s3 = s - 0.1;
s4 = s + 0.5;
s5 = s - 0.5;

% Blurs performed with different standard deviations
ImG1 = gaussianBlur(ImG,s1);        
ImG2 = gaussianBlur(ImG,s2);
ImG3 = gaussianBlur(ImG,s3);
ImG4 = gaussianBlur(ImG,s4);
ImG5 = gaussianBlur(ImG,s5);

%Edge canny for images of different blurs

edge_canny1 = imfill(edge(ImG1,"canny"),'holes');
edge_canny2 = imfill(edge(ImG2,"canny"),'holes');
edge_canny3 = imfill(edge(ImG3,"canny"),'holes');
edge_canny4 = imfill(edge(ImG4,"canny"),'holes');
edge_canny5 = imfill(edge(ImG5,"canny"),'holes');


pic = edge_canny1 + edge_canny2;

pic1 = pic + edge_canny3;

pic2 = pic1 + edge_canny4;

pic3 = pic2 + edge_canny5;


pic4 = imfill(pic3,"holes");
%imshow(pic4);
%imshowpair(I,pic4,"montage")
%}

%% Image Pack
%%{
for i = 1:2      
    I_inp = Ibin;
    Ipack_in = bwpack(I_inp);                           %Packing image for dilation
    Ip1 = imdilate(Ipack_in,ones(3,3),'ispacked');      %Image dilation with 3x3 block
    Ipack_out = bwunpack(Ip1, size(I,1));               %Unpacking Image
    I_inp = Ipack_out;
    i = i+1;
end
%}

%% Morph Image
%%{

se = strel('disk',1);           %Structuring element

Imorphc = imclose(pic_o,se);       %Morphological Closing with Structuring Element

Imorpho = imopen(pic_o,se);         %Morphological Opening with Structuring Element

imshow(Imorpho);


%}



