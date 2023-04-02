function [pcdeformation_ribs, pcribpairs_centerlines] = calculate_deformity(pc_rib_pairs, pcribs, method, mean_std_threshold, std_threshold)
    switch method
        case "distance"
            dists = [];
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
                    pc_rib_pairs{i,1} = color_pointcloud(pc_rib_pairs{i,1}, [200 200 200]);
                    pc_rib_pairs{i,2} = color_pointcloud(pc_rib_pairs{i,2}, [200 200 200]);
                else
                    pc_rib_pairs{i, 1}=color_corresp_pts(distance,pc1,mean_std_threshold,std_threshold);
                    pc_rib_pairs{i, 2}=color_corresp_pts(distance,pc2,mean_std_threshold,std_threshold);
                end
            end
            pcribpairs_centerlines = pc_rib_pairs;
            pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);

        case "derivative"
            dists = [];
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
                    pc_rib_pairs{i,1} = color_pointcloud(pc_rib_pairs{i,1}, [200 200 200]);
                    pc_rib_pairs{i,2} = color_pointcloud(pc_rib_pairs{i,2}, [200 200 200]);
                else
                    pc_rib_pairs{i, 1}=color_corresp_pts(derivative,pc1,mean_std_threshold,std_threshold);
                    pc_rib_pairs{i, 2}=color_corresp_pts(derivative,pc2,mean_std_threshold,std_threshold);
                end
            end
            pcribpairs_centerlines = pc_rib_pairs;
            pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);

        case "derivative2"
            dists = [];
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
                    pc_rib_pairs{i,1} = color_pointcloud(pc_rib_pairs{i,1}, [200 200 200]);
                    pc_rib_pairs{i,2} = color_pointcloud(pc_rib_pairs{i,2}, [200 200 200]);
                else
                    pc_rib_pairs{i, 1}=color_corresp_pts(derivative2,pc1,mean_std_threshold,std_threshold);
                    pc_rib_pairs{i, 2}=color_corresp_pts(derivative2,pc2,mean_std_threshold,std_threshold);
                end
            end
            pcribpairs_centerlines = pc_rib_pairs;
            pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);
    end
end