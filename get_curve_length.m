function [length] = get_curve_length(rib_line)
    % CURVE_LENGHT calculates the curve length of a set of points from
    % a rib (centerline)
    % param rib_line: set of points of a rib
    % returns rib's lenght
    
    % take the size of the rib's set of points 
    steps=size(rib_line,1);
    
    length=0;
    
    for i=2:steps
        % calculate eucledian distance between adjacent set of points
        euclidean_dist=sqrt(sum((rib_line(i,:)-rib_line(i-1,:)) .^ 2));
        % sum total lenght
        length=length+euclidean_dist;
    end
end

