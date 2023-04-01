function [pcindividual_ribs, pcindividual_ribs_centerlines] = seperate_ribs(ribs, pcspinecenterline, pcribs)
    skel = bwskel(logical(ribs), 'MinBranchLength', 40);
    skel=bwskel(skel, 'MinBranchLength', 40);
    
    pcindividual_ribs_centerlines = {};
    num_tries = 0;
    while sum(skel,'all')~=0
        [rows,cols,slices]=ind2sub(size(skel), find(skel));
        pcskel=pointCloud([rows,cols,slices]);
        [index,dist] = dsearchn(pcskel.Location,pcspinecenterline.Location);
        [~,ind]=min(dist);      %find point with minimal distance
        index=index(ind);
        starting_point = pcskel.Location(index(1), :);
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
        line = starting_point;
        for i =1:size(side_points,1)
            EndOfBranch = false;
            line = [line; side_points(i,:)];
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
                    line = [line; next_points(1,:)];
                    length4change=10;
                    if size(line,1)>length4change
                        vec1=line(end-length4change,:)-line(end-length4change/2,:);
                        vec2=line(end-length4change/2,:)-line(end,:);
                        if abs(get_angle(vec1,vec2)) > 60
                            EndOfBranch=true;                                   %end is true as large orientation change happened
                            line=line(1:end-length4change/2,:);     %remove the points after the big change (maybe add them again to skel)
                        end
                    end
                end
            end
            %if i==1
                line = flip(line,1);
            %end
            
            startpoint = line(1,:);
            endpoint = line(end,:);

            %if (abs(endpoint(3)-startpoint(3))) < (abs(endpoint(1)-startpoint(1))) ||  (abs(endpoint(3)-startpoint(3))) < (abs(endpoint(2)-startpoint(2)))
            if size(line,1) > 30 && i==size(side_points,1)
                %make sure the orientation is correct
                if line(1,3)<line(end,3)
                    line=flip(line,1);
                end

                pcindividual_ribs_centerlines{end+1} = pointCloud(line);
            end
            %end
        end
    end
    
    to_remove=[];

    for i=1:length(pcindividual_ribs_centerlines)
        %stitching ribs that are cut in multiple
        for j=1:length(pcindividual_ribs_centerlines)
            if norm(pcindividual_ribs_centerlines{i}.Location(end,:)-pcindividual_ribs_centerlines{j}.Location(1,:))<20
                pcindividual_ribs_centerlines{i}=pcmerge(pcindividual_ribs_centerlines{i},pcindividual_ribs_centerlines{j},1);
                if i~=j
                    to_remove(end+1)=j;
                end
            end
        end
    end
    
    %remove lines which do not start close to the spine
    for i=1:length(pcindividual_ribs_centerlines)
        if (min(abs(pcindividual_ribs_centerlines{i}.Location(1,1)-pcspinecenterline.XLimits)))>150
            to_remove(end+1)=i;
        end
    end
    %remove double entries from to_remove
    to_remove=unique(to_remove);
    pcindividual_ribs_centerlines(to_remove)=[];
    
    colors = get_colors(length(pcindividual_ribs_centerlines));
    for i=1:length(pcindividual_ribs_centerlines)      
        xs = pcindividual_ribs_centerlines{i}.Location(:,1).';
        ys = pcindividual_ribs_centerlines{i}.Location(:,2).';
        zs = pcindividual_ribs_centerlines{i}.Location(:,3).';
        s = zeros(size(xs));
        for j = 2:length(xs)
          s(j) = s(j-1) + sqrt((xs(j)-xs(j-1))^2+(ys(j)-ys(j-1))^2+(zs(j)-zs(j-1))^2);
        end
        px = polyfit(s,xs,8);
        py = polyfit(s,ys,8);
        pz = polyfit(s,zs,8);
        ss = linspace(0,s(end),200);
        x = polyval(px,ss);
        y = polyval(py,ss);
        z = polyval(pz,ss);
        pcindividual_rib_centerline = pointCloud([x(:),y(:),z(:)]);
        pcindividual_ribs_centerlines{i} = color_pointcloud(pcindividual_rib_centerline, colors(i,:, :));
    end
    
    pcindividual_ribs = color_ribs(pcribs, pcindividual_ribs_centerlines);
end


%end