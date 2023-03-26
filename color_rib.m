function colored_rib=color_rib(cloud_rib,cloud_colored_center)
    K=20;
    %cloud_rib.Color=ones(size(cloud_rib.Location)).*255;        
    
    for i=1:size(cloud_colored_center.Location,1)
        [indices,dists]=findNeighborsInRadius(cloud_rib,cloud_colored_center.Location(i,:),K);
        for j=1:size(indices)
            cloud_rib.Color(indices(j),1)=cloud_colored_center.Color(i,1);
            cloud_rib.Color(indices(j),2)=cloud_colored_center.Color(i,2);
            cloud_rib.Color(indices(j),3)=cloud_colored_center.Color(i,3);
        end
    end
    colored_rib=cloud_rib;
end