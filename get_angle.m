function [angle] = get_angle(vector1,vector2)
    % GET_ANGLE calculates the angle between two vectors (i.e. a rib vector 
    % and an axis vector)
    
    % compute the cross product between vectors to obtain the orthogonal vector
    normal=cross(vector1,vector2);
    
    % normalize the orthogonal vector
    normed_normal=normal/norm(normal);
    
    % caluclate the angle between both vectors
    angle=atan2(dot(cross(vector1,vector2),normed_normal),dot(vector1,vector2));
    % convert to degrees
    angle =rad2deg(angle);
end

