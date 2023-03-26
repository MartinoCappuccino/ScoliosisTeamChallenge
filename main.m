clear all;
close all;

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/Scoliose/1preop.nii', 5, 3, 1350);

%% Extract spine and ribs
[pcspine, spine, pcribs, ribs]=seperate_ribcage(ribcage, [0, 255, 0], [0, 0, 255]);

%% Extract individual ribs
[pcindividual_ribs, individual_ribs]=seperate_ribs(ribs);

%% Registration of ribs and calculation of deformity
rib1=individual_ribs{12};
rib2=individual_ribs{11};
ribcage=bwmorph3(ribcage,'remove');

pcribcage = voxel_to_pointcloud(ribcage, [255, 255, 255]);
pcribcage=color_deformity(rib1,rib2,pcribcage);
figure;
pcshow(pcribcage);

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

