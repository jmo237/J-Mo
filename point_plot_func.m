function point_plot_func(handles,fn)
for nPoint=1:handles.totalPointNumber
    plot(handles.x1(nPoint,fn),handles.y1(nPoint,fn),[handles.ColorVec(nPoint),'s'],'MarkerSize',10)
end