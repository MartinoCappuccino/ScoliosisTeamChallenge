function [lines] = find_lines(skel)
    visited = [];
    starting_point = [];
    side_points=[];


    invidividual_ribs = {};
    pcindividual_ribs = {};
    
    pick a random starting point
    
    while sum(skel,'all')~=0            %as long as there are points in skel             
        side_points = []
        for x =-1:1
            for y = -1:1
                for z = -1:1
                    if skel(starting_point(1)+x, starting_point(1)+y,starting_point(1)+z) == 1
                        side_points(end+1,:)=[starting_point(1)+x, starting_point(1)+y,starting_point(1)+z];
                        %side_points append, always gonna be two points.
                    end
                end
            end
        end
    
        if length(side_points,1) == 1
            break
            %pick different starting_point           
        else
            %remove starting point from skel
            %add it to a new line
            visited=starting_point;
            for i =1:length(side_points)
                endOfLine = false;
                curr_point = side_points(i);
                while endOfLine~=true
                    next_points = [];
                    for x =-1:1
                        for y = -1:1
                            for z = -1:1
                                if skel(curr_point(1)+x, curr_point(1)+y,curr_point(1)+z) == 1
                                    next_points(end+1,:)=[starting_point(1)+x, starting_point(1)+y,starting_point(1)+z];       % append with found point
    
                                end
                            end
                        end
                    end
                    if length(next_points) > 1
                        endOfLine=true;             %Branchpoint
                    elseif length(next_points) == 0
                         endOfLine=true;         %end of line in this direction   
                    else
                        visited(end+1,:)=next_points;
                        skel(next_points(1),next_points(2),next_points(3))=0;       %remove point from skel
                        %continue as line has only one next point
                        if length(visited,1)>5
                            vec1=visited(end-5,:)-visited(end-3,:);
                            vec2=visited(end-3,:)-visited(end,:);
                            if abs(get_angle(vec1,vec2))>45                 %check for 3 points back and 5 points back if the orientation is roughly the same
                                endOfLine=true;                             %end is true as large orientation change happens
                            end
                        end
                    end
                end
                visited=flip(visited,1);       %flip the line around to add points again from the point started
            end
        end
        
        if visited does not have 5 points put it back in skel
        if amount of lines does not change also stop algorithm
        
    xdim=(max(visited(:,1))-min(visited(:,1)));
    ydim=(max(visited(:,2))-min(visited(:,2)));
    zdim=(max(visited(:,3))-min(visited(:,3)));
    if (zdim<ydim) && (zdim<xdim)
        pcindividual_ribs{end+1}=visited;                   %only ouptut into individual ribs if line moves more in xy than in z
    end
        

end