function [pcribcage, ribcage, voxeldimensions, unit]=get_ribcage(file_name, closing_kernel, opening_kernel, colorribcage)
    info = niftiinfo(file_name);
    voxeldimensions = info.PixelDimensions;
    unit = info.SpaceUnits;
    originalsize = info.ImageSize;

    voxeldimensions(1) = voxeldimensions(1)/(originalsize(1)/512);
    voxeldimensions(2) = voxeldimensions(2)/(originalsize(2)/512);
    voxeldimensions(3) = voxeldimensions(3)/(originalsize(3)/437);

    image=niftiread(file_name);
    
    image=imresize3(image, [512, 512, 437]);
    image=image(:, :, 1:(size(image, 3) - round(size(image, 3)/10)));
    
    %needed data operation
    image=squeeze(image);

    %thresholing whole image
    thresholds=multithresh(image,2);
    if contains(file_name,"pre")||contains(file_name,"Control")
        if thresholds(2)<1500 && thresholds(2)> 1100
            thresholded=image>thresholds(2)*0.95;
        else
            thresholds=multithresh(image,3);
            thresholded=image>thresholds(3)*0.95;
        end
    elseif contains(file_name,"post")
        thresholds=multithresh(image,3);
        if thresholds(2)>1100
            thresholded=image>thresholds(2) & image<thresholds(3);
        else
            thresholds=multithresh(image,4);
            thresholded=image>thresholds(3)*0.90 & image<thresholds(4);
        end
    else
        error('wrong input file, filename must contain "pre" or "post"')
    end

    thresholded=imopen(thresholded,strel('sphere',1));    
    
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

    pcribcage = voxel_to_pointcloud(bwmorph3(ribcage,'remove'));
    pcribcage = color_pointcloud(pcribcage, colorribcage);
end