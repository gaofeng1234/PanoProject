function [result]=CalF(imgraw) %���960*1440����viewport��С��
[H W Z]=size(imgraw);

img=zeros(H,W); %ת��Ϊ����ͼ
Fscore=zeros(H,W);
xf=[ceil(H/2),ceil(W/2)]; 

if Z==3
    for i=1:H %���ɫͼƬ��Ӧ������ͼ
        for j=1:W
            img(i,j)=0.3*imgraw(i,j,1)+0.6*imgraw(i,j,2)+0.1*imgraw(i,j,3);
        end
    end
end

for i=1:H
    for j=1:W
        x=[i,j];
        d=sqrt((x(1)-xf(1))^2+(x(2)-xf(2))^2);
        N=840;
        v=0.5;
        e=(atan(d/(N*v))/pi)*180;
        Fscore(i,j)=F(img,i,j,v,e);
    end
end

result=Fscore;
