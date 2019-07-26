function [result]=GetRotationSpeed(set,videoId,userId,framegap)%һ���Ի�ȡ֡���Ϊframegap�Ķ�Ӧvideoid userid����ת�ٶ�
 speed=[];
 for j=videoId:videoId %������Ƶ��
     %ÿ����Ƶ����һ��ͼƬ
    for num=userId:userId  %�����û�
        m=readtable(['F:/expdata/Experiment_',num2str(set),'/',num2str(num),'/video_',num2str(j),'.csv']);
        Map=cell(48,1); %�洢ÿһ֡ÿ���û���X,Y,Z����
        quan_list=table2array(m(1:end,3:6));
        time_list=str2double(table2array(m(1:end,2)));
        data_list=str2double(quan_list);
        [x,y]=size(data_list);
        TXYZ=[];
        for i=1:48
            Map{i}=containers.Map();
        end
        %��ȡʱ��Ͷ�Ӧ���� time_list��TXYZ
        for i=1:x 
              q2=data_list(i,:);
              tempTimexyz=[2*q2(1)*q2(3)+2*q2(2)*q2(4),2*q2(2)*q2(3)-2*q2(1)*q2(4),1-2*q2(1)*q2(1)-2*q2(2)*q2(2)];
              TXYZ=[TXYZ;tempTimexyz];
        end
        %��ʼ�����ݴ洢����
     
        for i=1:x %������ת��Ϊÿһ֡�����꣬������map��
           frame=floor(time_list(i,1)/0.033);
           Map{userId}(num2str(frame))=[TXYZ(i,1),TXYZ(i,2),TXYZ(i,3)];
        end
        
        for i=1:framegap:floor(time_list(x,1)/0.033) %��framegapΪ���
            Start=i;
            End=i+framegap;
            dataToBeHandled=[];
            for k=Start:End
                if Map{num}.isKey(num2str(k)) 
                    dataToBeHandled=[dataToBeHandled;Map{num}(num2str(k))];
                end
            end
            Rotationspeed=abs(CalRotationAngle(dataToBeHandled)*1.0/(framegap*1.0/30));
            speed=[speed;Rotationspeed]; 
        end
        %��Map������framegap���뵽dataToBeHandled�У������Ӧ����ת�ٶ�
    end

 end
    result=speed;

end

 
 