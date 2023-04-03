function [pointcloud] = voxel_to_pointcloud(image)
    [x,y,z] = ind2sub(size(image), find(image));
    pointcloud = pointCloud([x(:),y(:),z(:)]);
end

