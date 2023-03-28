function [pcrib_pairs, rib_pairs] = find_rib_pairs(pcindividual_ribs, individual_ribs, pcspinecenterline)
    pcrib_pairs = {};
    rib_pairs = {};
    
    split = {};
    for i = 1:length(individual_ribs)
        [index,dist] = dsearchn(pcindividual_ribs{i}.Location,pcspinecenterline.Location);
        [~,ind]=min(dist);      %find point with minimal distance
        index=index(ind);
        coords = pcindividual_ribs{i}.Location(index(1), :);
        index = findNearestNeighbors(pcspinecenterline, coords, 1);
        closestpointspine = pcspinecenterline.Location(index, :);
        split{end+1, 1}=coords(1);
        split{end, 2}=coords(2);
        split{end, 3}=coords(3);
        split{end, 4}=individual_ribs{i};
        split{end, 5}=pcindividual_ribs{i};
        if coords(1) < closestpointspine(1)
            split{end, 6} = 'left';
        else
            split{end, 6} = 'right';
        end
    end
    split=sortrows(split, 3);
    
    done = [];
    for i = 1:length(split)
        next=0;
        if ~any(ismember(done, i))
            side = split{i, 6};
            done = [done i];
            for j = 1:length(split)
                if~next
                    if ~any(ismember(done, j))
                        if ~strcmp(side, split{j,6})
                            done = [done j];
                            rib_pairs{end+1, 1} = split{i, 4};
                            rib_pairs{end, 2} = split{j, 4};
                            pcrib_pairs{end+1, 1} = split{i, 5};
                            pcrib_pairs{end, 2} = split{j, 5};
                            next=1;
                        end
                    end
                end
            end
        end
    end
    
    colors = get_colors(length(pcrib_pairs));
    for i=1:length(pcrib_pairs)
        pcrib_pairs{i, 1} = color_pointcloud(pcrib_pairs{i,1}, colors(i,:,:));
        pcrib_pairs{i, 2} = color_pointcloud(pcrib_pairs{i,2}, colors(i,:,:));
    end
end