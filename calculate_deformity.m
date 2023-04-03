function [pcdeformation_ribs, pcribpairs_centerlines, dists, der, der2] = calculate_deformity(pc_rib_pairs, pcribs, method, mean_threshold, std_threshold)
    dists = [];
    der=[];
    der2=[];
    for i=1:length(pc_rib_pairs)
        pc1=pc_rib_pairs{i,1}.Location;
        pc2=pc_rib_pairs{i,2}.Location;
    
        pc1length=get_curve_length(pc1);
        pc2length=get_curve_length(pc2);
                      
        if pc1length<pc2length
            pc2=pc2(1:round(pc1length/pc2length*size(pc2,1)),:);
            xs = pc2(:,1).';
            ys = pc2(:,2).';
            zs = pc2(:,3).';
    
            % Create new line with 200 points
            x_new = interp1(1:length(xs), xs, linspace(1, length(xs), 200), 'linear');
            y_new = interp1(1:length(ys), ys, linspace(1, length(ys), 200), 'linear');
            z_new = interp1(1:length(zs), zs, linspace(1, length(zs), 200), 'linear');
            
            pc2 = [x_new(:),y_new(:),z_new(:)];
        else
            pc1=pc1(1:round(pc2length/pc1length*size(pc1,1)),:);
            xs = pc1(:,1).';
            ys = pc1(:,2).';
            zs = pc1(:,3).';
    
            % Create new line with 200 points
            x_new = interp1(1:length(xs), xs, linspace(1, length(xs), 200), 'linear');
            y_new = interp1(1:length(ys), ys, linspace(1, length(ys), 200), 'linear');
            z_new = interp1(1:length(zs), zs, linspace(1, length(zs), 200), 'linear');
            
            pc1 = [x_new(:),y_new(:),z_new(:)];
        end
        pc2_mirrored=pc2.*[-1 1 1];
        %registration
        pc2registered=registrate_ribs(pc1,pc2_mirrored);
    
        %Calculate distances
        [distance, derivative, derivative2] = get_distances(pc1,pc2registered);
        switch method
            case "distance"
                pc_rib_pairs{i, 1}=color_corresp_pts(distance,pc1,mean_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(distance,pc2,mean_threshold,std_threshold);
            case "derivative"
                pc_rib_pairs{i, 1}=color_corresp_pts(derivative,pc1,mean_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(derivative,pc2,mean_threshold,std_threshold);
            case "derivative2"
                pc_rib_pairs{i, 1}=color_corresp_pts(derivative2,pc1,mean_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(derivative2,pc2,mean_threshold,std_threshold);
        end
        dists = [dists distance];
        der=[der derivative];
        der2=[der2 derivative2];
        pcribpairs_centerlines = pc_rib_pairs;
        pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);
    end
end