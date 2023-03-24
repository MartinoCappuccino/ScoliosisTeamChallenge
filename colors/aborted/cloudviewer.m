function cloud=rib_to_cloud(distance,ribs,N_pts)

%This function tries to color code two ribs based on their differences from
%registration.


maximum=max(distance);

deformation_percentage=distance./(10*maximum);

cloud=(ribs);

cloud.Color=uint8(zeros(cloud.Count,3));

cloud.Color(1:end,1)=255;
cloud.Color(1:end,2)=255;
cloud.Color(1:end,3)=255;

length_segments=size(ribs.Location,1)/N_pts;

    for i=1:size(distance)-1
        
        %[~,d1,first] = intersect(points1(i,:),ribs,'rows');
        %[~,dn,next] = intersect(points1(i+1,:),ribs,'rows');
        first=round((i-1)*length_segments+round(length_segments/2));
        next=round(i*length_segments+round(length_segments/2));

        if deformation_percentage(i)<=0.5
        cloud.Color(first:next,1)=round(deformation_percentage(i)*2*255);
        cloud.Color(first:next,2)=255;
        cloud.Color(first:next,3)=0;
        elseif deformation_percentage(i)>0.5
        cloud.Color(first:next,1)=255;
        cloud.Color(first:next,2)=round(255-deformation_percentage(i)*255);
        cloud.Color(first:next,3)=0;
        end
    end

end



