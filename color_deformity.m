function [colored_pcribcage] = color_deformity(rib1_vol_line,rib2_vol_line,pcribcage)
pc1=order_pc(rib1_vol_line);
pc2=order_pc(rib2_vol_line);
%registration 
registered=MyRegistration(pc1,pc2);
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

function ordered_pc=order_pc(vol)
%make a orderes pointcloud out of the volume
idx = find(bwmorph3(vol,'endpoints'));
[row,col,pag] = ind2sub(size(vol),idx);
vol=int8(vol);
vol(row(1),col(1),pag(1))=2;
vol(row(2),col(2),pag(2))=2;
ordered_pc=volume2line(vol);
%check thet the start poitn is the top point
if ordered_pc(1,3)<ordered_pc(end,3)
ordered_pc=flip(ordered_pc,1);
end
if ordered_pc(1,3)<ordered_pc(end,3)
ordered_pc=flip(ordered_pc,1);
end


end