% SampleAnimation
Nt=100;
xmin=0.1;
xmax=0.9;
yval=0.3;
x=linspace(xmin,xmax,Nt);
for it=1:Nt
  plot(x(it), yval,'ro')
  axis([0,1,0,1]);
  drawnow
end