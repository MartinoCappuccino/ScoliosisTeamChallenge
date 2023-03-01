function [angle] = get_angle(vec1,vec2)
%GET_ANGLE Summary of this function goes here
%   Detailed explanation goes here
normal=cross(vec1,vec2);
normed_normal=normal/norm(normal);

angle=atan2(dot(cross(vec1,vec2), normed_normal),dot (vec1,vec2));
angle =rad2deg(angle);
end

