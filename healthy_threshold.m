clear all;
close all;

warning('off', 'all')
warning

%% Variables

colorribcage = [230, 230, 230];
colorspine = [200, 200, 200];
colorribs = [0, 255, 0];

%% Read image
fstruct = dir("C:\Users\anahs\OneDrive - Universiteit Utrecht\Period3\Team Challenge\Data\Nonscoliotic\Control*a.nii");

for i=1:size(fstruct)
    if i == 1 || i == 2 || i ==7

        file=append(fstruct(i).folder,"\",fstruct(i).name);
        [pcribcage, ribcage]=get_ribcage(file, 5, 3, 1300, 1600, colorribcage);
        [pcspinecenterline, pcspine, pcribs, ribs]=seperate_ribcage(ribcage, colorspine, colorribs);
        [pcindividual_ribs, pcindividual_ribs_centerlines]=seperate_ribs(ribs, pcspinecenterline, pcribs);
        [pcrib_pairs, pcrib_pairs_centerlines] = find_rib_pairs(pcindividual_ribs_centerlines, pcspinecenterline, pcribs);
        [pcdeformation_ribs, pcdeformation_ribs_centerlines,distance,der1,der2] = deformity_threshold(pcrib_pairs_centerlines, pcribs);
        
        for j=1
            figure(i)
            hold on;
            pcshow(pcspine);
            pcshow(pcdeformation_ribs);
        end
    
        hold off;

        healthy(i).distances=distance;
        healthy(i).derivative1=der1;
        healthy(i).derivative2=der2;
        
    end
end

%% Threshold control 

% Remove empty rows (healthy patients not used)
for i = 1:numel(healthy)
    nonempty_rows = ~any(isnan(healthy(i).distances), 2);
    healthy(i).distances = healthy(i).distances(nonempty_rows,:);

    nonempty_rows2 = ~any(isnan(healthy(i).derivative1),2);
    healthy(i).derivative1 = healthy(i).derivative1(nonempty_rows2,:);
    
    nonempty_rows3 = ~any(isnan(healthy(i).derivative2),2);
    healthy(i).derivative2 = healthy(i).derivative2(nonempty_rows3,:);
end

healthy(cellfun(@isempty,{healthy.distances})) = [];
healthy(cellfun(@isempty,{healthy.derivative1})) = [];
healthy(cellfun(@isempty,{healthy.derivative2})) = [];

% calculate mean
for i=1:numel(healthy)
    means_dist(i)=mean(healthy(i).distances(:));
    stand_dist(i)=std(healthy(i).distances(:));

    means_der(i)=mean(healthy(i).derivative1(:));
    stand_der(i)=std(healthy(i).derivative1(:));

    means_der2(i)=mean(healthy(i).derivative2(:));
    stand_der2(i)=std(healthy(i).derivative2(:));   
end

mean_dist = 0;
std_dist = 0;

mean_der = 0;
std_der = 0;

mean_der2 = 0;
std_der2 = 0;

% Calculate total mean and standard deviation
for i = 1:size(means_dist, 2)
    mean_dist = mean_dist + means_dist(i);
    std_dist = std_dist + stand_dist(i)^2;

    mean_der = mean_der + means_der(i);
    std_der = std_der + stand_der(i)^2;

    mean_der2 = mean_der2 + means_der2(i);
    std_der2 = std_der2 + stand_der2(i)^2;
end

std_dist = sqrt(std_dist / size(means_dist, 2));
mean_dist = mean_dist /size(means_dist, 2);

std_der = sqrt(std_der / size(means_der, 2));
mean_der = mean_der /size(means_der, 2);

std_der2 = sqrt(std_der2 / size(means_der2, 2));
mean_der2 = mean_der2 /size(means_der2, 2);