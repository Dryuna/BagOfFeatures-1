% sift_descriptor_all.m
% 
% Compute the sift descriptor of all the images in the specified directory.
% Each image produces [Num of blocks] x 128 matrix of feature descriptor.
%
% @author Gen Nishida
% 

function sift_vec = sift_descriptor_all(grid_step, block_size, dirname)

block_size_ex = block_size + 2;

% get the list of the images
jpg=dir(sprintf('%s\\*.jpg', dirname));
    
for fid=1:size(jpg,1)
    fprintf('%s\n', jpg(fid).name);
	im = imread(sprintf('%s\\%s', dirname, jpg(fid).name));
    
    % convert the image to the gray scale
	if (size(im,3) > 1)
   		im=rgb2gray(im);
    end
    
    sift_vec{fid} = [];
    for i=block_size:grid_step:size(im,1)-block_size
	    for j=block_size:grid_step:size(im,2)-block_size
	    	% crop a patch of the image
	    	im_cropped=im(round(i-block_size_ex/2):round(i+block_size_ex/2)-1, round(j-block_size_ex/2):round(j+block_size_ex/2)-1);
	    	
    	    sift_vec{fid} = [sift_vec{fid}; sift_descriptor(im_cropped)];
    	end
	end
end
