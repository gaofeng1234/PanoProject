


SOURCE_PATH_t = 'I:\��Ƶ���۵���\Potential improment\������Potential improvement\Tiling\Qp_12_24\0\2\1651';%Դ�ļ�Ŀ¼  
frame=1651;
for i=1:6
        mkdir(['I:\2018.9.2_data\',num2str(i),'\',num2str(frame),'\'])
    for j=1:42
        filename=['I:\��Ƶ���۵���\Potential improment\������Potential improvement\Tiling\Qp_12_24\0\',num2str(i),'\1651\',num2str(j),'.txt'];
        movefile(filename,['I:\2018.9.2_data\',num2str(i),'\',num2str(frame),'\']);
    end
end