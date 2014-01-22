% sift_descriptor_caltec101.m
% (C) Toshihiko YAMASAKI
% �{�v���O�������g�p�������Ƃɂ�邢���Ȃ��Q�A���Q���ӔC�͂Ƃ�܂���
% �e���̐ӔC�ɂ����Ďg�p���Ă��������B
function sift_vec=sift_descriptor_caltec101(grid_step, block_size, dirname)
jpg=dir(sprintf('101_ObjectCategories\\%s\\*.jpg',dirname));
for fid=1:min(size(jpg,1), 100)
    fprintf('%s\\%s\n',dirname,jpg(fid).name);
    im=imread(sprintf('101_ObjectCategories\\%s\\%s',dirname,jpg(fid).name));
    if(size(im,3)>1)
        im=rgb2gray(im);
    end
    sift_vec{fid}=[];
    for i=block_size:grid_step:size(im,1)-block_size
        for j=block_size:grid_step:size(im,2)-block_size
            sift_vec{fid}=[sift_vec{fid}; sift_descriptor(im, [j;i], block_size)'];
        end
    end
end
