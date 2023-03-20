function main(filename)
    %% Read image
    image=niftiread(filename);
    image=imresize3(image, [512, 512, 437]);
    
    %% Extract ribcage
    ribcage=uint8(get_ribcage(image, 5, 3, 1350));
    pcribcage = voxel_to_pointcloud(ribcage, [255, 0, 0]);
    
    %% Extract spine and ribs
    [pcspine, pcribs, spine, ribs] = get_points(ribcage, [0, 255, 0], [0, 0, 255]);
    
    %% Extract individual ribs
    % labels = cluster_ribs(pcribs);

    %% Registration of ribs

    %% Calculation of deformity
    
    %% PLOT
    volshow(ribcage)
    volshow(ribs)
    volshow(spine)
    %% PLOT pointclouds
    figure; hold on;
    pcshow(pcribs)
    pcshow(pcspine)
    pcshow(pcribcage)
    set(gcf,'color','w');
    set(gca,'color','w');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    legend('Spine', 'Ribs', 'Ribcage');

end