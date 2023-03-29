clear all;
close all;

%% Variables
colorribcage = [255, 0, 0];
colorspine = [0, 255, 0];
colorribs = [0, 0, 255];

%% Read image
[pcribcage, ribcage]=get_ribcage('../data/Scoliose/1preop.nii', 5, 3, 1350, colorribcage);

%% Extract spine and ribs
[pcspinecenterline, pcspine, spine, pcribs, ribs]=seperate_ribcage(ribcage, colorspine, colorribs);

%% Extract individual ribs
[pcindividual_ribs, individual_ribs]=seperate_ribs(ribs, pcspinecenterline);

%% Find corresponding ribs
[pcrib_pairs, rib_pairs] = find_rib_pairs(pcindividual_ribs, individual_ribs, pcspinecenterline);

%% Registration of ribs and calculation of deformity
pcdeformation_ribcage = color_deformity(pcrib_pairs,ribcage);

