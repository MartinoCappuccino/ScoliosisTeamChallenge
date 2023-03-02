function [dist] = acc_distance(line1,line2)
%%calculates the accumulated distance between corresponding points on the
%%two ribs, stops where the first rib stops
%takes lines as input argument
steps=min(size(line1,1),size(line2,1));

dist=0;
for i=1:steps
    eucledian_dist=sqrt(sum((line1(i,:)-line2(i,:)) .^ 2));
    dist=dist+eucledian_dist;
end


end

