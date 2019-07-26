function [result]=CalPSPNRPerTile(Center,img_raw,img_target,R,Fresult_all) %�������������ͼƬ��ͼ��R����Ҫ��ȫ��ֻҪ�Ǵ����ֵ�JND���ԾͿ��ԣ����������޴��������
     D_JND=abs(img_target-img_raw);
    [H,W]=size(img_raw);
    temp_PSPNR=0;
    for j=1:H
        for k=1:W
            if D_JND(j,k)-R(j,k)>=0
                temp_PSPNR=temp_PSPNR+(D_JND(j,k)-R(j,k))^2;
            end
        end
    end   
    temp_PSPNR= sqrt(temp_PSPNR/(H*W));
    PSPNR=20*log10(255.0/temp_PSPNR);
    result=PSPNR;
end