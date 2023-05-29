clc;        % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;      % Erase all existing variables.

%% Reading image in

I = imread('coins.jpg');
I = im2gray(I);
BW = imbinarize(I);


%% Test
[labeledImage, numberOfBlobs] = bwlabel(BW, 8);     % Label each blob so we can make measurements of it


subplot(3, 3, 4);
imshow(labeledImage, []);  % Show the gray scale image.
title('Labeled Image, from bwlabel()');
drawnow;


% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(3, 3, 5);
imshow(coloredLabels);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('Pseudo colored labels, from label2rgb().\nBlobs are numbered from top to bottom, then from left to right.');
title(caption);

props = regionprops(labeledImage, I,  'Area', 'Perimeter', 'Centroid', 'EquivDiameter');

% Print header line in the command window.
fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
% Extract all the mean diameters into an array.
% The "diameter" is the "Equivalent Circular Diameter", which is the diameter of a circle with the same number of pixels as the blob.
% Enclosing in brackets is a nice trick to concatenate all the values from all the structure fields (every structure in the props structure array).
blobECD = [props.EquivDiameter];
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the individual measurements of each blob.  They are field of each structure in the props strucutre array.
	% You could use the bracket trick (like with blobECD above) OR you can get the value from the field of this particular structure.
	% I'm showing you both ways and you can use the way you like best.
	blobArea = props(k).Area;				% Get area.
	blobPerimeter = props(k).Perimeter;		% Get perimeter.
	blobCentroid = props(k).Centroid;		% Get centroid one at a time
	% Now do the printing of this blob's measurements to the command window.
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the grayscale image that is showing the red boundaries on it.
	text(blobCentroid(1), blobCentroid(2), num2str(k));
end

%% Colour Label
%{
[B,L] = bwboundaries(BW,'noholes');
lbl = label2rgb(L, @jet, [0.8 0.8 0.8]);
imshow(lbl)
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
%}