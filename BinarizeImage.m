function [bin_img] = BinarizeImage(image, window)

% RGB image
if size(image,3) == 3
	image = rgb2gray(image); 
end

% output image
bin_img = false(size(image));

% remove noise
%image = medfilt2(image,[3 3]);

% get average values
avg_filt = (1/(window*window))*true(window,window);
average = imfilter(image, avg_filt);

% apply thresholding
bin_img( image < average*0.9) = 1;

end