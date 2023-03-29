function [colored_pcribcage] = color_deformity(pc_rib_pairs, ribcage)

    ribcage=bwmorph3(ribcage,'remove');
    pcribcage = voxel_to_pointcloud(ribcage);
    pcribcage.Color=ones(size(pcribcage.Location)).*255;

    %pc1=order_pc(rib1_vol_line);
    %pc2=order_pc(rib2_vol_line);
    for i=1:length(pc_rib_pairs)
    
        pc1=pc_rib_pairs{i,1}.Location;
        pc2=pc_rib_pairs{i,2}.Location;

        if pc1(1,3)<pc1(end,3)
            pc1=flip(pc1,1);
        end
        if pc2(1,3)<pc2(end,3)
            pc2=flip(pc2,1);
        end
    
        %registration
        registered=registrate_ribs(pc1,pc2);
        %calulating the differences
        [corr_pts_1,corr_pts_2] = get_corresp_pts(pc1,registered, 20);
        [distance, derivative] = distances(corr_pts_1,corr_pts_2);
        %coloring the corresponding points
        [corr_pts_1,corr_pts_2] = get_corresp_pts(pc1,pc2, 20);
        colored_r=color_corresp_pts(distance,corr_pts_1);
        colored_l=color_corresp_pts(distance,corr_pts_2);
    
        %color the rib
        colored_pcribcage=color_rib(pcribcage,colored_r);
        colored_pcribcage=color_rib(colored_pcribcage,colored_l);
    end
end