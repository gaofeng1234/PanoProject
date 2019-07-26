

%  timegap=5  %����ÿһ��ͳ�Ƶ�ʱ������Ϊ1��
%  option=2 %2����UV���� 3����XYZ����
%  %ͳ��ÿ����Ƶ���û��ӵ㷽��
% realviewPoint=[]
% videoTotalTime=-1;
%  for j=8:8  %������ƵID
% 
%     quan_list=[]; %�洢��Ԫ��
%     time_list=[]; %�洢��Ԫ�� ��Ӧ����ʱ��
%     for num=1:48 %ÿһ���û�
%         m=readtable(['C:/Aiqiyi/expdata/Experiment_1/',num2str(num),'/video_',num2str(j),'.csv']);
%         quan_list=m(1:end,3:6);
%         time_list=table2array(m(1:end,2));
%         tempVideoTotalTime=max(time_list(:));
%         %����Ƶ����
%         if tempVideoTotalTime>videoTotalTime
%              videoTotalTime=tempVideoTotalTime;
%         end
%     end
%     videoTotalTime=ceil(videoTotalTime); %������Ƶ����
%     viewPoint=zeros(48,ceil(videoTotalTime*1.0/timegap)+1,option);  %�洢ÿ��ʱ�����ڵ�ƽ�������ӵ�
%  
%     %���û��ӵ���ͳ��
%     for num=1:48 %ÿһ���û�
%         num
%         m=readtable(['C:/Aiqiyi/expdata/Experiment_1/',num2str(num),'/video_',num2str(j),'.csv']);
%         quan_list=m(1:end,3:6);
%         time_list=table2array(m(1:end,2));
%         [x,y]=size(quan_list);
%         tempviewPoint=zeros(ceil(videoTotalTime*1.0/timegap)+1,option);
%         lenviewPoint=zeros(ceil(videoTotalTime*1.0/timegap)+1,1);     
%         %����û���timegap������ӵ�����
%         
%         for i=1:x %ÿһ������
%               q1=quan_list(i,:);
%               q2=table2array(q1); %ÿһ������һ�е�����
%               time=ceil(time_list(i,1)/timegap)+1;
%               
%               tempxyz=[2*q2(1)*q2(3)+2*q2(2)*q2(4);2*q2(2)*q2(3)-2*q2(1)*q2(4);1-2*q2(1)*q2(1)-2*q2(2)*q2(2)];
%               
%               if abs(tempxyz(1))>=1
%                   if tempxyz(1)>0
%                       tempxyz(1)=floor(tempxyz(1));
%                   else
%                       tempxyz(1)=ceil(tempxyz(1));
%                   end
%               end
%               
%               if abs(tempxyz(2))>=1
%                   if tempxyz(2)>0
%                       tempxyz(2)=floor(tempxyz(2));
%                   else
%                       tempxyz(2)=ceil(tempxyz(2));
%                   end
%               end
%               
%               if abs(tempxyz(3))>=1
%                   if tempxyz(3)>0
%                       tempxyz(3)=floor(tempxyz(3));
%                   else
%                       tempxyz(3)=ceil(tempxyz(3));
%                   end
%               end
%                
%               r=1.0;
%               if tempxyz(3)>0 & tempxyz(1)>0
%                  U=atan(tempxyz(3) / tempxyz(1));
%               end
%               if tempxyz(3)>0 & tempxyz(1)<0
%                   U=atan(tempxyz(3) / tempxyz(1)) +pi;
%               end
%               if tempxyz(3)<0 & tempxyz(1)<0
%                   U=atan(tempxyz(3) / tempxyz(1))+pi;
%               end
%               if tempxyz(3)<0 & tempxyz(1)>0
%                   U=atan(tempxyz(3) / tempxyz(1))+pi*2;
%               end
%             
%               U=U/(2*pi);
%               V=acos(tempxyz(2) / r) / pi;
%               
%               lenviewPoint(time,1)=lenviewPoint(time,1)+1;
%               tempviewPoint(time,1)=tempviewPoint(time,1)+U;
%               tempviewPoint(time,2)=tempviewPoint(time,2)+V;
%         end
%         
%         for i=1:ceil(videoTotalTime*1.0/timegap)+1
%             if lenviewPoint(i,1)==0
%                 continue
%             end
%             tempviewPoint(i,1)= tempviewPoint(i,1)*1.0/lenviewPoint(i,1);
%             tempviewPoint(i,2)= tempviewPoint(i,2)*1.0/lenviewPoint(i,1);
%             viewPoint(num,i,1)= tempviewPoint(i,1);
%             viewPoint(num,i,2)= tempviewPoint(i,2);
%         end
%     end
%     
%     savePath =['C:\Aiqiyi\expdata\clusterData\',num2str(j),'.mat'];
%     save(savePath,'viewPoint'); 
% end 


j=1
realviewPoint=cell2mat(struct2cell(load(['C:\Aiqiyi\expdata\clusterData\',num2str(j),'.mat'])))
%     ����Kmeans����
%     X N*P�����ݾ���
%     Idx N*1������,�洢����ÿ����ľ�����
%     Ctrs K*P�ľ���,�洢����K����������λ��
%     SumD 1*K�ĺ�����,�洢����������е���������ĵ����֮��
%     D N*K�ľ��󣬴洢����ÿ�������������ĵľ���;
    

 [xxx yyy zzz]=size(realviewPoint)
  %ͳ��һ��ָ�꣬ÿһ��5�룬���������û����ӵ�λ�õĴ���
  AbnormalTimes=zeros(48,1);
for j=1:yyy
    X=realviewPoint(:,j,:);
    X=reshape(X,48,2)
    AverageDistance=[];
    flag=0;
    bestClusters=1;
    %ȷ����Ѿ�������
    for Types=1:48
        if flag==1
            break
        end
        opts = statset('Display','final');
        [Idx,Ctrs,SumD,D] = kmeans(X,Types,'Options' ,opts,'Replicates',100);
        for i=1:Types
            SumD(i,1)=SumD(i,1)/sum(Idx==i);
        end
        AverageDistance=[AverageDistance,mean(SumD)];
        if Types>=3 
            Diff=abs(diff(AverageDistance));
             %���ֵ���
             for i=1:Types-1
                 Diff(i)=Diff(i)/AverageDistance(1,i);
             end

       %����Ѿ۴���
             for i=1:Types-2
                  if(i==1 & Diff(i)<0.2)
                     flag=1;
                     bestClusters=1;
                     break
                  end
                  if Diff(i+1)<Diff(i)*0.7 
                     flag=1;
                     bestClusters=i+1;
                     break
                  end
            end
       
         end
    end
    
    opts = statset('Display','final');
    [Idx,Ctrs,SumD,D] = kmeans(X,bestClusters,'Options' ,opts,'Replicates',100);
%     figure
%     hold on
    MaxNum=-1;
    MaxTag=1;
    
    for c =1:bestClusters
        if sum(Idx==c)>=MaxNum
            MaxNum=sum(Idx==c);
            MaxTag=c;
        end
    end
    
    for c=1:48
        if Idx(c,1)~=MaxTag
             AbnormalTimes(c,1)=AbnormalTimes(c,1)+1;
        end
    end
    
%     for c =1:bestClusters
%         plot(X(Idx==c,1),X(Idx==c,2),'o','color',[0,c*1.0/bestClusters,0],'MarkerSize',6)
%         hold on
%     end
%     saveas(gcf,['C:\Aiqiyi\expdata\clusterGraph\',num2str(j),'_timegap.png'])
end
['�������û�:']
find(AbnormalTimes==max(AbnormalTimes))
max(AbnormalTimes)
