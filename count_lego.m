%%     /////     Function Explanation     /////
% This function counts the Blue 2X4 legos as numA and Red 2X2 legos as numB


%%     /////     Algorithm     /////

% 1- Blue 2X4 lego counting
% Blue colored objects are detected from input image by subtracting the grayscale of image from Blue channel of image. 
% Then, subtracted image is converted to binary image keeping Blue objects as white and rest all image as black in binary image. 
% For Blue objects binarization, global thresholding is used. After binary coversion, small objects are removed from binary image. 
% Morphological transformations are applied to get propser shaped binary objects for Blue color.
% Then, Blue 2X4 legos are counted using Major and Minor axis lengths of objects and their ratios in input image (as discussed in reference no 1).
 
% 2- Red 2X2 lego counting
% Red colored objects are detected from input image by subtracting the grayscale of image from Red channel of image. 
% Then, subtracted image is converted to binary image keeping Red objects as white and rest all image as black in binary image. 
% For Red objects, a threshold on 0.3 is used which is selected based on manual observation to seperate Red objects from nearby orange and yellow objects.
% After binary coversion, small objects are removed from binary image. Morphological transformations are applied to get propser shaped binary objects.
% Then, Red 2X2 legos are counted using Major and Minor axis lengths of objects and their ratios in input image (as discussed in reference no 1).

% 3- References:
% https://blogs.mathworks.com/steve/2010/07/30/visualizing-regionprops-ellipse-measurements/     

function [numA,numB]=count_lego(I)
%% Blue 2X4 lego Counting
% subtract gray image from Blue channel 
Blue_Gray = imsubtract(im2double(I(:,:,3)), rgb2gray(im2double(I))); 
% Canny threshold
Canny_T = graythresh(Blue_Gray); 
% convert to binary
Blue_BW = imbinarize(Blue_Gray,Canny_T); 
% filling holes
hfz = 7;
Blue_BW = imopen(Blue_BW,[hfz hfz]); 
% Remove small objects from binary image
smallObjT = 3000;
Blue_BW = bwareaopen(Blue_BW,smallObjT); 
% perform image closing    
closingSE = strel('disk',5); 
Blue_BW = imclose(Blue_BW,closingSE); 
% Labeling connected components
Binary_Blue = logical(Blue_BW); 
% region properties of image 
stats_Blue_Holes = regionprops(Binary_Blue,'MajorAxisLength','MinorAxisLength','Perimeter','Area','BoundingBox');     
% filling holes
Blue_BW = imfill(Blue_BW,'holes'); 
% Labeling connected components
Binary_Blue = logical(Blue_BW); 
% Measure properties of image regions
Binary_Blue_stats = regionprops(Binary_Blue,'MajorAxisLength','MinorAxisLength','Perimeter','Area','BoundingBox');     
% initialize variables
minAreaBlue = 10000;
maxAreaBlue = 35000;
diffAreaBlue = 500;
lwRatioBlue = 2.5;
% perform counting if blue objects present in image
if ~isempty(Binary_Blue_stats)
    for obj = 1:length(Binary_Blue_stats)
        Area_Blue(obj) = Binary_Blue_stats(obj).Area;
    end
    Remove = [];
    for obj = 1:length(stats_Blue_Holes)
        Area_Holes = stats_Blue_Holes(obj).Area;
        if Area_Holes < min(Area_Blue)/2
            Remove = [Remove obj];
        end
    end
    stats_Blue_Holes(Remove) = [];
    for obj = 1:length(stats_Blue_Holes)
        Area_Holes(obj) = stats_Blue_Holes(obj).Area;
    end
    Diff_Area = Area_Blue - Area_Holes;
    % mark a rectangle on all regions/objects of Red color in Image
    for obj = 1:length(Binary_Blue_stats)
        % Get length to width ratio of each object
        Length_To_Width_Ratio_Blue(obj) = Binary_Blue_stats(obj).MajorAxisLength/Binary_Blue_stats(obj).MinorAxisLength; 
        % get area of each object
        Area_Blue(obj) = Binary_Blue_stats(obj).Area; 
    end    
    % Sort the object areas
    Sorted_Area = sort(Area_Blue,'descend'); 
    % initialize numA as zero
    numA = 0; 
    if length(Binary_Blue_stats)>2
        % loop over all objects
        for obj = 1:length(Binary_Blue_stats) 
            % if condition to count numA
            if Length_To_Width_Ratio_Blue(obj) > 1.5 && Length_To_Width_Ratio_Blue(obj) < 2.5  && Area_Blue(obj) > Sorted_Area(2)/2 
                numA = numA + 1;
                Selected_Object_Area(numA) = Area_Blue(obj);    
                Selected_Object(numA) = obj;
                if length(Length_To_Width_Ratio_Blue) == 2
                    break;
                end
            end
        end
    else
        % loop over all objects
        for obj = 1:length(Binary_Blue_stats) 
            % if condition to count numA
            if Length_To_Width_Ratio_Blue(obj) > 1.5 && Length_To_Width_Ratio_Blue(obj) < 2.5  && Area_Blue(obj) > Sorted_Area(1)/2 
                numA = numA + 1;
                Selected_Object_Area(numA) = Area_Blue(obj);    
                Selected_Object(numA) = obj;
                if length(Length_To_Width_Ratio_Blue) == 2
                    break
                end
            end
        end
    end
    % check for connected objects
    if length(Selected_Object_Area)>1
        for obj = Selected_Object % loop over all objects   
            if Diff_Area(obj)>diffAreaBlue && Length_To_Width_Ratio_Blue(obj) > 1 && Length_To_Width_Ratio_Blue(obj) < lwRatioBlue && Area_Blue(obj) > min(Selected_Object_Area)*1.75
                numA = numA + 1;
            end
        end        
    elseif Diff_Area(Selected_Object)> minAreaBlue && Selected_Object_Area > maxAreaBlue
        numA = numA + 1;
    end
else
    numA = 0;
end


%% Red 2X2 lego Counting
% Initialize veriables
minAreaRed = 3000;
maxAreaRed = 30000;
lwRatioRed = 1.7;
% subtracting gray image from Red channel 
Red_Gray = imsubtract(im2double(I(:,:,1)), rgb2gray(im2double(I))); 
% convert difference image to binary
Red_Thresh = 0.3;
Red_BW = im2bw(Red_Gray,Red_Thresh); 
% Remove small objects from binary image
smallObj = 800;
Red_BW = bwareaopen(Red_BW,smallObj); 
% filling holes
Red_BW = imfill(Red_BW,'holes'); 
% image closing
closingSE = strel('disk',10); 
Red_BW = imclose(Red_BW,closingSE); 
% Labeling connected components
bw_Red = logical(Red_BW); 
% Measuring properties
stats_Red = regionprops(bw_Red,'Area','BoundingBox','MajorAxisLength','MinorAxisLength'); 
% Removing large objects
for obj = 1:length(stats_Red)
    Area_Blue(obj) = stats_Red(obj).Area;
end
for obj = 1:length(stats_Red)
    % Get length to width ratio of each object
    Length_To_Width_Ratio_Red(obj) = stats_Red(obj).MajorAxisLength/stats_Red(obj).MinorAxisLength; 
    % get area of each object
    Area_Red(obj) = stats_Red(obj).Area; 
end    
numB = 0; % initialize numA as zero
% loop over all objects
for obj = 1:length(stats_Red) 
    % if condition to count numA
    if Length_To_Width_Ratio_Red(obj) < lwRatioRed && Area_Red(obj)>minAreaRed && Area_Red(obj)<maxAreaRed 
        numB = numB + 1;
    end
end
end
