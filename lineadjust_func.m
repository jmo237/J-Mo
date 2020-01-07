function [xLine, yLine,entryVec]=lineadjust_func(xLine,yLine,x0,y0)
% A function to adjust starting and ending point of the lines
PointNumber=size(x0,1);
One_vec=ones(PointNumber,1);
xs=xLine(1)*One_vec;
xe=xLine(2)*One_vec;
ys=yLine(1)*One_vec;
ye=yLine(2)*One_vec;

norms=sqrt((x0-xs).^2+(y0-ys).^2);
[minValue, entryNumber]=min(norms);
xLine(1)=x0(entryNumber);
yLine(1)=y0(entryNumber);
entryVec(1)=entryNumber;

norms=sqrt((x0-xe).^2+(y0-ye).^2);
[minValue, entryNumber]=min(norms);
xLine(2)=x0(entryNumber);
yLine(2)=y0(entryNumber);
entryVec(2)=entryNumber;