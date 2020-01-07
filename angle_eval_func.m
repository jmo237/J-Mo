function angle_out=angle_eval_func(xcoord,ycoord)


if xcoord*ycoord >= 0
    if xcoord > 0
        % 1st quadrant
        angle_out=atan(ycoord/xcoord);
        %angle_out=atan(ycoord/xcoord)/pi*180;
    else
        % 3rd quadrant
        angle_out=atan(ycoord/xcoord)+pi;
        %angle_out=atan(ycoord/xcoord)/pi*180+180;
    end
end

if xcoord*ycoord < 0
    if xcoord < 0
        % 2nd quadrant
        angle_out=atan(ycoord/xcoord)+pi;
        %angle_out=atan(ycoord/xcoord)/pi*180+180;
    else
        % 4th quadrant
        angle_out=atan(ycoord/xcoord)+2*pi;
        %angle_out=atan(ycoord/xcoord)/pi*180+360;
    end
end
     