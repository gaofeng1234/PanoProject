videoid=0;
framegap=30;
path(path,'I:\��Ƶ���۵���\Potential improment')
for userid=1:48
RotationSpeed=GetRotationSpeed(videoid,userid,framegap); %ÿһ�д����X��10֡�ڵ���ת�ٶ�
[x,y]=size(RotationSpeed);
mkdir('RotationSpeed');
fid=fopen(['RotationSpeed\',num2str(userid),'.txt'],'w');
for i=1:x
    fprintf(fid,'%f\r\n',RotationSpeed(i));
end
fclose(fid);
end