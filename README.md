# lego-count

This project aims to count legos in an image with matlab.

## Algorithm explanation

### 1- Blue 2X4 lego counting

Blue colored objects are detected from input image by subtracting the grayscale of image from Blue channel of image. 
Then, subtracted image is converted to binary image keeping Blue objects as white and rest all image as black in binary image. 
For Blue objects binarization, global thresholding is used. After binary coversion, small objects are removed from binary image. 
Morphological transformations are applied to get propser shaped binary objects for Blue color.
Then, Blue 2X4 legos are counted using Major and Minor axis lengths of objects and their ratios in input image (as discussed in reference no 1).
 
### 2- Red 2X2 lego counting

Red colored objects are detected from input image by subtracting the grayscale of image from Red channel of image. 
Then, subtracted image is converted to binary image keeping Red objects as white and rest all image as black in binary image. 
For Red objects, a threshold on 0.3 is used which is selected based on manual observation to seperate Red objects from nearby orange and yellow objects.
After binary coversion, small objects are removed from binary image. Morphological transformations are applied to get propser shaped binary objects.
Then, Red 2X2 legos are counted using Major and Minor axis lengths of objects and their ratios in input image (as discussed in reference no 1).

### 3- References:
https://blogs.mathworks.com/steve/2010/07/30/visualizing-regionprops-ellipse-measurements/     
