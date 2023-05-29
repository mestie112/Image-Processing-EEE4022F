clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in

X = imread('Ice3.jpg');
X = im2gray(X);
bw = imbinarize(X);

f = {};

imshow(cell2mat(f(1:1,1:1)));


