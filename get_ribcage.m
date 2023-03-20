function ribcage=get_ribcage(input_volume, closing_kernel, opening_kernel, threshold)
    %needed data operation
    input_volume=squeeze(input_volume);
    
    % Resize the image
    input_volume = imresize3(input_volume, 1);

    %thresholing whole imageS
    thresholded=input_volume>threshold;
    
    %close big holes
    thresholded=imclose(thresholded,strel('sphere', closing_kernel));

    %remove small structures
    thresholded=imopen(thresholded,strel('sphere', opening_kernel));

    %close big holes
    thresholded=imclose(thresholded,strel('sphere', closing_kernel));
    
    %%get the biggest component should be ribs with spine
    CC=bwconncomp(thresholded);
    
    ribcage=zeros(size(thresholded));
    
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);

    ribcage(CC.PixelIdxList{idx}) = 1;
end