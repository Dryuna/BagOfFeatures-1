% bof_fv_generate.m
% (C) Toshihiko YAMASAKI
% �{�v���O�������g�p�������Ƃɂ�邢���Ȃ��Q�A���Q���ӔC�͂Ƃ�܂���
% �e���̐ӔC�ɂ����Ďg�p���Ă��������B
function [bof_vec, idx_count]=bof_fv_generate(sift_vec, idx, num_cluster, idx_count)
for i=1:size(sift_vec,2)
    bof_vec{i}=zeros(num_cluster,1);
    for j=1:size(sift_vec{i},1)
        bof_vec{i}(idx(idx_count))=bof_vec{i}(idx(idx_count))+1;
        idx_count=idx_count+1;
    end
    bof_vec{i}=bof_vec{i}./sum(bof_vec{i});
end
