function image = pointcloud_to_voxel(pointcloud)
    voxelsize=[0.5195 0.5195 0.6000];
    xyz = pointcloud.Location;
    for i=1:3
        tmp=xyz(:,i);
        edges=min(tmp):voxelsize(i):max(tmp)+voxelsize(i);
        xyz(:,i)=discretize(tmp, edges);
    end
    image=int16(accumarray(xyz,1)>0);
end