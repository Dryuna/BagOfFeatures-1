% test.m
% 
% 
% 

clear;
grid_step=10;
block_size=30;
num_cluster=32;
sift_vec_london = sift_descriptor_roads(grid_step, block_size, 'london');
sift_vec_paris = sift_descriptor_roads(grid_step, block_size, 'paris');
sift_vec=[];
for i=1:size(sift_vec_london,2)
    sift_vec=[sift_vec; sift_vec_london{i}];
end
for i=1:size(sift_vec_paris,2)
    sift_vec=[sift_vec; sift_vec_paris{i}];
end

idx = kmeans(sift_vec,num_cluster);

% Save the images in each directory corresponding to their classes
idx_count=1;
idx_count = test2(grid_step, block_size, 'london', sift_vec_london, idx, idx_count);
idx_count = test2(grid_step, block_size, 'paris', sift_vec_paris, idx, idx_count);

