function [pcindividual_ribs, individual_ribs] = seperate_ribs(ribs)    
    % voxel data using the bwskel function
    skel = bwskel(logical(ribs), 'MinBranchLength', 40);
    
    % Find connected components in the skeleton
    conn_comp = bwconncomp(skel);
    
    pcindividual_ribs = {};
    individual_ribs = {};
    
    % Loop through each connected component and extract the line and corresponding voxels
    for i = 1:conn_comp.NumObjects
        % Extract the line from the skeleton
        individual_part = zeros(size(skel));
        individual_part(conn_comp.PixelIdxList{i}) = 1;
        
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
                individual_rib(conn_ribs.PixelIdxList{i}) = 1;
                individual_ribs{end+1} = individual_rib;
                pcindividual_ribs{end+1} = voxel_to_pointcloud(individual_rib);
            end
%             for j=1:length(pcindividual_lines)
%                 if length(pcindividual_ribs) > 0
%                     for k=1:length(pcindividual_ribs)
%                         [idx, dist]=knnsearch(individual_ribs{k}, individual_lines{j});
%                         min_dist = min(dist);
%                         if min_dist < 5
%                             pcindividual_ribs{k} = vertcat(pcindividual_ribs{k}, pcindividual_lines{j});
%                             individual_ribs{k} = individual_ribs{k} + individual_lines{j};
%                         else
%                             pcindividual_ribs{end+1} = pcindividual_lines{j};
%                             individual_ribs{end+1} = individual_lines{j};
%                         end
%                     end
%                 else
%                     pcindividual_ribs{end+1} = pcindividual_lines{j};
%                     individual_ribs{end+1} = individual_lines{j};
%                 end
%             end     
        else
            individual_ribs{end+1} = individual_part;
            pcindividual_ribs{end+1} = voxel_to_pointcloud(individual_part);
        end
    end

    colors = get_colors(length(pcindividual_ribs));
    for i=1:length(pcindividual_ribs)
        pcindividual_ribs{i} = color_pointcloud(pcindividual_ribs{i}, colors(i,:, :));
    end
end