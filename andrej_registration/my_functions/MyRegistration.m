function [line_moved] = MyRegistration(line_fixed,line_moving)

%MyRegistration puts one rib with its start point on the other,
%makes them pointing in one direction and rotates the moving rib until the
%distances are minimal
%params: fixed and moving lines as set of points
%return: registered line
len=30;

%rotate to point in the same direction
dir_fixed=line_fixed(1,:)-line_fixed(len,:);
dir_moving=line_moving(1,:)-line_moving(len,:);

angle=get_angle(dir_fixed,dir_moving);
normal=cross(dir_fixed,dir_moving);

for j=1:size(line_moving,1)                     %rotates each point of the line
    line_moving(j,:)=rotate_3D(line_moving(j,:)','any',deg2rad(-angle),normal')';
end

%translate to match startpoints
trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match
for j=1:size(line_moving,1)
    line_moving(j,:)=line_moving(j,:)+trans_vec;
end

opt_angle=fminsearch(@(angle)opt_rotation(line_fixed,line_moving,angle,len),angle);

for j=1:size(line_moving,1)                     %rotates each point of the line
    line_moving(j,:)=rotate_3D(line_moving(j,:)','any',deg2rad(opt_angle),dir_fixed')';
end

trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match
for j=1:size(line_moving,1)
    line_moving(j,:)=line_moving(j,:)+trans_vec;
end

line_moved=line_moving;
end



function metric = opt_rotation(line_fixed,line_moving,angle,len)

dir_fixed=line_fixed(1,:)-line_fixed(len,:);

for j=1:size(line_moving,1)                     %rotates each point of the line
    line_moving(j,:)=rotate_3D(line_moving(j,:)','any',deg2rad(angle),dir_fixed')';
end

trans_vec=line_fixed(1,:)-line_moving(1,:);     %translates the rotated line back such that the startpoints match again
for j=1:size(line_moving,1)
    line_moving(j,:)=line_moving(j,:)+trans_vec;
end

[a,b]=get_corresp_pts(line_fixed,line_moving,20);
metric=acc_distance(a,b);
end


