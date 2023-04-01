function [colored_ribs]=color_ribs(pcribs, pcindividual_ribs_centerlines)  
    colored_ribs = pcribs;
    
    pcall_individual_ribs_centerlines = pointCloud([0 0 0], 'Color', [255 255 255]);
    for i=1:length(pcindividual_ribs_centerlines)
        if size(pcindividual_ribs_centerlines, 2) == 2
            pcall_individual_ribs_centerlines = pcmerge(pcall_individual_ribs_centerlines, pcindividual_ribs_centerlines{i, 1}, 1);
            pcall_individual_ribs_centerlines = pcmerge(pcall_individual_ribs_centerlines, pcindividual_ribs_centerlines{i, 2}, 1);
        else
            pcall_individual_ribs_centerlines = pcmerge(pcall_individual_ribs_centerlines, pcindividual_ribs_centerlines{i}, 1);
        end
    end
    pcall_individual_ribs_centerlines = pointCloud(pcall_individual_ribs_centerlines.Location(1:end, :), 'Color', pcall_individual_ribs_centerlines.Color(1:end, :));

    [indices, dists] = dsearchn(pcall_individual_ribs_centerlines.Location, colored_ribs.Location);
    for i = 1:length(indices)
        if dists(i) < 20
            colored_ribs.Color(i,:) = pcall_individual_ribs_centerlines.Color(indices(i), :);
        else
            colored_ribs.Color(i,:) = [255, 255, 255];
        end
    end

    colors = colored_ribs.Color;
    isNotWhite = any(colors~=[255,255,255], 2);

    colored_ribs = pointCloud(colored_ribs.Location(isNotWhite, :), 'Color', colored_ribs.Color(isNotWhite, :));
end