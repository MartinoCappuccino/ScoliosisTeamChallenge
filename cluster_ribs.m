function labels = cluster_ribs(pcribs, radius)
    % Load your point cloud into a variable called "pcribs"
    % "pcribs" should be a pointCloud object with X, Y, and Z properties
    
    % Create a variable to hold the labels for each point
    labels = zeros(pcribs.Count, 1);
    
    % Initialize a label counter
    label_counter = 0;
    
    % Loop over all points
    for i = 1:pcribs.Count
        % Check if this point has already been labeled
        if labels(i) ~= 0
            continue; % skip to the next point if this one already has a label
        end
        
        % Get the neighboring points within the radius
        indices = findNeighborsInRadius(pcribs, pcribs.Location(i,:), radius);
        neighbors = false(ptCloud.Count,1);
        neighbors(indices) = true;
        
        % Check if there are any labeled points within the radius
        labeled_neighbors = neighbors & labels ~= 0;
        
        % Check if there are any labeled points within the radius
        if any(labeled_neighbors)
            % Assign the most prevalent label to all points within the radius
            neighbor_labels = labels(labeled_neighbors);
            unique_labels = unique(neighbor_labels);
            counts = histc(neighbor_labels, unique_labels);
            [~, max_idx] = max(counts);
            labels(neighbors) = unique_labels(max_idx);
            
            % Update the label of this point if necessary
            if labels(i) ~= unique_labels(max_idx)
                labels(i) = unique_labels(max_idx);
            end
        else
            % Assign a new label to all points within the radius
            label_counter = label_counter + 1;
            labels(neighbors) = label_counter;
        end
    end
end