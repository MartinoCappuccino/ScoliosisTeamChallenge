clear
V1=niftiread('R5.nii.gz');
V2=niftiread('L5g.nii.gz');
V2=flip(V2,3);              %needed to firror a rib

V1=bwskel(imbinarize(V1),'MinBranchLength',5);
V2=bwskel(imbinarize(V2),'MinBranchLength',5);

V1=double(V1);
V2=double(V2);

endpts1=bwmorph3(V1,'endpoints');
endpts2=bwmorph3(V2,'endpoints');

[row,col,slice]=ind2sub(size(endpts1),find(endpts1==1,2));
V1(row(2),col(2),slice(2))=2;


[row,col,slice]=ind2sub(size(endpts2),find(endpts2==1,2));
V2(row,col,slice)=2;

line1=volume2line(V1);
line2=volume2line(V2);

registered=round(MyRegistration(line1,line2));

% vol_registered=zeros(size(V1));
% for i=1:size(registered,1)
%     vol_registered(registered(i,1),registered(i,2),registered(i,3))=1;
% end
pcshow(registered);
hold on
pcshow(line1);

[corresp_pts1,corresp_pts_registered]=get_corresp_pts(line1,registered,20);
[distance,derivative]=distances(corresp_pts1,corresp_pts_registered);




%volshow(registered+V1)