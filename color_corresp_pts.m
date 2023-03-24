function cloud=color_corresp_pts(distance,corresp_pts)

%This function tries to color code two ribs based on their differences from
%registration.


maximum=max(distance);

deformation_percentage=distance./maximum;

cloud=pointCloud(corresp_pts);

cloud.Color=uint8(zeros(cloud.Count,3));

cloud.Color(1:end,1)=255;
cloud.Color(1:end,2)=255;
cloud.Color(1:end,3)=255;

    for i=1:size(distance)

        if deformation_percentage(i)<=0.5
        cloud.Color(i,1)=round(deformation_percentage(i)*2*255);
        cloud.Color(i,2)=255;
        cloud.Color(i,3)=0;
        elseif deformation_percentage(i)>0.5
        cloud.Color(i,1)=255;
        cloud.Color(i,2)=round(255-deformation_percentage(i)*255);
        cloud.Color(i,3)=0;
        end
    end

end



