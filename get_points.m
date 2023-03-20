function [pcspine, pcribs] = get_points(image, colorspine, colorribs)
    xs = [];
    ys = [];
    zs = [];
    xr = [];
    yr = [];
    zr = [];
    for x = 1:size(image, 1)
       slice = imfill(imclose(imbinarize(squeeze(image(x,:,:))), strel('disk', 5)), 'holes');
       slice = xor(bwareaopen(slice,200),  bwareaopen(slice,800));
       stat = regionprops(logical(slice),'centroid');
       for i = 1:numel(stat)
          xr = [xr x];
          yr = [yr stat(i).Centroid(2)];
          zr = [zr stat(i).Centroid(1)];
       end

    end
    for y = 1:size(image, 2)
       slice = imfill(imclose(imbinarize(squeeze(image(:,y,:))), strel('disk', 5)), 'holes');
       slice = xor(bwareaopen(slice,200),  bwareaopen(slice,800));
       stat = regionprops(logical(slice),'centroid');
       for i = 1:numel(stat)
          xr = [xr stat(i).Centroid(2)];
          yr = [yr y];
          zr = [zr stat(i).Centroid(1)];
       end

    end
    for z = 1:size(image, 3)
       slice = imfill(imclose(imbinarize(squeeze(image(:,:,z))), strel('disk', 5)), 'holes');
       CC=bwconncomp(slice);
       ROI=zeros(size(slice));
       numPixels = cellfun(@numel,CC.PixelIdxList);
       [biggest,idx] = max(numPixels);
       ROI(CC.PixelIdxList{idx}) = 1;
       stat = regionprops(logical(ROI),'centroid');
       xs = [xs stat(1).Centroid(2)];
       ys = [ys stat(1).Centroid(1)];
       zs = [zs z];
       
       slice(CC.PixelIdxList{idx}) = 0;
       slice = xor(bwareaopen(slice,200),  bwareaopen(slice,800));
       stat = regionprops(logical(slice),'centroid');
       for i = 1:numel(stat)
          xr = [xr stat(i).Centroid(2)];
          yr = [yr stat(i).Centroid(1)];
          zr = [zr z];
       end

    end

    pcspine = pointCloud([xs(:),ys(:),zs(:)]);

    x = points.Location(:,1);
    y = points.Location(:,2);
    z = points.Location(:,3);
    s = zeros(size(x));
    for i = 2:length(x)
      s(i) = s(i-1) + sqrt((x(i)-x(i-1))^2+(y(i)-y(i-1))^2+(z(i)-z(i-1))^2);
    end
    px = polyfit(s,x,6);
    py = polyfit(s,y,6);
    pz = polyfit(s,z,6);
    ss = linspace(0,s(end),100);
    x = polyval(px,ss);
    y = polyval(py,ss);
    z = polyval(pz,ss);
    pcspine = pointCloud([x(:),y(:),z(:)]);
    pointscolor=uint8(zeros(pcspine.Count,3));
    pointscolor(:,1)=colorspine(0);
    pointscolor(:,2)=colorspine(1);
    pointscolor(:,3)=colorspine(2);
    pcspine.Color=pointscolor;

    pcribs = pointCloud([xr(:),yr(:),zr(:)]);
    pointscolor=uint8(zeros(pcribs.Count,3));
    pointscolor(:,1)=colorribs(0);
    pointscolor(:,2)=colorribs(1);
    pointscolor(:,3)=colorribs(2);
    pcribs.Color=pointscolor;
end