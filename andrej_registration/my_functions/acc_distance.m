function [dist] = acc_distance(rib_line1,rib_line2)

% ACC_DISTANCE calculates the accumulated eucledian distance 
% between the corresponding points of two ribs. It stops when the 
% minimum size between both ribs is reached.
% param line1: first line of rib points
% param line2: second line of rib points
% returns distance

% get the minimum size between both lines
steps=min(size(rib_line1,1),size(rib_line2,1));

dist=0;

for i=1:steps
    % calulate euclidean distance between corresponding points of both ribs 
    euclidean_dist=sqrt(sum((rib_line1(i,:)-rib_line2(i,:)) .^ 2));
    % sum the total
    dist=dist+euclidean_dist;
end
end

