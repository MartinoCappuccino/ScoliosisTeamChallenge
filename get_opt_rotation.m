function metric = get_opt_rotation(line_fixed,line_moving,angle_vector)
    xAngle=angle_vector(1);
    yAngle=angle_vector(2);
    
    
    for j=1:size(line_moving,1)                     %rotates each point of the line
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','x',xAngle)';
    end
    
    for j=1:size(line_moving,1)                     %rotates each point of the line
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','y',yAngle)';
    end
    
    trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match again
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end
    amount_pts=round(min([size(line_moving,1),size(line_fixed,1)])/10);
    [a,b]=get_corresp_pts(line_fixed,line_moving,amount_pts);
    metric=get_acc_distance(a,b);
end