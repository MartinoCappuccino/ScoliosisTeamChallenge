function [pcribcage, ribcage]=get_ribcage(file_name, closing_kernel, opening_kernel, threshold)
    image=niftiread(file_name);

    image=imresize3(image, [512, 512, 437]);

    %needed data operation
    image=squeeze(image);
    
    % Resize the image
    image = imresize3(image, 1);

    %thresholing whole imageS
    thresholded=image>threshold;
    
    %close big holes
    thresholded=imclose(thresholded,strel('sphere', closing_kernel));

    %remove small structures
    thresholded=imopen(thresholded,strel('sphere', opening_kernel));

    %close big holes
    thresholded=imclose(thresholded,strel('sphere', closing_kernel));

    thresholded = imerode(thresholded, strel('sphere', 3));
    
    %%get the biggest component should be ribs with spine
    CC=bwconncomp(thresholded);
    
    ribcage=zeros(size(thresholded));
    
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);

    ribcage(CC.PixelIdxList{idx}) = 1;

    ribcage = imdilate(ribcage, strel('sphere', 2));

    pcribcage = voxel_to_pointcloud(ribcage, [255, 0, 0]);
end