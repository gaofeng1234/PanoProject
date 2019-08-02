

 gapX=1.0/12
 gapY=1.0/6
 heatmap=zeros(6,12)

 for j=1:1
    for num=1:1
        m=readtable(['C:/Aiqiyi/expdata/Experiment_1/',num2str(num),'/video_',num2str(j),'.csv']);
        quan_list=m(1:end,3:6);
        [x,y]=size(quan_list)
        X=[]
        for i=1:x
              q1=quan_list(i,:);
              q2=table2array(q1);
              tempxyz=[2*q2(1)*q2(3)+2*q2(2)*q2(4);2*q2(2)*q2(3)-2*q2(1)*q2(4);1-2*q2(1)*q2(1)-2*q2(2)*q2(2)];
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
              U=floor(U/gapX);
              V=floor(V/gapY);
              X=[X;U,V];
              heatmap(V+1,U+1)=heatmap(V+1,U+1)+1;
        end  
        figure
        XX=0:11;
        YY=0:5;
        [xg,yg]=meshgrid(XX,YY);
        surf(xg,yg,heatmap);
        title(['Viewpoint distribution diagram of user ',num2str(num),'watching video ',num2str(j)])
        xlim([0,11])
        ylim([0,5])
        view(2); 
        shading interp 
        axis off 
        grid on
        
        figure
        %X�������ֵ����ݼ�
        opts = statset('Display','final');

        %����Kmeans����
        %X N*P�����ݾ���
        %Idx N*1������,�洢����ÿ����ľ�����
        %Ctrs K*P�ľ���,�洢����K����������λ��
        %SumD 1*K�ĺ�����,�洢����������е���������ĵ����֮��
        %D N*K�ľ��󣬴洢����ÿ�������������ĵľ���;

        [Idx,Ctrs,SumD,D] = kmeans(X,3,'Options',opts);
        
       
        %��������Ϊ1�ĵ㡣X(Idx==1,1),Ϊ��һ��������ĵ�һ�����ꣻX(Idx==1,2)Ϊ�ڶ���������ĵڶ�������
        plot(X(Idx==1,1),X(Idx==1,2),'r.','MarkerSize',14)
        hold on
        plot(X(Idx==2,1),X(Idx==2,2),'b.','MarkerSize',14)
        hold on
        plot(X(Idx==3,1),X(Idx==3,2),'g.','MarkerSize',14)
        
        %����������ĵ�,kx��ʾ��Բ��
        plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
        plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LinWidth',4)
        plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
        xlim([0,11])
        ylim([0,5])e
        legend('Cluster 1','Cluster 2','Cluster 3','Centroids','Location','NW')
           
    end
end

 
 



