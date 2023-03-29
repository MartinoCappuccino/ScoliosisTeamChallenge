clear all;
close all;

%% Variables
colorribcage = [255, 255, 255];
colorspine = [0, 255, 0];
colorribs = [0, 0, 255];

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/Scoliose/1preop.nii', 5, 3, 1300, colorribcage);

%% Extract spine and ribs
[pcspinecenterline, pcspine, pcribs, ribs]=seperate_ribcage(ribcage, colorspine, colorribs);

%% Extract individual ribs
[pcindividual_ribs]=seperate_ribs(ribs, pcspinecenterline);

%% Find corresponding ribs
[pcrib_pairs] = find_rib_pairs(pcindividual_ribs, pcspinecenterline);

%% Registration of ribs and calculation of deformity
pcdeformation_ribcage = color_deformity(pcrib_pairs, ribcage);


%%
figure; hold on;
for i =1:length(pcindividual_ribs)
    pcshow(pcindividual_ribs{i});
end
set(gcf,'color','w');
set(gca,'color','w');
hold off;

%%
figure; hold on;
for i = 1:length(pcrib_pairs)
    pcshow(pcrib_pairs{i,1});
    pcshow(pcrib_pairs{i,2});
end
hold off