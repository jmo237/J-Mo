function [NCC_val,SNR_val]=ncc_check_func(IS,IE,XC,YC,InitPoint,img,point_n)
% img:currently processed image frame NUMBER
% IS:Startingimage
% IE: Enging image
% InitPoint: coorinate matrix 
% point_n : currently rtrcked point number
cd_pre=squeeze(InitPoint(point_n,:,img))
cd_pos=squeeze(InitPoint(point_n,:,img+1))
tw = interp2(IS,XC+cd_pre(1),YC+cd_pre(2));
sw = interp2(IE,XC+cd_pos(1),YC+cd_pos(2));
SNR_val=mean(mean(sw))/std2(sw);
CM1 = normxcorr2(tw, sw);
p_size=round(size(tw,1)*0.5);
[CMx,CMy]=size(CM1);
CM1_final=CM1(p_size+1:CMx-p_size,p_size+1:CMy-p_size);
[NCC_val,loc_NCC]=max2_func(CM1_final);