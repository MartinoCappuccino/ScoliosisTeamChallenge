function cloud=color_corresp_pts(distance,corresp_pts)
    %This function tries to color code two ribs based on their differences from
    %registration.
    
    maximum=max(distance);
    minimum=min(distance);
        
    cloud=pointCloud(corresp_pts);
    
    cloud.Color=uint8(zeros(cloud.Count,3));
    
    for i=1:size(distance)
        if distance(i)<0.5
            cloud.Color(i,1)=round(distance(i)/maximum*2*128);
            cloud.Color(i,2)=128;
            cloud.Color(i,3)=0;
        elseif distance(i)>0.5
            cloud.Color(i,1)=255;
            cloud.Color(i,2)=round(128-minimum/distance(i)*128);
            cloud.Color(i,3)=0;
        elseif distance(i)==0.5
            cloud.Color(i,1)=255;
            cloud.Color(i,2)=round(255/2);
            cloud.Color(i,3)=0;
        end
    end
end



