function [pointcloud] = color_pointcloud(pointcloud, color)
    pointscolor=uint8(zeros(pointcloud.Count,3));
    pointscolor(:,1)=color(1);
    pointscolor(:,2)=color(2);
    pointscolor(:,3)=color(3);
    
    pointcloud.Color=pointscolor;
end