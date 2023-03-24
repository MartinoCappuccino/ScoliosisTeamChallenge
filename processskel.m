function vol2skelline=processskel(vol)
vol2skel=bwskel(imbinarize(vol),'MinBranchLength',17);
idx = find(bwmorph3(vol2skel,'endpoints'));
[row,col,pag] = ind2sub(size(vol2skel),idx);
vol2skel=int8(vol2skel);
vol2skel(row(1),col(1),pag(1))=2;
vol2skel(row(2),col(2),pag(2))=2;
vol2skelline=volume2line(vol2skel);
%vol2skelline(:,[1,2])=vol2skelline(:,[2 1]);
end