function [pts_1,pts_2] = get_corresp_pts(line1,line2, N_pts)
%returns two sets of points which are the corresponding points between the
%lines
%N_pts is the amount of corresponding points between the lines the maximum
%number of corresponding points is 1/10 of the curve length of the shorter line in voxels

%check if requirements are met
curve_length1=curve_length(line1);
curve_length2=curve_length(line2);

if min(curve_length2,curve_length1)/10<N_pts
    error('too many corresponding points asked for a too short rib');
end


%initializing output
pts_1=zeros(N_pts,3);
pts_2=zeros(N_pts,3);

%%desired distance between corresponding points
delta1=curve_length1/(N_pts+1);        %+1 because the number of intervals is one more than the number of points (another solution would be to add the first or the last point of the rib to the array)
delta2=curve_length2/(N_pts+1);


%%get the points

%first accumulate until desired curve lenght is passee, then look if
%previous curve length might be the one of interest, and write the correct
%point in the vector


length1=0;
length2=0;
n1=1;
n2=1;
steps1=size(line1,1);
for i=2:steps1
    eucledian_dist1=sqrt(sum((line1(i,:)-line1(i-1,:)) .^ 2));
    length1=length1+eucledian_dist1;
    if length1>n1*delta1
        prev_length1=length1-eucledian_dist1;
        if (n1*delta1-prev_length1)<(length1-n1*delta1)
            pts_1(n1,:)=line1(i,:);
            n1=n1+1;
        else
            pts_1(n1,:)=line1(i-1,:);
            n1=n1+1;
        end
    end

end

steps2=size(line2,1);
for i=2:steps2
    eucledian_dist2=sqrt(sum((line2(i,:)-line2(i-1,:)) .^ 2));
    length2=length2+eucledian_dist2;
    if length2>n2*delta2
        prev_length2=length2-eucledian_dist2;
        if (n2*delta2-prev_length2)<(length2-n2*delta2)
            pts_2(n2,:)=line2(i,:);
            n2=n2+1;
        else
            pts_2(n2,:)=line2(i-1,:);
            n2=n2+1;
        end
    end
end

end

