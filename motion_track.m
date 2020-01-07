% motion_track.m
% deribatve of pitcher_track2
% condcut power tracking and data saving of specified file
% coded by H.Kobayashi


%clear

%load car_crach

%load slide_image_p1p1
load succer
%load  balldrop
totalFrameNumber=size(image_vol,3);
imshow(image_vol(:,:,1)/256);


%method2=input('new point selection method');
figure, imshow(image_vol(:,:,1)/256);
hold
[x0,y0] = getpts
totalPointNumber=size(x0,1);

InitPoint=zeros(totalPointNumber,2);

InitPoint(:,1)=x0;
InitPoint(:,2)=y0;

close 

figure;
imshow(image_vol(:,:,1)/256);
hold
plot(InitPoint(:,1),InitPoint(:,2),'rs')
%plot(x0,y0,'b+')


psize=30;
%for nc=1:1
IN.RAD = psize;
IN.mag=3;
IN.BUF = 30;
IN.SPC = 10;

[x1,y1,NCC_vol]=f2ftrack_func100(image_vol,InitPoint,IN,totalFrameNumber,totalPointNumber);
 
% plot trajectory
x1=x1';
y1=y1';
 