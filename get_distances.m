function [dist, dist_change, dist_change2] = get_distances(corr_pts1,corr_pts2, voxeldimensions) 
    % DISTANCES calculates the distances between corresponding 
    % points of two ribs
    % param corr_pts1: first ribs set of points
    % param corr_pts2: second ribs set of points
    % return dist: distance between each pair of corresponding points
    % return dist_change: change in distances between corresp points (with
    % respect to the precious pairs)
    corr_pts1(:, 1) = corr_pts1(:, 1)*voxeldimensions(1);
    corr_pts1(:, 2) = corr_pts1(:, 2)*voxeldimensions(2);
    corr_pts1(:, 3) = corr_pts1(:, 3)*voxeldimensions(3);

    corr_pts2(:, 1) = corr_pts2(:, 1)*voxeldimensions(1);
    corr_pts2(:, 2) = corr_pts2(:, 2)*voxeldimensions(2);
    corr_pts2(:, 3) = corr_pts2(:, 3)*voxeldimensions(3);
    % get the minimum size between both centerlines
    steps=min(size(corr_pts1,1),size(corr_pts2,1));
    
    % array of distances between corresponding points
    dist=zeros(steps,1);
    for i=1:steps
        % calulate euclidean distance between corresponding points of both ribs
        eucledian_dist=sqrt(sum((corr_pts1(i,:)-corr_pts2(i,:)) .^ 2));
        % save value
        dist(i)=eucledian_dist;
    end
    
    % array of distances shift
    dist_change=zeros(steps,1);
    step_length=norm(corr_pts1(1,:)-corr_pts1(2,:));
    for i=2:steps
        % normed difference from adjacent corresponding point distances
        dist_change(i)=abs((dist(i)-dist(i-1)))/step_length;
    end

    % array of distances shift
    dist_change2=zeros(steps,1);
    step_length=norm(dist_change(1,:)-dist_change(2,:));
    for i=2:steps
        % normed difference from adjacent corresponding point distances
        dist_change2(i)=abs((dist(i)-dist(i-1)))/step_length;
    end
end