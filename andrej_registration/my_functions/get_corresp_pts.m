function [pts_1,pts_2] = get_corresp_pts(rib_line1,rib_line2, N_pts)
% GET_CORRESP_PTS calculates the corresponding points between two rib 
% centerlines.
% param rib_line1: first rib line 
% paran rib_line2: second rib line
% param N_pts: amount of corresponding points between lines 
% The maximum number of corresponding points is 1/10 of the shortest curve 
% length of the lines in voxels
% returns two sets of corresponding points

% check if requirements are met
curve_length1=curve_length(rib_line1);
curve_length2=curve_length(rib_line2);

if min(curve_length2,curve_length1)/10<N_pts
    error('too many corresponding points asked for a too short rib');
end


% initializing output
pts_1=zeros(N_pts,3);
pts_2=zeros(N_pts,3);

% desired distance between corresponding points
% +1 because the number of intervals is one more than the number of points 
delta1=curve_length1/(N_pts+1);       
delta2=curve_length2/(N_pts+1);


% GET THE POINTS
% first accumulate until desired curve lenght is passed, then look if
% previous curve length might be the one of interest, and write the correct
% point in the vector

length1=0;
length2=0;
n1=1;
n2=1;
steps1=size(rib_line1,1);
for i=2:steps1
    % calculate euclidean distance between adjacent points
    euclidean_dist1=sqrt(sum((rib_line1(i,:)-rib_line1(i-1,:)) .^ 2));
    length1=length1+euclidean_dist1;
    if length1>n1*delta1
        prev_length1=length1-euclidean_dist1;
        if (n1*delta1-prev_length1)<(length1-n1*delta1)
            pts_1(n1,:)=rib_line1(i,:);
            n1=n1+1;
        else
            pts_1(n1,:)=rib_line1(i-1,:);
            n1=n1+1;
        end
    end

end

steps2=size(rib_line2,1);
for i=2:steps2
    euclidean_dist2=sqrt(sum((rib_line2(i,:)-rib_line2(i-1,:)) .^ 2));
    length2=length2+euclidean_dist2;
    if length2>n2*delta2
        prev_length2=length2-euclidean_dist2;
        if (n2*delta2-prev_length2)<(length2-n2*delta2)
            pts_2(n2,:)=rib_line2(i,:);
            n2=n2+1;
        else
            pts_2(n2,:)=rib_line2(i-1,:);
            n2=n2+1;
        end
    end
end

end

