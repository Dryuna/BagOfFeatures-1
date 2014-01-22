% bof_fv_generate.m
% (C) Toshihiko YAMASAKI
% 本プログラムを使用したことによるいかなる障害、損害も責任はとりません
% 各自の責任において使用してください。
function [bof_vec, idx_count]=bof_fv_generate(sift_vec, idx, num_cluster, idx_count)
for i=1:size(sift_vec,2)
    bof_vec{i}=zeros(num_cluster,1);
    for j=1:size(sift_vec{i},1)
        bof_vec{i}(idx(idx_count))=bof_vec{i}(idx(idx_count))+1;
        idx_count=idx_count+1;
    end
    bof_vec{i}=bof_vec{i}./sum(bof_vec{i});
end
