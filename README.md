# lego-count

This project aims to count the number of legos in an image using computer vision methods with matlab.

## Algorithm explanation

### 1- Blue 2X4 lego counting

Blue colored objects are detected from the input image by subtracting the grayscale image from the blue channel image. 
Then, the subtracted image is converted to a binary image keeping Blue objects white and the rest of the image black. 
For Blue objects binarization, global thresholding is used. After binary coversion, small objects are removed from the binary image. 
Morphological transformations are applied to get proper shaped binary objects for Blue color.
Then, Blue 2X4 legos are counted using Major and Minor axis lengths of objects and their ratios in the input image (as discussed in reference).
 
### 2- Red 2X2 lego counting

Red colored objects are detected from the input image by subtracting the grayscale image from the red channel image. 
Then, the subtracted image is converted to a binary image keeping Red objects white and the rest of the image black. 
For Red objects, a threshold of 0.3 is used, selected based on manual observation to seperate Red objects from nearby orange and yellow objects.
After binary coversion, small objects are removed from binary image. Morphological transformations are applied to get proper shaped binary objects.
Then, Red 2X2 legos are counted using Major and Minor axis lengths of objects and their ratios in the input image (as discussed in reference).

### 3- References:
https://blogs.mathworks.com/steve/2010/07/30/visualizing-regionprops-ellipse-measurements/     
