function vector_plot_func(handles,fn)

for nVector=1:handles.totalVectorNumber
    % handles.xLL  (starting point, ending point)
    startPoint=handles.xLL(nVector,1);
    endPoint=handles.xLL(nVector,2);
    xVecCoord=[handles.x1(startPoint,fn),handles.x1(endPoint,fn)];
    yVecCoord=[handles.y1(startPoint,fn),handles.y1(endPoint,fn)];
    % plot vector
    plot(xVecCoord,yVecCoord,[handles.ColorVec(nVector),'-'])
    % plot end point of the vector
    plot(handles.x1(endPoint,fn),handles.y1(endPoint,fn),[handles.ColorVec(nVector),'X'],'MarkerSize',10)
end
