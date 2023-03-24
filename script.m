clear
close all
%read the ribs
L=niftiread('L5g.nii.gz');
R=niftiread('R5.nii.gz');

Corresp_pts=30;
%skeletonize
%make lines from skeleton
left_line=processskel(L);
right_line=processskel(R);

%check if beginning of the rib is at the top, else turn around
if left_line(1,3)<left_line(end,3)
left_line=flip(left_line,1);
end
if right_line(1,3)<right_line(end,3)
right_line=flip(right_line,1);
end

%register one rib
left_registered = round(MyRegistration(right_line,flip(left_line,2)));
%get the remaining distances
[corr_pts_right_line,corr_pts_left_registered] = get_corresp_pts(right_line,left_registered, Corresp_pts);
[distance, derivative] = distances(corr_pts_right_line,corr_pts_left_registered);

%putting Ribs into pointclouds
pc_rib_r=volume2pointcloud(R);
pc_rib_r=pointCloud(pc_rib_r);
pc_rib_r=pcdownsample(pc_rib_r,'random',0.1);

pc_rib_l=volume2pointcloud(L);
pc_rib_l=pointCloud(pc_rib_l);
pc_rib_l=pcdownsample(pc_rib_l,'random',0.1);

%make cloud from rib_line
%cloud1=pointCloud(right_line);


%color the original corresponding points
%colored=cloudviewer(distance,cloud1,Corresp_pts);
[corr_pts_right_line,corr_pts_left_line] = get_corresp_pts(right_line,left_line, Corresp_pts);
colored_r=color_corresp_pts(distance,corr_pts_right_line);
colored_l=color_corresp_pts(distance,corr_pts_left_line);

%color the rib
colored_rib_r=color_rib(pc_rib_r,colored_r);
colored_rib_l=color_rib(pc_rib_l,colored_l);

pcshow(colored_rib_l)
hold on
pcshow(colored_rib_r)

%note: this is not properly working yet, for now it is random which
%endpoint of the rib is taken in which step. Also in the registration the
%ribs are not mirrored which is needed for comparison