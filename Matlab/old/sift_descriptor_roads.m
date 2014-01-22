% sift_descriptor_roads.m
% 
% @author Gen Nishida
% 

function sift_vec = sift_descriptor_roads(grid_step, block_size, dirname)

block_size_ex = block_size+2;

%jpg=dir(sprintf('roads\\%s',dirname))(3:end);
jpg=dir(sprintf('roads\\%s\\*.jpg',dirname));
    
for fid=1:size(jpg,1)
    %disp(jpg(fid).name);
    %fflush(stdout);
    fprintf('%s\n', jpg(fid).name);
	im=imread(sprintf('roads\\%s\\%s',dirname,jpg(fid).name));
	if(size(im,3)>1)
   		im=rgb2gray(im);
	end
    sift_vec{fid}=[];
    for i=block_size:grid_step:size(im,1)-block_size
	    for j=block_size:grid_step:size(im,2)-block_size
	    	% crop a patch of the image
	    	im_cropped=im(round(i-block_size_ex/2):round(i+block_size_ex/2)-1, round(j-block_size_ex/2):round(j+block_size_ex/2)-1);
	    	
    	    sift_vec{fid} = [sift_vec{fid}; sift_descriptor(im_cropped, block_size)'];
    	end
	end
end
