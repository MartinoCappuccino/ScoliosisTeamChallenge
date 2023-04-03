clear all;
close all;

%% Variables
colorribcage = [255, 255, 255];
colorspine = [255, 255, 255];
colorribs = [0, 255, 0];
mean_threshold_distance = 6.66; %mm
std_threshold_distance = 5.24;  %mm
mean_threshold_derivative = 0.11; %mm
std_threshold_derivative = 0.12;  %mm
mean_threshold_derivative2 = 0.0141; %mm
std_threshold_derivative2 = 0.0829;  %mm
colorMap = [[linspace(0,1,256)';ones(256, 1)], [ones(256, 1);linspace(1,0,256)'],zeros(512,1)];

%% Read image
[pcribcage, ribcage, voxeldimensions, units]=get_ribcage('../data/Scoliose/1preop.nii', 5, 3, colorribcage);

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
[pcdeformation_ribs_distance, pcdeformation_ribs_centerlines_distance] = calculate_deformity(pcrib_pairs_centerlines, pcribs, "distance", mean_threshold_distance, std_threshold_distance, voxeldimensions);

%%
f = figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs_distance);
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_distance, mean_threshold_distance+2*std_threshold_distance, 9), 'Parent', f);
c.Label.String = 'Deformation (mm)';
caxis([mean_threshold_distance, mean_threshold_distance+2*std_threshold_distance]);
hold off;

%%
figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines_distance)
    pcshow(pcdeformation_ribs_centerlines_distance{i, 1});
    pcshow(pcdeformation_ribs_centerlines_distance{i, 2});
end
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_distance, mean_threshold_distance+2*std_threshold_distance, 9), 'Parent', f);
c.Label.String = 'Deformation (mm)';
caxis([mean_threshold_distance, mean_threshold_distance+2*std_threshold_distance]);
hold off;

%% Registration of ribs and calculation of deformity
[pcdeformation_ribs_derivative, pcdeformation_ribs_centerlines_derivative] = calculate_deformity(pcrib_pairs_centerlines, pcribs, "derivative", mean_threshold_derivative, std_threshold_derivative, voxeldimensions);

%%
f = figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs_derivative);
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold_derivative+2*std_threshold_derivative, 9), 'Parent', f);
c.Label.String = 'Deformation (no unit)';
caxis([mean_threshold_derivative, mean_threshold_derivative+2*std_threshold_derivative]);
hold off;

%%
figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines_derivative)
    pcshow(pcdeformation_ribs_centerlines_derivative{i, 1});
    pcshow(pcdeformation_ribs_centerlines_derivative{i, 2});
end
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative, mean_threshold_derivative+2*std_threshold_derivative, 9), 'Parent', f);
c.Label.String = 'Deformation (no unit)';
caxis([mean_threshold_derivative, mean_threshold_derivative+2*std_threshold_derivative]);
hold off;

%% Registration of ribs and calculation of deformity
[pcdeformation_ribs_derivative2, pcdeformation_ribs_centerlines_derivative2] = calculate_deformity(pcrib_pairs_centerlines, pcribs, "derivative2", mean_threshold_derivative2, std_threshold_derivative2, voxeldimensions);

%%
f = figure; hold on;
pcshow(pcspine);
pcshow(pcdeformation_ribs_derivative2);
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative2, mean_threshold_derivative2+2*std_threshold_derivative2, 9), 'Parent', f);
c.Label.String = 'Deformation (mm^-1)';
caxis([mean_threshold_derivative2, mean_threshold_derivative2+2*std_threshold_derivative2]);
hold off;

%%
figure; hold on;
pcshow(pcspine);
for i=1:length(pcdeformation_ribs_centerlines_derivative2)
    pcshow(pcdeformation_ribs_centerlines_derivative2{i, 1});
    pcshow(pcdeformation_ribs_centerlines_derivative2{i, 2});
end
f.Colormap = colorMap;
c = colorbar('Color', [1 1 1], 'Box', 'off', 'Ticks', linspace(mean_threshold_derivative2, mean_threshold_derivative2+2*std_threshold_derivative2, 9), 'Parent', f);
c.Label.String = 'Deformation (mm^-1)';
caxis([mean_threshold_derivative2, mean_threshold_derivative2+2*std_threshold_derivative2]);
hold off;