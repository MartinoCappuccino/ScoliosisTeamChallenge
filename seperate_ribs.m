function [pcindividual_ribs, individual_ribs] = seperate_ribs(ribs, pcspinecenterline)    
    % voxel data using the bwskel function
    skel = bwskel(logical(ribs), 'MinBranchLength', 40);
    
    % Find connected components in the skeleton
    conn_comp = bwconncomp(skel);
    
    pcindividual_ribs = {};
    individual_ribs = {};
    
    % Loop through each connected component and extract the line and corresponding voxels
    for i = 1:conn_comp.NumObjects
        % Extract the line from the skeleton
        individual_part = false(size(skel));
        individual_part(conn_comp.PixelIdxList{i}) = true;
        
        branchpoints = bwmorph3(individual_part, 'branchpoints');
        disconnected_lines = individual_part - branchpoints;

        lines = bwconncomp(disconnected_lines);
        if lines.NumObjects > 1   
            individual_lines = false(size(skel));
            for j = 1:lines.NumObjects
                % Extract the line from the skeleton
                individual_line = false(size(disconnected_lines));
                individual_line(lines.PixelIdxList{j}) = true;
                startendpoints = bwmorph3(individual_line, 'endpoints');
                [x,y,z] = ind2sub(size(startendpoints), find(startendpoints));
                if length(z) >= 2
                    if (abs(z(1)-z(2))) < (abs(x(1)-x(2))) || (abs(z(1)-z(2))) < (abs(y(1)-y(2)))
                        individual_lines = individual_lines + individual_line;
                    end
                end
            end
            individual_lines = individual_lines + branchpoints;
            conn_ribs = bwconncomp(individual_lines);
            for j = 1:conn_ribs.NumObjects
                individual_rib = zeros(size(skel));
                individual_rib(conn_ribs.PixelIdxList{j}) = 1;
                pcindividual_ribs{end+1} = voxel_to_pointcloud(individual_rib);
            end    
        else
        pcindividual_ribs{i} = voxel_to_pointcloud(individual_part);
        end
    end

    colors = get_colors(length(pcindividual_ribs));
    for i=1:length(pcindividual_ribs)
%         index = knnsearch(pcspinecenterline.Location, pcindividual_ribs{i}.Location, 'k', 1);
%         closestpointspine = pcspinecenterline.Location(index(1), :);
%         pcindividual_ribs{i} = pcmerge(pointCloud(closestpointspine), pcindividual_ribs{i}, 1);
%         xs = pcindividual_ribs{i}.Location(:,1);
%         ys = pcindividual_ribs{i}.Location(:,2);
%         zs = pcindividual_ribs{i}.Location(:,3);
%         s = zeros(size(xs));
%         for j = 2:length(xs)
%           s(i) = s(j-1) + sqrt((xs(j)-xs(j-1))^2+(ys(j)-ys(j-1))^2+(zs(j)-zs(j-1))^2);
%         end
%         px = polyfit(s,xs,8);
%         py = polyfit(s,ys,8);
%         pz = polyfit(s,zs,8);
%         ss = linspace(0,s(end),200);
%         x = polyval(px,ss);
%         y = polyval(py,ss);
%         z = polyval(pz,ss);
%         pcindividual_rib = pointCloud([x(:),y(:),z(:)]);
        pcindividual_ribs{i} = color_pointcloud(pcindividual_ribs{i}, colors(i,:, :));
        individual_rib = zeros(size(skel));
        for j=1:length(pcindividual_rib{i}.Location)
            individual_rib(pcindividual_rib.Location(j,2), pcindividual_rib.Location(j,1), pcindividual_rib.Location(j,3)) = 1;
        end
        individual_ribs{i} = individual_rib;
    end
end