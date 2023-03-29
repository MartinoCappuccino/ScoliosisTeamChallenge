function [pcspinecenterline, pcspine, spine, pcribs, ribs] = seperate_ribcage(ribcage, colorspine, colorribs)
    xs = [];
    ys = [];
    zs = [];
    
    for z = 1:size(ribcage, 3)
       slice = imfill(imclose(imbinarize(squeeze(ribcage(:,:,z))), strel('disk', 5)), 'holes'); 
       
       targetSize=[70 70 300 300];
       
       slice= imcrop(slice,targetSize);
       %imshow(slice,[])
       CC=bwconncomp(slice);
       ROI=zeros(size(slice));
       numPixels = cellfun(@numel,CC.PixelIdxList);
       [biggest,idx] = max(numPixels);
       %Cropping causes a shift in coordinates so correct for this 
       shiftx=(size(ribcage,1)-size(slice,1))/2; 
       shifty=(size(ribcage,1)-size(slice,2))/2; 
       ROI(CC.PixelIdxList{idx}) = 1;
       
       stat = regionprops(logical(ROI),'centroid');
       xs = [xs stat(1).Centroid(2)+shiftx];
       ys = [ys stat(1).Centroid(1)+shifty];
       zs = [zs z];
    end
    
    s = zeros(size(xs));
    for i = 2:length(xs)
      s(i) = s(i-1) + sqrt((xs(i)-xs(i-1))^2+(ys(i)-ys(i-1))^2+(zs(i)-zs(i-1))^2);
    end
    py = polyfit(s,xs,5);
    px = polyfit(s,ys,5);
    pz = polyfit(s,zs,5);
    ss = linspace(0,s(end),50);
    x = polyval(px,ss);
    y = polyval(py,ss);
    z = polyval(pz,ss);
    xpc = polyval(py, ss);
    ypc = polyval(px, ss);
    zpc = polyval(pz, ss);
    pcspinecenterline = pointCloud([xpc(:),ypc(:),zpc(:)]);
    pcspinecenterline = color_pointcloud(pcspinecenterline, colorspine);
    
    radiusx = 65;
    radiusy = [60,50];
    radiusz = [60,40];
    [X, Y, Z] = meshgrid(1:size(ribcage,1), 1:size(ribcage,2), 1:size(ribcage,3));
    mask=zeros(size(ribcage));
    for i=1:length(x)
        if i<30
            sphere_mask = (((X-x(i))/radiusx).^2+((Y-y(i))/radiusy(1)).^2+((Z-z(i))/radiusz(1)).^2) <= 1;
        else
            sphere_mask = (((X-x(i))/radiusx).^2+((Y-y(i))/radiusy(2)).^2+((Z-z(i))/radiusz(2)).^2) <= 1;
        end
        mask = mask + sphere_mask > 0;
    end
    
    spine = double(ribcage + mask > 1);
    pcspine = voxel_to_pointcloud(spine);
    
    pcspine = color_pointcloud(pcspine, colorspine);

    ribs = ribcage - spine;
    pcribs = voxel_to_pointcloud(ribs);
    pcribs = color_pointcloud(pcribs, colorribs);
end