function [maxValue,xrow,ycol]=max2_func(inMatrix)
 [maxVec,xvec]=max(inMatrix);
 xrow=xvec(1);
 [maxValue,ycol]=max(inMatrix(xrow,:));
clear xvec;
clear inMatrix