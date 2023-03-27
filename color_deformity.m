function [colored_pcribcage] = color_deformity(rib1_vol_line,rib2_vol_line,pcribcage)
    pc1=order_pc(rib1_vol_line);
    pc2=order_pc(rib2_vol_line);
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