%% Reading Image In
I = imread("Ice3.jpg");

%% Grayscaling Image
ImaG = im2gray(I);

%% Image Duplicate
ImG = imbinarize(I);
ImG1 = I;

%% Selecting Specific Floe
% cropped = imcrop(ImG);

%% GVF Parameters
alpha=0.2;
mu=0.1;
iter=15;

%% Canny Edge Detection
step_size = 0.1;
edge_threshold = 0.1;
sensitivity = edge_threshold + step_size;
iteration = 2;
iteration1 = 100;

%&{
for i = 1:iteration
    edge_canny = edge(ImG,"canny",sensitivity);
    fill = imfill(edge_canny,'holes');
    ImG = imfuse(I,ImG,'blend');
%    ImG = imfuse(I,edge_canny,'blend');
    ImG = imbinarize(ImG,'adaptive','ForegroundPolarity','dark','Sensitivity', 0.6);

%    I = im2gray(test);
    disp(i);
%    imshow(ImG)

end

ImG = edge(ImG,"canny",sensitivity);
ImG = imfill(edge_canny,'holes');

imshowpair(I,ImG,'montage');

title(sprintf('Sensitivity: %0.03f and %1d iterations', sensitivity,iter));

%}

%% Run GVF
tic;
I = gaussianBlur(I,0.2);
[u,v] = GVF(I, mu, iter);
%[u1,v1] = GVF(I, mu, iter1);
t=toc;
fprintf('Computing GVF uses %f seconds \n',t);

%% Visualize Result
%%{
figure;
imshow(I);
hold on;
quiver(u,v);
axis ij off;
%%}