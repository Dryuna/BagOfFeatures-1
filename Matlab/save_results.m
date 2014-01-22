% test2.m
% 
% 
% 
function save_results(grid_step, block_size, dirname, sift_vec, idx)

block_size_ex = block_size+2;

jpg=dir(sprintf('%s\\*.jpg',dirname));

idx_count = 1;

for fid=1:size(jpg,1)
	% read the image
    fprintf('%s\n', jpg(fid).name);
	im=imread(sprintf('%s\\%s', dirname, jpg(fid).name));
	
    count = 1;
    for i = block_size:grid_step:size(im,1)-block_size
	    for j = block_size:grid_step:size(im,2)-block_size
			im_cropped=im(round(i-block_size_ex/2):round(i+block_size_ex/2)-1, round(j-block_size_ex/2):round(j+block_size_ex/2)-1);
			
			imwrite(im_cropped, sprintf('results\\%d_%s_%d.jpg',idx(idx_count),jpg(fid).name, count));
			count = count + 1;
			idx_count = idx_count+1;
		end
	end
end
