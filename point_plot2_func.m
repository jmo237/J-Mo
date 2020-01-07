function point_plot2_func(handles,fn,blocksize)
for nPoint=1:handles.totalPointNumber
    plot(handles.x1(nPoint,fn),handles.y1(nPoint,fn),[handles.ColorVec(nPoint),'s'],'MarkerSize',blocksize)
end