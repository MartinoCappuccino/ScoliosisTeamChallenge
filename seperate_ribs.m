function [pcindividual_ribs] = seperate_ribs(ribs, pcspinecenterline)
    skel = bwskel(logical(ribs), 'MinBranchLength', 40);

    pcindividual_ribs = {};
    
    num_tries = 0;
    while sum(skel,'all')~=0
        [rows, cols, slices] = ind2sub(size(skel), find(skel));
        index = randi(length(rows),1);
        starting_point = [rows(index), cols(index), slices(index)];
        skel(starting_point(1), starting_point(2), starting_point(3)) = 0;
        
        side_points = [];
        for x =-1:1 
            for y=-1:1
                for z=-1:1
                    if skel(starting_point(1)+x, starting_point(2)+y, starting_point(3)+z) == 1
                        side_points(end+1, :) = [starting_point(1)+x, starting_point(2)+y, starting_point(3)+z];
                    end
                end
            end
        end
        
        % remove sidepoints
        for i = 1:size(side_points,1)
            skel(side_points(i,1), side_points(i,2), side_points(i,3)) = 0;
        end

        if size(side_points, 1) > 2
            num_tries = num_tries + 1;
            skel(starting_point(1), starting_point(2), starting_point(3)) = 1;
            for i = 1:size(side_points,1)
                skel(side_points(i,1), side_points(i,2), side_points(i,3)) = 1;
            end
            if num_tries > 2
                break
            else
                continue
            end
        else
            num_tries = 0;
        end

        % start a new line
        line = pointCloud(starting_point);
        for i =1:size(side_points,1)
            EndOfBranch = false;
            line = pcmerge(line, pointCloud(side_points(i,:)),1);
            curr_point = side_points(i,:);
            while EndOfBranch~=true
                next_points = [];
                for x =-1:1 
                    for y=-1:1
                        for z=-1:1
                            if skel(curr_point(1)+x, curr_point(2)+y, curr_point(3)+z) == 1
                                next_points(end+1, :) = [curr_point(1)+x, curr_point(2)+y, curr_point(3)+z];
                            end
                        end
                    end
                end
                
                if size(next_points,1) > 1                                      %Branchpoint
                    EndOfBranch=true;
                elseif size(next_points, 1)==0                                    %end of line in this direction 
                    EndOfBranch=true;                   
                else                                                            %continue as line has only one next point
                    curr_point = next_points(1,:);
                    skel(next_points(1,1), next_points(1,2), next_points(1,3)) = 0;
                    line = pcmerge(line, pointCloud(next_points(1,:)),1);
                    if length(line.Location)>30
                        vec1=line.Location(end-30,:)-line.Location(end-15,:);
                        vec2=line.Location(end-15,:)-line.Location(end,:);
                        if abs(rad2deg(atan2(norm(cross(vec1, vec2)), dot(vec1, vec2)))) > 60
                            disp(abs(rad2deg(atan2(norm(cross(vec1, vec2)), dot(vec1, vec2)))))
                            EndOfBranch=true;                                   %end is true as large orientation change happened
                        end
                    end
                end
            end
            if i==1
                locations = line.Location;
                locations = flip(locations,1);
                line = pointCloud(locations);
            end
        end
    
        startpoint = line.Location(1,:);
        endpoint = line.Location(end,:);
        if (abs(endpoint(3)-startpoint(3))) < (abs(endpoint(1)-startpoint(1))) ||  (abs(endpoint(3)-startpoint(3))) < (abs(endpoint(2)-startpoint(2)))
            if length(line.Location) > 10
                pcindividual_ribs{end+1} = line;
            end
        end
    end

    colors = get_colors(length(pcindividual_ribs));
    for i=1:length(pcindividual_ribs)
%         
%         [index,dist] = dsearchn(pcindividual_ribs{i}.Location,pcspinecenterline.Location);
%         [~,ind]=min(dist);
%         index=index(ind);
%         coords = pcindividual_ribs{i}.Location(index(1), :);
%         index = findNearestNeighbors(pcspinecenterline, coords, 1);
%         closestpointspine = pcspinecenterline.Location(index, :);
%         pcindividual_ribs{i} = pcmerge(pointCloud(closestpointspine), pcindividual_ribs{i}, 1);
% 
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
%         ss = linspace(0,s(end),100);
%         x = polyval(px,ss);
%         y = polyval(py,ss);
%         z = polyval(pz,ss);
%         pcindividual_rib = pointCloud([x(:),y(:),z(:)]);
        pcindividual_ribs{i} = color_pointcloud(pcindividual_ribs{i}, colors(i,:, :));
    end

%end