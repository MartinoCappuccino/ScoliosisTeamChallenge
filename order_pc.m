function ordered_pc=order_pc(vol)
    %make a orderes pointcloud out of the volume
    idx = find(bwmorph3(vol,'endpoints'));
    [row,col,pag] = ind2sub(size(vol),idx);
    vol=int8(vol);
    vol(row(1),col(1),pag(1))=2;
    vol(row(2),col(2),pag(2))=2;
    ordered_pc=order_points(vol);
    %check thet the start poitn is the top point
    if ordered_pc(1,3)<ordered_pc(end,3)
    ordered_pc=flip(ordered_pc,1);
    end
    if ordered_pc(1,3)<ordered_pc(end,3)
    ordered_pc=flip(ordered_pc,1);
    end
end