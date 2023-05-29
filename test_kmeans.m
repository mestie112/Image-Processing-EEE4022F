clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in
I = imread("RealIce6.jpg");

I = imcrop(I);

%% Grayscaling Image
ImG = im2gray(I);

%% K means algorithm
%%{
K = input("Enter a K value: ");
[K_segment, Centers] = imsegkmeans(ImG,K);
K_colors = labeloverlay(I,K_segment);


% Image Classification
[x,y] = size(ImG);

class1 = zeros(x,y);
class2 = zeros(x,y);
class3 = zeros(x,y);
class4 = zeros(x,y);
class5 = zeros(x,y);
class6 = zeros(x,y);

for i = 1:x
    for j = 1:y
        if K_segment(i,j) == 1
            class1(i,j) = K_segment(i,j);
        end

        if K_segment(i,j) == 2
            class2(i,j) = K_segment(i,j);
        end

        if K_segment(i,j) == 3
            class3(i,j) = K_segment(i,j);
        end

        if K_segment(i,j) == 4
            class4(i,j) = K_segment(i,j);
        end
        if K_segment(i,j) == 5
            class5(i,j) = K_segment(i,j);
        end
       
        if K_segment(i,j) == 6
            class6(i,j) = K_segment(i,j);
        end

        j = j+1;
    end
    i = i+1;
end

%% K Means Results

%%{
fig_classes1 = figure;
subplot('Position',[0 0.2 0.33 0.5]);
imshow(class1)
title("class1");


subplot('Position',[0.34 0.2 0.33 0.5]);
imshow(class2)
title("class2");

subplot('Position',[0.68 0.2 0.33 0.5]);
imshow(class3);
title("class3");

if K > 3
    fig_classes2 = figure;
    subplot('Position',[0 0.2 0.33 0.5]);
    imshow(class4)
    title("class4");


    subplot('Position',[0.34 0.2 0.33 0.5]);
    imshow(class5)
    title("class5");

    subplot('Position',[0.68 0.2 0.33 0.5]);
    imshow(class6);
    title("class6");
end
%}

%% Floe Image
%%{
c = 1;
class = zeros(K,0);
while c < K + 1
    inp_c = input("Enter a class number for floe images: ");
    class(c) = uint8 (inp_c);
    disp(class(c));
    c = c+1;
end

d = 1;
floe = zeros(x,y);


while d < K + 1
    if class(d) == 1
        floe = floe + class1;
    end

    if class(d) == 2
        floe = floe + class2;
    end
    
    if class(d) == 3
        floe = floe + class3;
    end
    
    if class(d) == 4
        floe = floe + class4;
    end

    if class(d) == 5
        floe = floe + class5;
    end

    if class(d) == 6
        floe = floe + class6;
    end
    d = d+1;
end
fig_floe = figure;
imshow(floe);
%}

%% Water Image

%%{

c = 1;
class = zeros(K,0);
while c < K + 1
    inp_c = input("Enter a class number for water images: ");
    class(c) = uint8 (inp_c);
    disp(class(c));
    c = c+1;
end

d = 1;
water = zeros(x,y);

while d < K + 1
    if class(d) == 1
        water = water + class1;
    end

    if class(d) == 2
        water = water + class2;
    end
    
    if class(d) == 3
        water = water + class3;
    end
    
    if class(d) == 4
        water = floe + class4;
    end

    if class(d) == 5
        water = water + class5;
    end
    d = d+1;
end
fig_water = figure;
imshow(water);
%}

%}

%imshowpair(K_colors,K_colors2,'montage');
num = numel(ImG);

binary_hist = figure; 
x = histogram(imbinarize(floe));
xticks([0 1]);
xticklabels(["Black","White"]);

E = x.BinEdges;
y = x.BinCounts;
a = y/num;
tyt = y+" ("+a+"%)";

xloc = E(1:end-1)+diff(E)/2;
text([-0.2 0.7], y+15000, tyt);
title("Floe Image");
