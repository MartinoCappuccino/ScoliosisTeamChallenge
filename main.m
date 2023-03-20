clear all;
close all;

image=niftiread("..\data\Scoliose\1preop.nii");

ribcage=uint8(get_ribcage(image, 5, 3, 1350));

pcribcage = voxel_to_pointcloud(ribcage, [255, 0, 0]);

[pcspine, pcribs] = get_points(ribcage, colorspine=[0 255 0], colorribs=[0 0 255]);

labels = cluster_ribs(pcribs);

% Color code the point cloud based on the labels
figure;
colormap = hsv(max(labels));
colors = colormap(labels,:);
pcshow(pcribs.Location, colors);
axis equal;

% Generate separate point clouds for each label
for i = 1:max(labels)
    figure;
    label_points = pcribs.Location(labels == i,:);
    pcshow(label_points, colormap(i,:));
    axis equal;
    title(sprintf('Label %d', i));
end

%% PLOT
figure;
pcshow(pcribs)
hold on;
pcshow(pcspine)
pcshow(pcribcage)
set(gcf,'color','w');
set(gca,'color','w');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('Spine', 'Ribs', 'Ribcage');ni
    
