% bof_data_output.m
% 
% 
% 
function bof_data_output(vec, dirname, class)
fid=fopen(sprintf('%s.txt',dirname),'w');
for i=1:size(vec,2)
    fprintf(fid,'%d ',class);
    for element=1:size(vec{i},1)
        fprintf(fid,'%d:%d ',element, vec{i}(element));
    end
    fprintf(fid,'\n');
end
fclose(fid);
