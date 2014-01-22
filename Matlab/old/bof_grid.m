% bof_grid.m
% 
% 
% 

clear;
grid_step=10;
block_size=30;
num_cluster=32;
sift_vec_london=sift_descriptor_roads(grid_step, block_size, 'london');
sift_vec_paris=sift_descriptor_roads(grid_step, block_size, 'paris');
sift_vec=[];
for i=1:size(sift_vec_london,2)
    sift_vec=[sift_vec; sift_vec_london{i}];
end
for i=1:size(sift_vec_paris,2)
    sift_vec=[sift_vec; sift_vec_paris{i}];
end
idx = kmeans(sift_vec,num_cluster);

% Bag of Features generation
idx_count=1;
[bof_vec_london, idx_count]=bof_fv_generate(sift_vec_london, idx, num_cluster, idx_count);
[bof_vec_paris, idx_count]=bof_fv_generate(sift_vec_paris, idx, num_cluster, idx_count);

% Data output
bof_data_output(bof_vec_london, 'london', 1);
bof_data_output(bof_vec_paris, 'paris', -1);


