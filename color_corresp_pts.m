function cloud=color_corresp_pts(distance,corresp_pts, mean_threshold_derivative, std_threshold_derivative)
    %This function tries to color code two ribs based on their differences from
    %registration.
    lower_threshold = mean_threshold_derivative;
    mid_threshold = mean_threshold_derivative+std_threshold_derivative;
    max_threshold = mean_threshold_derivative+2*std_threshold_derivative; 

    cloud=pointCloud(corresp_pts);
    
    cloud.Color=uint8(zeros(cloud.Count,3));
    
    for i=1:size(distance)
        if distance(i)>max_threshold
            cloud.Color(i,1)=255;
            cloud.Color(i,2)=0;
            cloud.Color(i,3)=0;
        elseif distance(i)>mid_threshold && distance(i) < max_threshold
            cloud.Color(i, 1)=255;
            cloud.Color(i, 2)=255-(distance(i)-mid_threshold)/max_threshold * 2 * 255;
            cloud.Color(i, 3)=0;        
        elseif distance(i)==0.5
            cloud.Color(i,1)=255;
            cloud.Color(i,2)=255;
            cloud.Color(i,3)=0;
        elseif distance(i)<mid_threshold && distance(i) > lower_threshold
            cloud.Color(i,1)=255-abs((distance(i)-mid_threshold))/(2*lower_threshold)*255;
            cloud.Color(i,2)=255;
            cloud.Color(i,3)=0;
        else
            cloud.Color(i,1)=0;
            cloud.Color(i,2)=255;
            cloud.Color(i,3)=0;
        end
    end
end



