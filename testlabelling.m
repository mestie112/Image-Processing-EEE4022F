clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
% Reading image in
I = imread("Ice3.jpg");

% Grayscaling Image
ImG = im2gray(I);
Ibin = imbinarize(ImG);
[x,y] = size(Ibin);

%% label

%a = imcontour(Ibin);
b = regionprops(Ibin)


[B,L] = bwboundaries(Ibin,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on

for k = 1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
