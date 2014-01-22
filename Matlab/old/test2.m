% test2.m
% 
% 
% 
function idx_count = test2(grid_step, block_size, dirname, sift_vec, idx, idx_count)

block_size_ex = block_size+2;
%jpg=dir(sprintf('roads\\%s',dirname))(3:end);
jpg=dir(sprintf('roads\\%s\\*.jpg',dirname));

for fid=1:size(jpg,1)
	% read the image
	%disp(jpg(fid).name);
    %fflush(stdout);
    fprintf('%s\n', jpg(fid).name);
	im=imread(sprintf('roads\\%s\\%s',dirname,jpg(fid).name));
	
    count = 1;
    for i=block_size:grid_step:size(im,1)-block_size
	    for j=block_size:grid_step:size(im,2)-block_size
			im_cropped=im(round(i-block_size_ex/2):round(i+block_size_ex/2)-1, round(j-block_size_ex/2):round(j+block_size_ex/2)-1);
			
			imwrite(im_cropped, sprintf('results\\%d_%s_%d.jpg',idx(idx_count),jpg(fid).name, count));
			count = count + 1;
			idx_count=idx_count+1;
		end
	end
end
