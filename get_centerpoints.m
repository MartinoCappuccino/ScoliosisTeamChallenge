function centerpoints=get_centerpoints(ribcage, radius)
    centerpoints = zeros(size(ribcage));
    for x=1:size(ribcage, 1)
        for y=1:size(ribcage, 2)
            for z=1:size(ribcage, 3)
                amount_of_points = 0;
                total_x=0;
                total_y=0;
                total_z=0;
                if ribcage(x,y,z)==1
                    for xi=-radius:radius
                        for yi=-radius:radius
                            for zi=-radius:radius
                                if (x+xi)<=0 || (x+xi)>size(ribcage, 1)
                                    % do nothing
                                elseif (y+yi)<=0 || (y+yi)>size(ribcage, 2)
                                    % do nothing
                                elseif (z+zi)<=0 || (z+zi)>size(ribcage, 3)
                                    % do nothing
                                elseif (ribcage(x+xi, y+yi, z+zi)==1)
                                    amount_of_points=amount_of_points+1;
                                    total_x = total_x+(x+xi);
                                    total_y = total_y+(y+yi);
                                    total_z = total_z+(z+zi);
                                end
                            end
                        end
                    end
                    if amount_of_points > radius^3/8
                        for xi=-radius:radius
                            for yi=-radius:radius
                                for zi=-radius:radius
                                    if (x+xi)<=0 || (x+xi)>size(ribcage, 1)
                                        % do nothing
                                    elseif (y+yi)<=0 || (y+yi)>size(ribcage, 2)
                                        % do nothing
                                    elseif (z+zi)<=0 || (z+zi)>size(ribcage, 3)
                                        % do nothing
                                    else
                                        ribcage(x+xi, y+yi, z+zi)=0;
                                    end
                                end
                            end
                        end
                        if amount_of_points < radius^3
                            total_x = cast(total_x/amount_of_points, "int16");
                            total_y = cast(total_y/amount_of_points, "int16");
                            total_z = cast(total_z/amount_of_points, "int16");
                            centerpoints(total_x, total_y, total_z) = 1;
                        end
                    end
                end
            end
        end
    end
end