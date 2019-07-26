
 timegap=5  %����ÿһ��ͳ�Ƶ�ʱ������Ϊ5��
 option=2 %2����UV���� 3����XYZ����
 %ͳ��ÿ����Ƶ���û��ӵ㷽��
 for j=5:8  %������ƵID
    videoTotalTime=-1;
    quan_list=[]; %�洢��Ԫ��
    time_list=[]; %�洢��Ԫ�� ��Ӧ����ʱ��
    for num=1:48 %ÿһ���û�
        m=readtable(['C:/Aiqiyi/expdata/Experiment_1/',num2str(num),'/video_',num2str(j),'.csv']);
        quan_list=m(1:end,3:6);
        time_list=table2array(m(1:end,2));
        tempVideoTotalTime=max(time_list(:));
        %����Ƶ����
        if tempVideoTotalTime>videoTotalTime
           videoTotalTime=tempVideoTotalTime;
        end
    end
    
    videoTotalTime=ceil(videoTotalTime); %������Ƶ����
    viewPoint=zeros(48,ceil(videoTotalTime*1.0/timegap)+1,option);
    
    %���û��ӵ���ͳ��
    for num=1:48 %ÿһ���û�
        num
        m=readtable(['C:/Aiqiyi/expdata/Experiment_1/',num2str(num),'/video_',num2str(j),'.csv']);
        quan_list=m(1:end,3:6);
        time_list=table2array(m(1:end,2));
        [x,y]=size(quan_list);
        tempviewPoint=zeros(ceil(videoTotalTime*1.0/timegap)+1,option);
        lenviewPoint=zeros(ceil(videoTotalTime*1.0/timegap)+1,1);
        
        %����û���timegap������ӵ�����
        
        for i=1:x %ÿһ������
              q1=quan_list(i,:);
              q2=table2array(q1); %ÿһ������һ�е�����
              time=ceil(time_list(i,1)/timegap)+1;
              
              tempxyz=[2*q2(1)*q2(3)+2*q2(2)*q2(4);2*q2(2)*q2(3)-2*q2(1)*q2(4);1-2*q2(1)*q2(1)-2*q2(2)*q2(2)];
              
              if abs(tempxyz(1))>=1
                  if tempxyz(1)>0
                      tempxyz(1)=floor(tempxyz(1));
                  else
                      tempxyz(1)=ceil(tempxyz(1));
                  end
              end
              
              if abs(tempxyz(2))>=1
                  if tempxyz(2)>0
                      tempxyz(2)=floor(tempxyz(2));
                  else
                      tempxyz(2)=ceil(tempxyz(2));
                  end
              end
              
              if abs(tempxyz(3))>=1
                  if tempxyz(3)>0
                      tempxyz(3)=floor(tempxyz(3));
                  else
                      tempxyz(3)=ceil(tempxyz(3));
                  end
              end
               
              r=1.0;
              if tempxyz(3)>0 & tempxyz(1)>0
                 U=atan(tempxyz(3) / tempxyz(1));
              end
              if tempxyz(3)>0 & tempxyz(1)<0
                  U=atan(tempxyz(3) / tempxyz(1)) +pi;
              end
              if tempxyz(3)<0 & tempxyz(1)<0
                  U=atan(tempxyz(3) / tempxyz(1))+pi;
              end
              if tempxyz(3)<0 & tempxyz(1)>0
                  U=atan(tempxyz(3) / tempxyz(1))+pi*2;
              end
            
              U=U/(2*pi);
              V=acos(tempxyz(2) / r) / pi;
              
              lenviewPoint(time,1)=lenviewPoint(time,1)+1;
              tempviewPoint(time,1)=tempviewPoint(time,1)+U;
              tempviewPoint(time,2)=tempviewPoint(time,2)+V;
        end
        
        for i=1:ceil(videoTotalTime*1.0/timegap)+1
            if lenviewPoint(i,1)==0
                continue
            end
            tempviewPoint(i,1)= tempviewPoint(i,1)*1.0/lenviewPoint(i,1);
            tempviewPoint(i,2)= tempviewPoint(i,2)*1.0/lenviewPoint(i,1);
            viewPoint(num,i,1)= tempviewPoint(i,1);
            viewPoint(num,i,2)= tempviewPoint(i,2);
        end
    end

    
    Mean=[]
    Variation=[]
    
    %�󷽲���ӵ�����
    for i=1:ceil(videoTotalTime*1.0/timegap)+1
        Mean=[Mean;abs(mean(viewPoint(:,i,1))),abs(mean(viewPoint(:,i,2)))];
        Variation=[Variation;abs(calVal(Mean(i,1),Mean(i,2),viewPoint(:,i,:)))];          
    end
    
    
    %���Ʒ���cdfͼ
    Variation_X=[]
    Variation_Y=[]
    
    Variation=sort(Variation)
    Mv=max(Variation)
    step=Mv/1000
    %��CDF����
    for i=0:step:Mv
       Variation_X=[Variation_X,i]
       Variation_Y=[Variation_Y,100*sum(Variation<=i)*1.0/sum(Variation>=0)]
    end
    
    figure
    plot(Variation_X,Variation_Y,'r-')
    xlabel('Viewpoint variation (/degree)')
    ylabel('Fractions of video clips (%)')
    title(['CDF of viewpoint variation (video:',num2str(j),')'])
    saveas(gcf,['C:/Aiqiyi/expdata/cdfgraphOfViewpointVariation/',num2str(j),'.png'])
    
end  
 
 