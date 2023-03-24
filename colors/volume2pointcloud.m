function ptcloud=volume2pointcloud(vol)
ptcloud=zeros(sum(vol,'all'),3);
p=1;
for i=1:numel(vol)
    if (vol(i))
        [row,col,slice]=ind2sub(size(vol),i);
        ptcloud(p,1)=row;
        ptcloud(p,2)=col;
        ptcloud(p,3)=slice;
        p=p+1;
    end
end

end