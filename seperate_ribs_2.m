function [pcindividual_ribs, individual_ribs] = seperate_ribs(ribs)    
    % voxel data using the bwskel function
    skel = bwskel(logical(ribs), 'MinBranchLength', 40);
    
    % Find connected components in the skeleton
    conn_comp = bwconncomp(skel);
    
    % Initialize variables to hold the lines and corresponding voxels
    individual_ribs = cell(1,conn_comp.NumObjects);
    pcindividual_ribs = cell(1,conn_comp.NumObjects);
   
    colors = get_colors(conn_comp.NumObjects);
    
    % Loop through each connected component and extract the line and corresponding voxels
    for i = 1:conn_comp.NumObjects
        % Extract the line from the skeleton
        individual_rib = false(size(skel));
        individual_rib(conn_comp.PixelIdxList{i}) = true;

        individual_ribs{i} = individual_rib;
    
        % Extract the corresponding voxels
        pcindividual_rib = color_pointcloud(voxel_to_pointcloud(individual_rib), colors(i,:,:));

        pcindividual_ribs{i} = pcindividual_rib;
    end

%     output_data = cell(1, conn_comp.NumObjects);
%     for i = 1:conn_comp.NumObjects
%         % Extract the linear indices of the points in the line
%         line_idx = conn_comp.PixelIdxList{i};
%         
%         % Convert the linear indices to subscripts (i.e., x,y,z coordinates)
%         [x,y,z] = ind2sub(size(skel), line_idx);
%         
%         % Extract the voxel data and point cloud data for the line
%         voxel_data = nii.img(min(x):max(x), min(y):max(y), min(z):max(z));
%         point_cloud = [x(:), y(:), z(:)];
%         
%         % Check for discontinuities in the z direction and split the line accordingly
%         dz = diff(diff(point_cloud(:,3)));
%         split_idx = find(dz > 1) + 1;
%         if isempty(split_idx)
%             % The line is continuous in the z direction
%             output_data{i} = {voxel_data, point_cloud};
%         else
%             % The line is not continuous in the z direction, split it into segments
%             split_idx = [1; split_idx; size(point_cloud,1)];
%             for j = 1:length(split_idx)-1
%                 segment_idx = split_idx(j):split_idx(j+1)-1;
%                 segment_voxel_data = nii.img(min(x(segment_idx)):max(x(segment_idx)), ...
%                                               min(y(segment_idx)):max(y(segment_idx)), ...
%                                               min(z(segment_idx)):max(z(segment_idx)));
%                 segment_point_cloud = point_cloud(segment_idx,:);
%                 output_data{end+1} = {segment_voxel_data, segment_point_cloud};
%             end
%         end
%     end

end



