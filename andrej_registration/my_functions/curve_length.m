function [length] = curve_length(rib_line)
% curve_length calculates the curve lenth of a set of points from
% a rib (line)
% param rib_line

% take the size of the rib's set of points 
steps=size(rib_line,1);

length=0;
% calculate the eucledian distance between adjacent set of points
% and sum the total lenght
for i=2:steps
    euclidean_dist=sqrt(sum((rib_line(i,:)-rib_line(i-1,:)) .^ 2));
    length=length+euclidean_dist;
end



end

