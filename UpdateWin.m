%===========================
    function UpdateWin(pl,time_vec,y)
    %global pl;
    c=get(pl,'CurrentSample');
    t=get(pl,'TotalSamples');
    %disp(c);
    %disp(y(c,1));
    %disp(y(c,2));
    %s_vec1=y(1:c,1);
    %s_vec2=y(1:c,2);
    %t_vec=time_vec(1:c);
    
     hl=line([c,c],[-1,1],'Color','k','LineStyle','--')
    
    %time_vec=[1:t];
    %plot(time_vec,y(:,1),'g');
    %axis([0,t,-1,1]);
    %hold
    %plot(time_vec,y(:,2),'r');
    %axis([0,t,-1,1]);
    
 
    %xvec=[c,c];
    %yvec=[-1,1];
    %plot(t_vec,s_vec1,'g')
    %plot(xvec,yvec,'k--')
    %axis([0,t,-1,1]);
    %lh=line([c,-1],[c,1],'k--')  
    

    %hold
    %plot(t_vec,s_vec2,'r')
    %plot(c,y(c,2),'r s')
    %axis([0,t,-1,1]);
    drawnow   % NEED this line! otheriwse line does not appear! 
    delete(hl)
       