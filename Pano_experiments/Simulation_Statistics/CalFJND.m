function [result]=CalFJND(imgraw)
[H W Z]=size(imgraw);

img=zeros(H,W); %ת��Ϊ����ͼ
Fscore=zeros(H,W);

xf=[ceil(H/2),ceil(W/2)]; %�����û���������Ļ������
for i=1:H %���ɫͼƬ��Ӧ������ͼ
    for j=1:W
        img(i,j)=0.3*imgraw(i,j,1)+0.6*imgraw(i,j,2)+0.1*imgraw(i,j,3);
    end
end

xx=1:W;
yy=1:H;
for i=1:H
    for j=1:W
        x=[i,j];
        d=sqrt((x(1)-xf(1))^2+(x(2)-xf(2))^2);
        N=840;
        v=0.5;
        e=(atan(d/(N*v))/pi)*180;
        Fscore(i,j)=FJND(img,i,j,v,e);
    end
end

result=Fscore;
% 
% Gap_X=240;
% Gap_Y=240;
% BitRate=zeros(4,6);
% BitRateSum=zeros(4,6);
% 
% %��ÿһ��tile��ƽ��JNDֵ
% for i=1:H
%     for j=1:W
%         BitRate(ceil(i/Gap_X),ceil(j/Gap_Y))=BitRate(ceil(i/Gap_X),ceil(j/Gap_Y))+Fscore(i,j);
%         BitRateSum(ceil(i/Gap_X),ceil(j/Gap_Y))=BitRateSum(ceil(i/Gap_X),ceil(j/Gap_Y))+1;
%     end
% end
% 
% for i=1:4
%     for j=1:6
%          BitRate(i,j)= BitRate(i,j)/BitRateSum(i,j);
%     end
% end


% M=min(BitRate(:));
% 
% %%��JNDת��Ϊ����
% for i=1:5
%     for j=1:6
%          BitRate(i,j)= (M/BitRate(i,j))*100; %ÿһ�����ܹ����ܵ���������ֵ
%     end
% end
% 
% Downscale=[70,70,70,70,70,70;
%            70,85,85,85,85,70;
%            70,85,100,100,75,70;
%            70,85,85,85,85,70;
%            70,70,70,70,70,70]
% %���������һȦһȦ���͵��ж������
% 
% sum(Downscale(:))
% for i=1:5
%     for j=1:6
%        if Downscale(i,j)>BitRate(i,j)
%           Downscale(i,j)=BitRate(i,j);
%        end
%     end
% end
% 
% sum(Downscale(:))
%            
% AllSameImproment=(3000-sum(BitRate(:)))/3000  %��ȫ��һ����ȥ��
% DownscaleImproment=0                                           %��һȦһȦ��ȥ��
% [X,Y]=meshgrid(1:6,1:5);
% shading interp;
% surf(X,Y,BitRate);
% shading interp;