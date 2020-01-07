function [x1,y1]=f2ftrack_func(x1,y1,psize,totalFrameNumber,totalPointNumber)

for nf=1:totalFrameNumber-1
    frameNow=image_vol(:,:,nf);
    frameNext=image_vol(:,:,nf+1);
    for np=1:totalPointNumber
        xNow=x1(np,nf);
        yNow=y1(np,nf);
        patchNow=frameNow(xNow-psize:xNow+psize, yNow-psize:yNow+psize);
        patchNext=frameNext(xNow-psize:xNow+psize, yNow-psize:yNow+psize);
        CM0 = normxcorr2(patchNow, patchNext);
        %imagesc(CM0);
       
        patch_c=CM0(psize+1:end-psize,psize+1:end-psize);
       
        patch_hs(:,:,nf)=patchNow;
         %check=input('happy? ');
        %[max_val, maxX,maxy]=max2d_func(patch_c);  %%% Need ti find or create this function. 
       
        [maxValue,xrow,ycol]=max2_func(patch_c)
        maxValueHistory(np,nf)=maxValue;    
        DX=xrow-(psize+1);
        DY=ycol-(psize+1);
        
        xNew=x1(np,nf)+DX;
        yNew=y1(np,nf)+DY;
        x1(np,nf+1)=xNew;
        y1(np,nf+1)=yNew;
        % x,y cooridnate flip for proper plot
        
    end
end
