function [colored_ribs]=color_ribs(pcribs, pcindividual_ribs_centerlines)  
    colored_ribs = pcribs;
    for i=1:length(pcindividual_ribs_centerlines)
        if size(pcindividual_ribs_centerlines, 2) == 2
            for k=1:size(pcindividual_ribs_centerlines, 2)
                xs = pcindividual_ribs_centerlines{i, k}.Location(:,1).';
                ys = pcindividual_ribs_centerlines{i, k}.Location(:,2).';
                zs = pcindividual_ribs_centerlines{i, k}.Location(:,3).';
                color_xs = double(pcindividual_ribs_centerlines{i, k}.Color(:,1).');
                color_ys = double(pcindividual_ribs_centerlines{i, k}.Color(:,2).');
                color_zs = double(pcindividual_ribs_centerlines{i, k}.Color(:,3).');
        
                x_new = interp1(1:length(xs), xs, linspace(1, length(xs), 50), 'linear');
                y_new = interp1(1:length(ys), ys, linspace(1, length(ys), 50), 'linear');
                z_new = interp1(1:length(zs), zs, linspace(1, length(zs), 50), 'linear');
                color_x_new = interp1(1:length(color_xs), color_xs, linspace(1, length(color_xs), 50), 'linear');
                color_y_new = interp1(1:length(color_ys), color_ys, linspace(1, length(color_ys), 50), 'linear');
                color_z_new = interp1(1:length(color_zs), color_zs, linspace(1, length(color_zs), 50), 'linear');
                pcindividual_ribs_centerlines{i, k} = pointCloud([x_new(:), y_new(:), z_new(:)], 'Color', uint8([color_x_new(:), color_y_new(:), color_z_new(:)]));
            end
        
        else
            xs = pcindividual_ribs_centerlines{i}.Location(:,1).';
            ys = pcindividual_ribs_centerlines{i}.Location(:,2).';
            zs = pcindividual_ribs_centerlines{i}.Location(:,3).';
            color_xs = double(pcindividual_ribs_centerlines{i}.Color(:,1).');
            color_ys = double(pcindividual_ribs_centerlines{i}.Color(:,2).');
            color_zs = double(pcindividual_ribs_centerlines{i}.Color(:,3).');
    
            x_new = interp1(1:length(xs), xs, linspace(1, length(xs), 50), 'linear');
            y_new = interp1(1:length(ys), ys, linspace(1, length(ys), 50), 'linear');
            z_new = interp1(1:length(zs), zs, linspace(1, length(zs), 50), 'linear');
            color_x_new = interp1(1:length(color_xs), color_xs, linspace(1, length(color_xs), 50), 'linear');
            color_y_new = interp1(1:length(color_ys), color_ys, linspace(1, length(color_ys), 50), 'linear');
            color_z_new = interp1(1:length(color_zs), color_zs, linspace(1, length(color_zs), 50), 'linear');
            pcindividual_ribs_centerlines{i} = pointCloud([x_new(:), y_new(:), z_new(:)], 'Color', uint8([color_x_new(:), color_y_new(:), color_z_new(:)]));
        end
    end

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