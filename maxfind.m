%maxfind.m
A=[     14     7     0
     7     0     21
     2     3     8];
 
 [maxValue,row]=max(max(A));
 rowM=A(row,:);
 [maxValue,col]=max(rowM);
 A
 row
 col