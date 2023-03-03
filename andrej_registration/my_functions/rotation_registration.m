function [line_moved] = rotation_registration(line_fixed,line_moving)
%ROTATION_REGISTRATION finds the best rotation around the z axis of one rib
opt_steps=300;
[a,b]=get_corresp_pts(line_fixed,line_moving,30);
to_minimize=acc_distance(a,b);
init_angle=get_angle([line_fixed(end,1),line_fixed(end,2),0],[line_moving(end,1),line_moving(end,2),0]);

for j=1:size(line_moving,1)
        line_moving(j,:)=rotate_3D(line_moving(j,:)','z',deg2rad(-init_angle))';
end
%line_moved=line_moving;
angle =1;       %starting with rotating by one degree and turning around if it was the wrong direction
for i=1:opt_steps
    %%get new line
    
    for j=1:size(line_moving,1)
        line_moving(j,:)=rotate_3D(line_moving(j,:)','z',deg2rad(angle))';
    end

    trans_vec=line_fixed(1,:)-line_moving(1,:);
    for j=1:size(line_moving,1)
        line_moving(j,:)=line_moving(j,:)+trans_vec;
    end
    to_minimize_prev=to_minimize;
    [a,b]=get_corresp_pts(line_fixed,line_moving,30);
    to_minimize=acc_distance(a,b);

    if to_minimize_prev<to_minimize
        angle=-angle;
    else
        angle=angle;
    end
    %current_angle=get_angle([line_fixed(end,1),line_fixed(end,2)],[line_moving(end,1),line_moving(end,2)]);


end
line_moved=line_moving;

end

