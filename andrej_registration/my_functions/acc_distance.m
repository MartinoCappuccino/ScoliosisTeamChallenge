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

