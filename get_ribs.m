function ribs=get_ribs(centerpoints)
    ribs = zeros(size(centerpoints));
    
    rib_number = 2;
    spine = 1;
    for x=1:size(centerpoints,1)
        for y=1:size(centerpoints,2)
            for z=1:size(centerpoints,3)
                if centerpoints(x,y,z)==1
                    total_x=0;
                    total_y=0;
                    total_z=0;
                    for xi=-10:10
                        for yi=-10:10
                            for zi=-10:10
                                if (x+xi)<=0 || (x+xi)>size(centerpoints, 1)
                                    % do nothing
                                elseif (y+yi)<=0 || (y+yi)>size(centerpoints, 2)
                                    % do nothing
                                elseif (z+zi)<=0 || (z+zi)>size(centerpoints, 3)
                                    % do nothing
                                elseif centerpoints(x+xi, y+yi, z+zi) == 1
                                    total_x = total_x+xi;
                                    total_y = total_y+yi;
                                    total_z = total_z+zi;
                                end
                            end
                        end
                    end
                    if total_z > ((total_x+total_y)/2)
                        ribs(x,y,z) = spine;
                    else
                        ribs(x,y,z) = rib_number;
                    end
                end
            end
        end
                    
    end
end
