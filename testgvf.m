clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.

I = imread("Ice1.jpg");
I = im2gray(I);
I = imcrop(I);


%% parameters
mu=0.2;
iter=100;

%% run GVF
tic;
[u,v] = GVF(I, mu,mu, iter);
t=toc;
fprintf('Computing GVF uses %f seconds \n',t);
%% visualize result
imshow(I);
hold on;
quiver(u,v);
axis ij off;



