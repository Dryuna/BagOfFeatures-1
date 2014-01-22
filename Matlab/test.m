% test.m
% 
% 
% 

clear;
grid_step = 10;
block_size = 30;
num_cluster = 32;
dirname = 'roads';

sift_vec = sift_descriptor_all(grid_step, block_size, dirname);

sift_vec_all = [];
for i=1:size(sift_vec,2)
    sift_vec_all = [sift_vec_all; sift_vec{i}];
end

idx = kmeans(sift_vec_all, num_cluster);

% Save the images in each directory corresponding to their classes
save_results(grid_step, block_size, dirname, sift_vec, idx);

