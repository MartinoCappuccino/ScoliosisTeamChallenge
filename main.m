clear all;
close all;

%% Read image
image=niftiread('D:\coding_UU\TeamChallange\Scoliose\1preop.nii');
image=imresize3(image, [512, 512, 437]);
[pcribcage, ribcage]=get_ribcage(image, 5, 3, 1350);
clear image;

%% Extract spine and ribs
[pcspine, spine, pcribs, ribs, mask]=seperate_ribcage(ribcage, [0, 255, 0], [0, 0, 255]);

%% Extract individual ribs
colors = get_colors(40).*255;
[pcindividual_ribs, individual_ribs]=seperate_ribs(ribs, colors);

%% Registration of ribs and calculation of deformity
rib1=individual_ribs{12};
rib2=individual_ribs{11};
ribcage=bwmorph3(ribcage,'remove');

pcribcage = voxel_to_pointcloud(ribcage, [255, 255, 255]);
pcribcage=color_deformity(rib1,rib2,pcribcage);
figure;
pcshow(pcribcage);

%% PLOT
volshow(ribcage)
volshow(ribs)
volshow(spine)
%% PLOT pointclouds
figure; hold on;
%pcshow(pcribs)
pcshow(pcspine)
%pcshow(pcribcage)
for i = 1:length(pcindividual_ribs)
    pcshow(pcindividual_ribs{i})
end
set(gcf,'color','w');
set(gca,'color','w');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('Spine', 'Ribs', 'Ribcage');

%% SHOW BRANCHPOINTS
branchpoints = bwmorph3(individual_ribs{6}, 'branchpoints');
branchpoints = imdilate(branchpoints, ones(5,5,5));
volshow(individual_ribs{6}+branchpoints);
