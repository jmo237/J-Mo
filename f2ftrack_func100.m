function [x1,y1,NCC_vol,SNR_vol]=f2ftrack_func100(image_vol,InitPoint,IN,totalFrameNumber,totalPointNumber);

OUT=core_dic_func100(image_vol,IN,InitPoint) %8-21-2012  

 IP_dic=OUT.IP;
 M_dic=OUT.M;
 NCC_vol=OUT.NCC;
 SNR_vol=OUT.SNR;
 
 x1=zeros(totalPointNumber,totalFrameNumber);
 y1=x1;
 
 for np=1:totalPointNumber
   x1(np,:)=squeeze(IP_dic(np,1,:));
   y1(np,:)=squeeze(IP_dic(np,2,:));
 end

 