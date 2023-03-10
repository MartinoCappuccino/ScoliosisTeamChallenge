function [line_moved] = rotation_registration(line_fixed,line_moving)

%ROTATION_REGISTRATION finds the best rotation around the z axis of one rib
%the input are two lines discribed as subsequent points, the output is the
%moved line describes as subsequent points
%It tries to minimize the sum of all distances between corresponding points
%between the two curves by rotating one curve

opt_steps=300;                                      %Note: make it stop automatically when it starts oscilating around one point
[a,b]=get_corresp_pts(line_fixed,line_moving,20);   %initializing the metric
to_minimize=acc_distance(a,b);

angle =1;                                           %starting with rotating by one degree and turning around if it was the wrong direction
for i=1:opt_steps
    
    for j=1:size(line_moving,1)                     %rotates each point of the line
        line_moving(j,:)=rotate_3D(line_moving(j,:)','z',deg2rad(angle))';
    end
    
    trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match again
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end

    to_minimize_prev=to_minimize;                   %update of the metric
    [a,b]=get_corresp_pts(line_fixed,line_moving,20);
    to_minimize=acc_distance(a,b);

    if to_minimize_prev<to_minimize                 %check if rotation direction has to be changes
        angle=-angle;
    else
        angle=angle;
    end
end

line_moved=line_moving;
end

%%%note it might be worth it to change the rotation axis from the z axis to
%%%the orientation of the fixed rib. 