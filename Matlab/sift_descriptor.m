% sift_descriptor.m
% 
% Each vector in each cell is 1 x 8 matrix, and by combinint all the 16 cells,
% the resulting sift descriptor is 1 x 128 matrix.
%
% Given an image patch
% 

function fv=sift_descriptor(im_cropped)
block_size_ex = size(im_cropped, 1);
block_size = block_size_ex - 2;
sigma=block_size/6;

% Gaussian
G=zeros(block_size_ex,block_size_ex);
for i=1:block_size_ex
    for j=1:block_size_ex
        G(i,j)=exp(-1 * ((i-(block_size_ex+1)/2)^2 + (j-(block_size_ex+1)/2)^2) / (2*sigma^2)) / (2*pi*sigma^2);
    end
end

% magnitude and direction
kernel_x=[1, 0, -1];
kernel_y=[1; 0; -1];
dx=conv2(double(im_cropped), double(kernel_x), 'same');
dy=conv2(double(im_cropped), double(kernel_y), 'same');
mag=sqrt(dx.^2+dy.^2);
theta=atan2(dy,dx);
G([1,end],:)=[];
G(:,[1,end])=[];
mag([1,end],:)=[];
mag(:,[1,end])=[];
theta([1,end],:)=[];
theta(:,[1,end])=[];

% feature vector generation
cell_size = 4;
rot_res = 8;
hist_array = cell(cell_size, cell_size);
for i = 1:cell_size
    for j = 1:cell_size
        hist_array{i,j} = zeros(1, rot_res);
        for m = 1+floor((i-1)*block_size/cell_size):ceil(i*block_size/cell_size)
            for n = 1+floor((j-1)*block_size/cell_size):ceil(j*block_size/cell_size)
                hist_array{i,j}(1, sift_rot_id(theta(m,n))) = hist_array{i,j}(1, sift_rot_id(theta(m,n))) + mag(m,n)*G(m,n);
            end
        end
    end
end
fv = [];
for i = 1:cell_size
    for j = 1:cell_size
        fv = [fv, hist_array{i,j}];
    end
end

