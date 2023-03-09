function [dist,dist_change] = distances(corr_pts1,corr_pts2)
%%calculates the accumulated distance between corresponding points on the
%%two ribs, stops where the first rib stops
%takes lines as input argument
steps=min(size(corr_pts1,1),size(corr_pts2,1));

dist=zeros(steps,1);
for i=1:steps
    eucledian_dist=sqrt(sum((corr_pts1(i,:)-corr_pts2(i,:)) .^ 2));
    dist(i)=eucledian_dist;
end

dist_change=zeros(steps,1);
for i=2:steps
    dist_change(i)=dist(i)-dist(i-1);
end

end