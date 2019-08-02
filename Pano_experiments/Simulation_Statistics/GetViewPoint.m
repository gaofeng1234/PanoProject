
%��һ������Ҫ�õ���֡���û��ӵ�ֲ�
clear all;
videoID=6;
%videoName1={'1-1-Conan_Gore_Fly.mp4','11-2-Front_2880_1440.mp4','1-3-Help_2880_1440.mp4','1-4-Conan_Weird_Al.mp4','1-5-Tahiti_Surf.mp4','1-6-Falluja.mp4','1-7-Cooking_Battle.mp4','1-8-Football.mp4','1-9-Rhinos.mp4'}
videoName1={'2-1-Korean.mp4','2-2-VoiceToy.mp4','','2-4-FemaleBasketball.mp4','2-5-Fighting.mp4','2-6-Anitta.mp4','2-7-TFBoy.mp4','2-8-Reloaded.mp4'};
viewPoint=zeros(48,2);

for videoId=0:8
    try
    Map=cell(48,1); %�洢ÿ���û���U,V����
    UserNumbers=48; 
    obj_height = 1440;%��ȡ��Ƶ֡�߶�
    obj_width = 2880;%��ȡ��Ƶ֡�߶�
    for i=1:UserNumbers  %��Ӧ�û�
        i
        Map{i}=containers.Map();
        [frame,U,V]=textread(['J:\RenderCor\Set2\',num2str(i),'_',num2str(videoId),'.txt'],'%d,%f,%f');
        [x y]=size(frame);
        for j=1:x
            Map{i}(num2str(frame(j)))=[U(j),V(j)];
        end
    end
    Start=1;
    obj = VideoReader(['J:\video\Set2\',num2str(videoId+1),'\',videoName1{videoId+1}]);%������Ƶλ��
    End=obj.NumberOfFrames;
    for i=Start:1:End %ÿһ����10
        i
        viewPoint=zeros(48,2);
        for j=1:UserNumbers  %���������û����ڸ�֡���ӵ�λ��
            if Map{j}.isKey(num2str(i))
                Temp=Map{j}(num2str(i));
                U=Temp(1);
                V=Temp(2);
                viewPoint(j,1)=U*obj_width;
                viewPoint(j,2)=V*obj_height;
            else
                continue
            end
        end
        mkdir(['I:\��Ƶ���۵���\Potential improment\frame\set2\',num2str(videoId),'_Viewpoint\']);
        savepath=['I:\��Ƶ���۵���\Potential improment\frame\set2\',num2str(videoId),'_Viewpoint\',num2str(i),'.mat'];
        save(savepath,'viewPoint')
        
    end
    catch
        continue
    end
end


