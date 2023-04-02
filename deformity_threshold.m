function [pcdeformation_ribs, pcribpairs_centerlines,dists,der,der2] = deformity_threshold(pc_rib_pairs, pcribs)
    dists = [];
    der=[];
    der2=[];
    for i=1:length(pc_rib_pairs)   
        pc1=pc_rib_pairs{i,1}.Location;
        pc2=pc_rib_pairs{i,2}.Location;

        pc1length=get_curve_length(pc1);
        pc2length=get_curve_length(pc2);

        %registration
        pc2registered=registrate_ribs(pc1,pc2);
        
        %Calculate distances
        [distance, derivative, derivative2] = get_distances(pc1,pc2registered);

        %coloring the corresponding points
        if abs(pc1length-pc2length) / pc1length * 100 > 20
            pc_rib_pairs{i,1} = color_pointcloud(pc_rib_pairs{i,1}, [128 128 128]);
            pc_rib_pairs{i,2} = color_pointcloud(pc_rib_pairs{i,2}, [128 128 128]);
        else
            pc_rib_pairs{i, 1}=color_corresp_pts(distance,pc1);
            pc_rib_pairs{i, 2}=color_corresp_pts(distance,pc2);
            dists = [dists distance];
            der=[der derivative];
            der2=[der2 derivative2];

        end

    end
    pcribpairs_centerlines = pc_rib_pairs;
    pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);
end

