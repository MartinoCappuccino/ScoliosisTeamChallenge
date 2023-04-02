clear all;
close all;

%% Variables
colorribcage = [255, 255, 255];
colorspine = [255, 255, 255];
colorribs = [0, 255, 0];
mean_threshold = 18; %voxels
std_threshold = 12;  %voxels
colorMap = [[linspace(0,1,256)';ones(256, 1)], [ones(256, 1);linspace(1,0,256)'],zeros(512,1)];

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/NonScoliotic/Control1a.nii', 5, 3, 1300, 1600, colorribcage);

%%
figure; hold on;
pcshow(pcribcage);
hold off;

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
[pcdeformation_ribs, pcdeformation_ribs_centerlines] = calculate_deformity(pcrib_pairs_centerlines, pcribs, "distance", mean_threshold, std_threshold);

%%
f = figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs);
f.Colormap = colorMap;
colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold+2*std_threshold, 9), 'Parent', f);
caxis([mean_threshold, mean_threshold_derivative+2*std_threshold]);
hold off;

%%
figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines)
    pcshow(pcdeformation_ribs_centerlines{i, 1});
    pcshow(pcdeformation_ribs_centerlines{i, 2});
end
f.Colormap = colorMap;
colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold+2*std_threshold, 9), 'Parent', f);
caxis([mean_threshold, mean_threshold_derivative+2*std_threshold]);
hold off;

%%
[pcdeformation_ribs, pcdeformation_ribs_centerlines] = calculate_deformity(pcrib_pairs_centerlines, pcribs, "derivative2", mean_threshold, std_threshold);

%%
f = figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs);
f.Colormap = colorMap;
colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold+2*std_threshold, 9), 'Parent', f);
caxis([mean_threshold, mean_threshold_derivative+2*std_threshold]);
hold off;

%%
figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines)
    pcshow(pcdeformation_ribs_centerlines{i, 1});
    pcshow(pcdeformation_ribs_centerlines{i, 2});
end
f.Colormap = colorMap;
colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold+2*std_threshold, 9), 'Parent', f);
caxis([mean_threshold, mean_threshold_derivative+2*std_threshold]);
hold off;
