function [dist] = acc_distance(rib_line1,rib_line2)

% acc_distance function calculates the accumulated eucledian distance 
% between the corresponding points of two ribs. It stops when the 
% minimum size between both ribs is reached.
% param line1: first line of rib points
% param line2: second line of rib points

% get the minimum size between both lines
steps=min(size(rib_line1,1),size(rib_line2,1));

dist=0;
% in each step calulate the euclidean distance between the 
% corresponding points of both ribs and sum the total
for i=1:steps
    euclidean_dist=sqrt(sum((rib_line1(i,:)-rib_line2(i,:)) .^ 2));
    dist=dist+euclidean_dist;
end


end

