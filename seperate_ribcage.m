function [pcspinecenterline, pcspine, pcribs, ribs] = seperate_ribcage(ribcage, colorspine, colorribs)
    xs = [];
    ys = [];
    zs = [];
    
    slice = imfill(imclose(imbinarize(squeeze(ribcage(:,:,int16(size(ribcage, 3)/100)))), strel('disk', 5)), 'holes'); 
    CC=bwconncomp(slice);
    ROI=zeros(size(slice));
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    ROI(CC.PixelIdxList{idx}) = 1;
    stat = regionprops(logical(ROI),'centroid');
    rect = [stat(1).Centroid(1) - 150 stat(1).Centroid(2) - 150 stat(1).Centroid(1) + 150 stat(1).Centroid(2) + 150];
    slice = imcrop(slice, rect);   

    for z = 1:size(ribcage, 3)
       slice = imfill(imclose(imbinarize(squeeze(ribcage(:,:,z))), strel('disk', 5)), 'holes'); 
       
       slice = imcrop(slice, rect);

       CC=bwconncomp(slice);
       ROI=zeros(size(slice));
       numPixels = cellfun(@numel,CC.PixelIdxList);
       [biggest,idx] = max(numPixels);

       if CC.NumObjects~=0
           ROI(CC.PixelIdxList{idx}) = 1;
       
           stat = regionprops(logical(ROI),'centroid');
           xs = [xs stat(1).Centroid(2)+rect(2)];
           ys = [ys stat(1).Centroid(1)+rect(1)];
           zs = [zs z];
       end
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
    
    radiusx = 100;
    radiusy = 50;
    radiusz = 60;
    [X, Y, Z] = meshgrid(1:size(ribcage,1), 1:size(ribcage,2), 1:size(ribcage,3));
    mask=zeros(size(ribcage));
    for i=1:length(x)
        sphere_mask = (((X-x(i))/radiusx).^2+((Y-y(i))/radiusy(1)).^2+((Z-z(i))/radiusz(1)).^2) <= 1;
        mask = mask + sphere_mask > 0;
    end
    
    spine = double(ribcage + mask > 1);
    pcspine = color_pointcloud(voxel_to_pointcloud(bwmorph3(spine, 'remove')), colorspine);

    ribs = ribcage - spine;
    pcribs = color_pointcloud(voxel_to_pointcloud(bwmorph3(ribs, 'remove')), colorribs);
end