% frameslide.m
load frame1

[xsize,ysize]=size(frame1);
dx=input('dx ?');
dy=input('dy ?');
frame_number=10;
image_vol=zeros(xsize,ysize,frame_number);

for nf=1:frame_number
    x_add=(nf-1)*dx;
    y_add=(nf-1)*dy;
  xsize_new=xsize+x_add;
  ysize_new=ysize+y_add;
  image_new=zeros(xsize_new,ysize_new);
  image_new(x_add+1:xsize_new,y_add+1:ysize_new)=frame1;
  image_vol(1:xsize,1:ysize,nf)=image_new(1:xsize,1:ysize);
end