function [result]=CalFunction(R)
%����һ��240*240����Ƶ�飬������Ϊʧ��������64�Ŀ��ǲ��ܽ������ʽ��͵�
%1��������Ҫ������ϣ������ǳ���JND�����ص������������������
%2��������Ƶ�е�ÿ��tile�ֱ���㣬�����²���
%3�������tile������JND�����ص�����ǡ��Ϊ64ʱ��Ӧ�����ʣ���������64�Ķ�Ӧ�����ᣬ��Ϊ����Ӧ�õ���������

%�ݶ�TΪ�ٷ�֮10����5760


    
%����ÿһ����Ƶ������
Bitrate_22=textread('F:\��Ƶ���۵���\Potential improment\log\log\seq2\bitrate\duration=1_idx=89_qp=22.txt');
Bitrate_27=textread('F:\��Ƶ���۵���\Potential improment\log\log\seq2\bitrate\duration=1_idx=89_qp=27.txt');
Bitrate_32=textread('F:\��Ƶ���۵���\Potential improment\log\log\seq2\bitrate\duration=1_idx=89_qp=32.txt');
Bitrate_37=textread('F:\��Ƶ���۵���\Potential improment\log\log\seq2\bitrate\duration=1_idx=89_qp=37.txt');
Bitrate_42=textread('F:\��Ƶ���۵���\Potential improment\log\log\seq2\bitrate\duration=1_idx=89_qp=42.txt');
% 
Bitrate_22=reshape(Bitrate_22,12,6)';
Bitrate_27=reshape(Bitrate_27,12,6)';
Bitrate_32=reshape(Bitrate_32,12,6)';
Bitrate_37=reshape(Bitrate_37,12,6)';
Bitrate_42=reshape(Bitrate_42,12,6)';

path_raw='F:\��Ƶ���۵���\Potential improment\frame\original.bmp';
img_raw=r2g(imread(path_raw));
[H W]=size(img_raw);

img_22=r2g(imread('F:\��Ƶ���۵���\Potential improment\frame\frame22.bmp'));
img_27=r2g(imread('F:\��Ƶ���۵���\Potential improment\frame\frame27.bmp'));
img_32=r2g(imread('F:\��Ƶ���۵���\Potential improment\frame\frame32.bmp'));
img_37=r2g(imread('F:\��Ƶ���۵���\Potential improment\frame\frame37.bmp'));
img_42=r2g(imread('F:\��Ƶ���۵���\Potential improment\frame\frame42.bmp'));


%ע�⴦��ͼƬ��СΪ1440*2880
Gap_Height=240;
Gap_Width=240;

%����Ҫ����ÿһ�����ʰ汾��ÿ��tile����JND����������
C_22=zeros(6,12);
C_27=zeros(6,12);
C_32=zeros(6,12);
C_37=zeros(6,12);
C_42=zeros(6,12);

Function=cell(6,12);

D_22=double(abs(img_22-img_raw));
D_27=double(abs(img_27-img_raw)); %����ÿ�����ʰ汾��������ʵ����ز��
D_32=double(abs(img_32-img_raw));
D_37=double(abs(img_37-img_raw));
D_42=double(abs(img_42-img_raw));



%ÿһ�����ʰ汾ÿ��tile����JND����������,Ŀǰ
for i=1:6
    for j=1:12
        C_22(i,j)=sum(sum((D_22((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width) - R((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width))>0));
        C_27(i,j)=sum(sum((D_27((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width) - R((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width))>0));
        C_32(i,j)=sum(sum((D_32((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width) - R((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width))>0));
        C_37(i,j)=sum(sum((D_37((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width) - R((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width))>0));
        C_42(i,j)=sum(sum((D_42((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width) - R((i-1)*Gap_Height+1:i*Gap_Height,(j-1)*Gap_Width+1:j*Gap_Width))>0));
    end
end

T=5760;
for i=1:6
    for j=1:12
        X=[C_22(i,j),C_27(i,j),C_32(i,j),C_37(i,j),C_42(i,j)];
        Y=[Bitrate_22(i,j),Bitrate_27(i,j),Bitrate_32(i,j),Bitrate_37(i,j),Bitrate_42(i,j)];
        if C_42(i,j)<=T
             Function{i,j}=Bitrate_42(i,j);
             continue;
        end
        Function{i,j}=FFF(X',Y');
    end
end

result=Function;



