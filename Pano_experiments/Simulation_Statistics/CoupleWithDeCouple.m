function CoupleWithDeCouple(videoid,set,frameStart,frameEnd,framegap)
%������ͨ���ڱ����ʱ�򲻿����ӵ����أ������û�ʵ��ѡ���ʱ��ʹ��ϵ����������ѡ��
%����һ��240*240����Ƶ�飬������Ϊʧ��������64�Ŀ��ǲ��ܽ������ʽ��͵�
%1��������Ҫ������ϣ������ǳ���JND�����ص������������������
%2��������Ƶ�е�ÿ��tile�ֱ���㣬�����²���
%3�������tile������JND�����ص�����ǡ��Ϊ64ʱ��Ӧ�����ʣ���������64�Ķ�Ӧ�����ᣬ��Ϊ����Ӧ�õ���������
path(path,'I:\��Ƶ���۵���\Potential improment');
path(path,'I:\��Ƶ���۵���\Potential improment\������Potential improvement');
path(path,'I:\��Ƶ���۵���\Potential improment\������Potential improvement\Tiling');
%------------------------------------------------
% videoid=0;
% userid=1;
% framegap=30;
% frameStart=781;
% frameEnd=781;
mm=12;
nn=24;
% set='set2'

if set=='set1'
    ss=1;
else
    ss=2;
end
cont=1;%�����ã���¼��ǰ�ǵڼ���X֡
%------------------------------------------------

%�ֱ�������QP����1501֡���ۼƴ���
%�ֱ�������QP����1501֡���ۼ�PSPNR
%RotationSpeed=GetRotationSpeed(videoid,1,userid,framegap); %ÿһ�д����X��10֡�ڵ���ת�ٶ�

for frame=frameStart:framegap:frameEnd  %ÿһ����Ҫ��288*20�����
    try
        fit_result=zeros(12,24,20,6);
        fit_result_B=zeros(12,24,1);
        for x=1:mm
            for y=1:nn
                [x y]
                flag=0;
                XXXX=struct2cell(load(['I:\��Ƶ���۵���\Pot ential improment\������Potential improvement\PMSE\R\cd\',set,'\',num2str(videoid),'\',num2str(frame),'_',num2str(x),'_',num2str(y),'\X.mat']));
                YYYY=struct2cell(load(['I:\��Ƶ���۵���\Potential improment\������Potential improvement\PMSE\R\cd\',set,'\',num2str(videoid),'\',num2str(frame),'_',num2str(x),'_',num2str(y),'\Y.mat']));
                AAAA=struct2cell(load(['I:\��Ƶ���۵���\Potential improment\������Potential improvement\PMSE\R\cd\',set,'\',num2str(videoid),'\',num2str(frame),'_',num2str(x),'_',num2str(y),'\A.mat']));
                XXXX=XXXX{1};
                YYYY=YYYY{1};
                AAAA=AAAA{1};
                for qp=42:-1:22
                    %���Ȱ�FJNDֵ��ƽ��ֵ�������
                    tempX=XXXX{qp};
                    tempY=YYYY{qp};
                    X=[];
                    Y=[];
                    step=5;
                    for i=1:step-1
                        X=[X,mean(tempX(i:step:end))];
                        Y=[Y,(max(tempY(i:step:end))+min(tempY(i:step:end)))/2];
                    end
                    result_sin=cell(step-1,1);
                    %����Ҫȷ�����A
                    A_reason=zeros(step-1,1);
                    for i=1:step-1
                        A_reason(i)=(max(tempY(i:step:end))-min(tempY(i:step:end)))/2;  %�������
                    end
                    fitTypeMseToBitrate_A=fittype('a.*x.^b','independent','x','coefficients',{'a','b'});
                    opt_A=fitoptions(fitTypeMseToBitrate_A);
                    opt_A.StartPoint=[max(A_reason(:)),-3];
                    result_A=fit(X',A_reason, fitTypeMseToBitrate_A,opt_A);
                    
                    %Ȼ��Ҫȷ��ƫ����B
                    for i=1:1
                        tempA=AAAA{qp};
                        fitTypeMseToBitrate_sin=fittype('a.*sin( x+b) ','independent','x','coefficients',{'a','b'});
                        opt_sin=fitoptions(fitTypeMseToBitrate_sin);
                        opt_sin.StartPoint=[A_reason(i),1];
                        AA=tempA(i:step:end)*2*pi/360;
                        YY=tempY(i:step:end)-(max(tempY(i:step:end))+min(tempY(i:step:end)))/2;
                        t=fit(AA',YY',fitTypeMseToBitrate_sin,opt_sin);
                        B=t.b;
                    end
                    
                    %��������ƫ����C
                    C_reason=zeros(step-1,1);
                    for i=1:step-1
                        C_reason(i)=(max(tempY(i:step:end))+min(tempY(i:step:end)))/2;  %�������
                    end
                    fitTypeMseToBitrate_C=fittype('a.*x.^b ','independent','x','coefficients',{'a','b'});
                    opt_C=fitoptions(fitTypeMseToBitrate_C);
                    opt_C.StartPoint=[max(C_reason(:)),-3];
                    result_C=fit(X',C_reason, fitTypeMseToBitrate_C,opt_C);
                    fit_result(x,y,qp,1)= single(result_A.a);
                    fit_result(x,y,qp,2)= single(result_A.b);
                    fit_result(x,y,qp,3)= single(result_C.a);
                    fit_result(x,y,qp,4)= single(result_C.b);
                    
                    if(flag==0)
                        flag=1;
                        fit_result_B(x,y,1)=B;
                    end
                    
                    %����С��0�Ķ���Ϊ��0����
%                     for i=1:step-1
%                         i
%                         tempA=AAAA{qp};
%                         fitTypeMseToBitrate_sin=fittype('a.*sin( x+b)','independent','x','coefficients',{'a','b'});
%                         opt_sin=fitoptions(fitTypeMseToBitrate_sin);
%                         opt_sin.StartPoint=[A_reason(i),1];
%                         AA=tempA(i:step:end)*2*pi/360;
%                         YY=tempY(i:step:end)-(max(tempY(i:step:end))+min(tempY(i:step:end)))/2;
%                         t=fit(AA',YY',fitTypeMseToBitrate_sin,opt_sin);
%                         result_sin{i}=t;
%                         %ʵ��ϵͳ��ϣ����ȸ���FJND�������Ӧ������ƽ��ֵ
%                         %�ٸ���FJND�������ֵ
%                         %server��ǰ�����tile����λ
%                         %��λ����result_sin{i}.b�����ڹ̶�Ϊ2pi����ֵ��Ҫ�������
%                         
%                         y2=@(x,a,b) a*sin(x+b);
%                         figure,
%                         plot(AA,y2(AA,result_A(tempX(i)),B)+result_C(tempX(i)),'k*-');
%                         hold on
%                         plot(AA,result_sin{i}(AA)+(max(tempY(i:step:end))+min(tempY(i:step:end)))/2,'go-');
%                         hold on
%                         plot(AA,YY+(max(tempY(i:step:end))+min(tempY(i:step:end)))/2,'ro-');
%                         legend('�ҵ�','���','��ʵ')
%                     end
                    
                end
                
            end
        end
        mkdir(['I:\��Ƶ���۵���\Potential improment\Fit_B\',num2str(ss),'\',num2str(videoid)]);
        mkdir(['I:\��Ƶ���۵���\Potential improment\Fit_AC\',num2str(ss),'\',num2str(videoid)])
        save(['I:\��Ƶ���۵���\Potential improment\Fit_B\',num2str(ss),'\',num2str(videoid),'\',num2str(frame),'.mat'],'fit_result_B');
        save(['I:\��Ƶ���۵���\Potential improment\Fit_AC\',num2str(ss),'\',num2str(videoid),'\',num2str(frame),'.mat'],'fit_result');
     catch
         [frame]
         continue
     end
end










