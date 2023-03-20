function [pointcloud] = voxel_to_pointcloud(image, color)
    [x,y,z] = ind2sub(size(image), find(image));
    pointcloud = pointCloud([x(:),y(:),z(:)]);
    
    pointscolor=uint8(zeros(pointcloud.Count,3));
    pointscolor(:,1)=color(1);
    pointscolor(:,2)=color(2);
    pointscolor(:,3)=color(3);
    
    pointcloud.Color=pointscolor;
end

