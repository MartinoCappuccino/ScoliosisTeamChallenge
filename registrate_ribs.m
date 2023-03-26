function [line_moved] = registrate_ribs(line_fixed,line_moving)
    %MyRegistration puts one line (rib) with its start point on the other, and rotates
    %the moved one until the distances between correponding points are minimal
    %params: fixed and moving lines as set of points
    %return: registered line
    
    %translate to match startpoints
    trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end
    
    %optimization of the rotation
    init_angle_vector=[0 0];
    opt_angle_vector=fminsearch(@(angle_vector)opt_rotation(line_fixed,line_moving,angle_vector),init_angle_vector);
    
    %rotate with optimized angle
    for j=1:size(line_moving,1)                     
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','x',opt_angle_vector(1))';
    end
    
    for j=1:size(line_moving,1)                     
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','y',opt_angle_vector(2))';
    end
    
    trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end
    
    line_moved=line_moving;
end



function metric = opt_rotation(line_fixed,line_moving,angle_vector)
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
    
    [a,b]=get_corresp_pts(line_fixed,line_moving,20);
    metric=acc_distance(a,b);
end

function [dist] = acc_distance(corr_pts1,corr_pts2)
    % ACC_DISTANCE calculates the accumulated eucledian distance 
    % between the corresponding points of two ribs. This is used as a metric
    % for the registration
    % param line1: set of points on rib1
    % param line2: seet of points on rib2
    % returns distance
    
    % get the minimum size between both lines
    steps=min(size(corr_pts1,1),size(corr_pts2,1));
    
    dist=0;
    
    for i=1:steps
        % calulate euclidean distance between corresponding points of both ribs 
        euclidean_dist=sqrt(sum((corr_pts1(i,:)-corr_pts2(i,:)) .^ 2));
        % sum the total
        dist=dist+euclidean_dist;
    end
end


