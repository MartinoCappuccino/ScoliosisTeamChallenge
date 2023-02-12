%get center point of each rib per slice

function store_edge=getedge(inputimage)


image=niftiread("Scoliose\Scoliose\1preop.nii");
    
threshold = 1250;
s_closing=6;            %size of structuring element for closing operation
s_opening=5;            %size of structuring element for opening operation

store_edge=zeros(437,512);

for k=100:105
    slice=imrotate(squeeze(image(:,k,:)),90);
    
    thresholded=slice>threshold;
    %close big holes
    thresholded=imclose(thresholded,ones(s_closing,s_closing,s_closing));

    %remove small structures
    thresholded=imopen(thresholded,ones(s_opening,s_opening,s_opening));
    
    BW_filled = imfill(thresholded,'holes');
    boundaries = bwboundaries(BW_filled);
    
    figure,imshow(slice,[]);
    hold on
    for l=1:size(boundaries,1)
        b = boundaries{l};
        plot(b(:,2),b(:,1),'g','LineWidth',3);
        [CoMx, CoMy] = centroid(polyshape(b(:,2), b(:,1)));  % Center of Mass
        hold on
        plot(CoMx, CoMy, '*k');
        
    end
    
    %imshow(thresholded,[]);
end


end