function [pcdeformation_ribs, pcribpairs_centerlines] = calculate_deformity(pc_rib_pairs, pcribs, method, mean_std_threshold, std_threshold)

for i=1:length(pc_rib_pairs)
    pc1=pc_rib_pairs{i,1}.Location;
    pc2=pc_rib_pairs{i,2}.Location;

    pc1length=get_curve_length(pc1);
    pc2length=get_curve_length(pc2);


    %coloring the corresponding points
    if abs(pc1length-pc2length) / pc1length * 100 > 20
        pc_rib_pairs{i,1} = color_pointcloud(pc_rib_pairs{i,1}, [200 200 200]);
        pc_rib_pairs{i,2} = color_pointcloud(pc_rib_pairs{i,2}, [200 200 200]);
    else     %making an equal length                    
        if pc1length<pc2length
            pc2=pc2(1:round(pc1length/pc2length*size(pc2,1)),:);
            xs = pc2(:,1).';
            ys = pc2(:,2).';
            zs = pc2(:,3).';
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
            pc2 = [x(:),y(:),z(:)];
        else
            pc2=pc2(1:round(pc2length/pc1length*size(pc1,1)),:);
            xs = pc2(:,1).';
            ys = pc2(:,2).';
            zs = pc2(:,3).';
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
            pc2 = [x(:),y(:),z(:)];
        end
        pc2_mirrored=pc2.*[-1 1 1];
        %registration
        pc2registered=registrate_ribs(pc1,pc2_mirrored);

        %Calculate distances
        [distance, derivative, derivative2] = get_distances(pc1,pc2registered);
        switch method
            case "distance"
                pc_rib_pairs{i, 1}=color_corresp_pts(distance,pc1,mean_std_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(distance,pc2,mean_std_threshold,std_threshold);
            case "derivative"
                pc_rib_pairs{i, 1}=color_corresp_pts(derivative,pc1,mean_std_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(derivative,pc2,mean_std_threshold,std_threshold);
            case "derivative2"
                pc_rib_pairs{i, 1}=color_corresp_pts(derivative2,pc1,mean_std_threshold,std_threshold);
                pc_rib_pairs{i, 2}=color_corresp_pts(derivative2,pc2,mean_std_threshold,std_threshold);
        end
    end
    pcribpairs_centerlines = pc_rib_pairs;
    pcdeformation_ribs = color_ribs(pcribs, pcribpairs_centerlines);

end