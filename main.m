clear all;
close all;

%% Variables
colorribcage = [255, 0, 0];
colorspine = [0, 255, 0];
colorribs = [0, 0, 255];

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/Scoliose/1preop.nii', 5, 3, 1350, colorribcage);

%% Extract spine and ribs
[pcspine, spine, pcspinecenterline, pcribs, ribs]=seperate_ribcage(ribcage, colorspine, colorribs);

%% Extract individual ribs
[pcindividual_ribs, individual_ribs]=seperate_ribs_2(ribs);

%% Find corresponding ribs
[pcrib_pairs, rib_pairs] = find_rib_pairs(pcindividual_ribs, individual_ribs, pcspinecenterline);

%% Registration of ribs and calculation of deformity
rib1=individual_ribs{12};
rib2=individual_ribs{11};
ribcage=bwmorph3(ribcage,'remove');

pcribcage = voxel_to_pointcloud(ribcage);
pcribcage.Color=ones(size(pcribcage.Location)).*255;
pcribcage = color_deformity(rib1,rib2,pcribcage);
figure;
pcshow(pcribcage);

%% PLOT pointclouds
figure; hold on;
%pcshow(pcribs)
pcshow(pcspinecenterline)
pcshow(pcribs)
%pcshow(pcribcage)
for i = 1:length(pcrib_pairs)
    pcshow(pcrib_pairs{i, 1})
    pcshow(pcrib_pairs{i, 2})
end
set(gcf,'color','w');
set(gca,'color','w');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('Spine', 'Ribs', 'Ribcage');

