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
    opt_angle_vector=fminsearch(@(angle_vector)get_opt_rotation(line_fixed,line_moving,angle_vector),init_angle_vector);
    
    %rotate with optimized angle
    for j=1:size(line_moving,1)                     
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','x',get_opt_angle_vector(1))';
    end
    
    for j=1:size(line_moving,1)                     
        line_moving(j,:)=rotate_ribs(line_moving(j,:)','y',get_opt_angle_vector(2))';
    end
    
    trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end
    
    line_moved=line_moving;
end
