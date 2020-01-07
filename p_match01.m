% p_match01.m
% 1)import ultrasound image  
% 2)CROP play-ground ROI
% 3)Create 3 copies of play-ground
%     g0  no-niose
%     g1  noised with Rayliegh noise1
%     g2  noised with Rayliegh noise2
% The distribution of rayliegh noise is the same.
% 4)Get target window tw1 at the center of g1
% 5) find matching window in g2 by
% 6) normxcorr2
% 7) CD2 norm
% 8) 6) + 7)

[FileName,PathName,FilterIndex] = uigetfile('*.tif');
infile=[PathName,FileName]

% image import
I = imread(infile);

% 1st layer extraction 
I0=I(:,:,1);

% intensity equilizer
%I1 = adapthisteq(I0,'clipLimit',0.01,'Distribution','rayleigh');
% no-equilization
I1=I0;

% play-ground crop
[J BOX] = imcrop(I1);
[m,n]=size(J);
% scale factor 
B=1;
g0=double(J);
mg0=mean(mean(g0));
R1 = raylrnd(B,m,n);
R2 = raylrnd(B,m,n);

mag=input(' mag? ');

g1= g0+R1*mag;
mg1=mean(mean(g1));
df1=mg1-mg0;
g1=g1-df1;

g2= g0+R2*mag;
mg2=mean(mean(g2));
df2=mg2-mg0;
g2=g2-df2;

figure
imshow(g1/256);
figure
imshow(g2/256);

% centroid evalution
xc=size(J,1)/2;
yc=size(J,2)/2;

tw1=g1(xc-20:xc+20,yc-20:yc+20);
tw0=g0(xc-20:xc+20,yc-20:yc+20);

% find location by normcorr
CM0 = normxcorr2(tw0, g0)
CM1 = normxcorr2(tw1, g2)

check=input('looks ok ?')



