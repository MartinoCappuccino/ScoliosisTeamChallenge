function [pcdeformation_ribs, pcribpairs_centerlines] = calculate_deformity(pc_rib_pairs, pcribs)
    
    for i=1:length(pc_rib_pairs)   
        pc1=pc_rib_pairs{i,1}.Location;
        pc2=pc_rib_pairs{i,2}.Location;

        pc1length=get_curve_length(pc1);
        pc2length=get_curve_length(pc2);

        %registration
        pc2registered=registrate_ribs(pc1,pc2);
        
        %Calculate distances
        [distance, derivative] = get_distances(pc1,pc2registered);
        
        %coloring the corresponding points
        if abs(pc1length-pc2length) / pc1length * 100 > 10
            pc_rib_pairs{i, 1}.Color=ones(pc_rib_pairs{i, 1}.Count, 3).*128;
            pc_rib_pairs{i, 2}.Color=ones(pc_rib_pairs{i, 2}.Count, 3).*128;
        else
            pc_rib_pairs{i, 1}=color_corresp_pts(distance,pc1);
            pc_rib_pairs{i, 2}=color_corresp_pts(distance,pc2);
        end
    end
    pcribpairs_centerlines = pc_rib_pairs;
    pcdeformation_ribs = color_ribs(pcribs, pc_rib_pairs);
end