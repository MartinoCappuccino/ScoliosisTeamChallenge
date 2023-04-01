clear all;
close all;

%% Variables
colorribcage = [128, 128, 128];
colorspine = [64, 64, 64];
colorribs = [0, 255, 0];

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/Scoliose/3preop.nii', 5, 3, 1300, colorribcage);

%%
figure;
pcshow(pcribcage);

%% Extract spine and ribs
[pcspinecenterline, pcspine, pcribs, ribs]=seperate_ribcage(ribcage, colorspine, colorribs);

%%
figure; hold on;
pcshow(pcspine);
pcshow(pcribs);
pcshow(pcspinecenterline);
hold off;

%% Extract individual ribs
[pcindividual_ribs, pcindividual_ribs_centerlines]=seperate_ribs(ribs, pcspinecenterline, pcribs);

%%
figure; hold on;
pcshow(pcspine);
pcshow(pcindividual_ribs)
hold off;

figure; hold on;
pcshow(pcspine);
for i=1:length(pcindividual_ribs_centerlines)
    pcshow(pcindividual_ribs_centerlines{i});
end
hold off;

%% Find corresponding ribs
[pcrib_pairs, pcrib_pairs_centerlines] = find_rib_pairs(pcindividual_ribs_centerlines, pcspinecenterline, pcribs);

%%
figure; hold on;
pcshow(pcspine);
pcshow(pcrib_pairs);
hold off;

figure; hold on;
pcshow(pcspine);
for i=1:length(pcrib_pairs_centerlines)
    pcshow(pcrib_pairs_centerlines{i, 1});
    pcshow(pcrib_pairs_centerlines{i, 2});
end
hold off;
%% Registration of ribs and calculation of deformity
[pcdeformation_ribs, pcdeformation_ribs_centerlines] = calculate_deformity(pcrib_pairs_centerlines, pcribs);

%%
figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs);
colorbar;
hold off;

figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines)
    pcshow(pcdeformation_ribs_centerlines{i, 1});
    pcshow(pcdeformation_ribs_centerlines{i, 2});
end
hold off;
