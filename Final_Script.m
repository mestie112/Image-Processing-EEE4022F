clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in
I = imread("Ice1.jpg");
%I = imcrop(I);     % User has the option of only analysing a specific region of the image.

%% User Choices
% user selected functions
[otsu,adap] = threshold(I,0.7);
figure
[im,subject] = chanvese(I,1,400);
subject = morph(subject,2,'close');
imshowpair(im,subject)
stats(subject)

%% Threshold Algorithms
function [Im_Otsu,Im_Adap] = threshold(I,sen)
    ImG = im2gray(I);
    num = numel(ImG);  
    
    Im_Adap = imbinarize(ImG,"adaptive","Sensitivity",sen);     % Output of the Adaptive method.
    Im_Otsu = imbinarize(ImG);      % Output of OTSU's method.

  
    binary_hist = figure;                     % Display Thresholding Histograms
    subplot('Position',[0.05 0.1 0.4 0.8]);
    x = histogram(Im_Otsu);
    xticks([0 1]);
    xticklabels(["Black","White"]);

    E = x.BinEdges;
    y = x.BinCounts;
    a = y/num;
    tyt = y+" ("+a+"%)";
    
    text([-0.2 0.7], y*0.5, tyt);
    title("OTSU Thresholding");
    
    subplot('Position',[0.6 0.1 0.4 0.8]); 
    x = histogram(Im_Adap);
    xticks([0 1]);
    xticklabels(["Black","White"]);
    
    E = x.BinEdges;
    y = x.BinCounts;
    a = y/num;
    tyt = y+" ("+a+"%)";

    text([-0.2 0.7], y*0.5, tyt);
    title("Adaptive Thresholding");
end

%% K means algorithm
function [floe,water] = kmeans(I,K)
    ImG = im2gray(I);
    num = numel(ImG);  
    [K_segment, Centers] = imsegkmeans(ImG,K);  % K-means Method
    K_colors = labeloverlay(I,K_segment);       % Colour Overlay of Results


    % Image Classification
    [x,y] = size(ImG);

    class1 = zeros(x,y);            % Empty classes to store results
    class2 = zeros(x,y);
    class3 = zeros(x,y);
    class4 = zeros(x,y);
    class5 = zeros(x,y);
    class6 = zeros(x,y);

    for i = 1:x
        for j = 1:y
            if K_segment(i,j) == 1
                class1(i,j) = 1;
            end
    
            if K_segment(i,j) == 2
                class2(i,j) = 1;
            end

            if K_segment(i,j) == 3
                class3(i,j) = 1;
            end

            if K_segment(i,j) == 4
                class4(i,j) = 1;
            end
            if K_segment(i,j) == 5
                class5(i,j) = 1;
            end
       
            if K_segment(i,j) == 6
                class6(i,j) = 1;
            end

            j = j+1;
        end
        i = i+1;
    end

    % K Means Results

    figure;            
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
        figure;
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


% Floe Image

    c = 1;
    class = zeros(K,0);                 % User chooses which classes are floes
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

         if class(d) == 0
            floe = floe;
        end
        d = d+1;
    end

% Water Image
                      
    c = 1;                              % User chooses which classes are water
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
            water = water + class4;
        end

        if class(d) == 5
            water = water + class5;
        end

         if class(d) == 6
            water = water + class6;
        end
    
        if class(d) == 0
        end
        d = d+1;
    end

    figure;                   % K-means Histogram
    x = histogram(imbinarize(floe));
    xticks([0 1]);
    xticklabels(["Black","White"]);

    E = x.BinEdges;
    y = x.BinCounts;
    a = y/num;
    tyt = y+" ("+a+"%)";

    text([-0.2 0.7], y+15000, tyt);
    title("Floe Image");
end

%% Edge Detection Algorithm
function edged(I,s)
    % Gaussian Blur
    ImG = im2gray(I);
    ImG_blur = gaussianBlur(ImG,s);


    % Edge Detection
    edge_prewitt = edge(ImG_blur,"prewitt");
    
    edge_sobel = edge(ImG_blur,"sobel");
    
    edge_canny = edge(ImG_blur,"canny");

    % Display Results

    figure;
    imshow(ImG);
    title("Standard Deviation = "+ s);
    
    figure;
    subplot('Position',[0 0 0.3 1]);
    imshow(imfill(edge_sobel,'holes'));
    title("Sobel Edge");

    subplot('Position',[0.35 0 0.3 1]);
    imshow(imfill(edge_canny,'holes'));
    title("Canny Edge");

    subplot('Position',[0.7 0 0.3 1]);
    imshow(imfill(edge_prewitt,'holes'));
    title("Prewitt Edge");

    % Combining Results
    
    s1 = s;         % Setpoint standard deviation
    s2 = s + 1;
    s3 = s - 0.1;
    s4 = s + 0.4;
    s5 = s - 0.4;
    
    % Blurs performed with different standard deviations
    ImG1 = gaussianBlur(ImG_blur,s1);        
    ImG2 = gaussianBlur(ImG_blur,s2);
    ImG3 = gaussianBlur(ImG_blur,s3);
    ImG4 = gaussianBlur(ImG_blur,s4);
    ImG5 = gaussianBlur(ImG_blur,s5);
    
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
    
    figure;
    imshow(pic4);
    title("Composite Image");
end

%% Hole Removal
function I_inp = closehole(I)    
    I_inp = I;
    % I_inp = Im_Adap;
    Ipack_in = bwpack(I_inp);                           %Packing image for dilation
    Ip1 = imdilate(Ipack_in,ones(3,3),'ispacked');      %Image dilation with 3x3 block
    Ipack_out = bwunpack(Ip1, size(I,1));               %Unpacking Image
    I_inp = Ipack_out;
end

%% Morph Image
function mor = morph(pic_morph,radius,choice) 
    se = strel('disk',radius);           %Structuring element

    Imorphc = imclose(pic_morph,se);       %Morphological Closing with Structuring Element

    Imorpho = imopen(pic_morph,se);         %Morphological Opening with Structuring Element

    if choice == "open"
        mor =  Imorpho;
    end

    if choice == "close"
       mor = Imorphc;
    end
end

%% Chan-Vese
function [imge,floe] = chanvese(I,contour_no,iterations)
    I = imcrop(I);
    bw = imbinarize(I);
    I = padarray(I,[1 1],0,'both');
    imge = I;
    inp = contour_no;


    imshow(I);
    I = im2gray(I);
    floe = 0;

    for i = 1:inp
        roi = drawassisted();
        mask = createMask(roi);
      
        % Active contour
        BW = activecontour(I, mask, iterations, 'Chan-vese');
        floe = floe + BW;
    end
end

%% Stats
function stats = stats(floe)  
    stats = regionprops(floe, 'Area','Centroid','EquivDiameter')
end