%read the ribs
L=niftiread('L5g.nii.gz');
R=niftiread('R5.nii.gz');

Corresp_pts=20;
%skeletonize
%make lines from skeleton
left_line=processskel(L);
right_line=processskel(R);

%register one rib
left_registered = round(MyRegistration(right_line,left_line));
%get the remaining distances
[corr_pts_right_line,corr_pts_left_registered] = get_corresp_pts(right_line,left_registered, Corresp_pts);
[distance, derivative] = distances(corr_pts_right_line,corr_pts_left_registered);


pc_rib=volume2pointcloud(L);
pc_rib=pointCloud(pc_rib);
pc_rib=pcdownsample(pc_rib,'random',0.1);

%make cloud from rib_line
cloud1=pointCloud(left_line);

%color the rib
colored=cloudviewer(distance,cloud1,Corresp_pts);

%color the rib
colored_rib=color_rib(pc_rib,cloud1);

%note: this is not properly working yet, for now it is random which
%endpoint of the rib is taken in which step. Also in the registration the
%ribs are not mirrored which is needed for comparison