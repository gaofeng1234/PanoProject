function ProduceFrame(videoid,set)
try
    temp=dir(['J:\video\',set,'\',num2str(videoid),'\*.mp4']);
    name=temp.name;
    name=name(1:end-4);
    obj = VideoReader(['J:\video\',set,'\',num2str(videoid),'\1_1\',name,'.mp4']);%������Ƶλ��
    t=obj.NumberOfFrames;
    mkdir(['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\original']);
    for j=1:30:t
        j
        if(exist(['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\original\',num2str(j),'.png'],'file')==0)     
            frame = read (obj,j);%��ȡ�ڼ�֡
            imwrite(frame,['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\original\',num2str(j),'.png']);
        end
    end
    
    %�嵵Qpͼ
    for qp=22:1:42
        qp
        obj = VideoReader(['J:\video\',set,'\',num2str(videoid),'\1_1\',name,'_',num2str(qp),'.mp4']);%������Ƶλ��
        t=obj.NumberOfFrames;
        mkdir(['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\',num2str(qp)]);
        for j=1:30:t
            j
            if(exist(['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\',num2str(qp),'\',num2str(j),'.png'],'file')==0)
                frame = read (obj,j);%��ȡ�ڼ�֡
                imwrite(frame,['I:\��Ƶ���۵���\Potential improment\frame\',set,'\',num2str(videoid),'\',num2str(qp),'\',num2str(j),'.png']);
            end
        end
    end
catch
    '������'
end

