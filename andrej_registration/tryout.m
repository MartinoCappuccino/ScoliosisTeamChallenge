clear;
load('rib1_skel_end2.mat')
load('rib2_skel_end2.mat')

len=50;                     %length of the part of the rib which is used to point in the same direction

rib_left=minimize_volume(rib_left);
rib_right=minimize_volume(rib_right);

%get the longest coordinate axis and put ribs in a matrix such that
%rotation will not make it bigger

diag1=sqrt(size(rib_right,1)^2+size(rib_right,1)^2+size(rib_right,1)^2);
diag2=sqrt(size(rib_left,1)^2+size(rib_left,1)^2+size(rib_left,1)^2);
a=round(max(diag1,diag2));

center=[a,a,a];     

temp=zeros(2*a,2*a,2*a);
temp(1:size(rib_right,1),1:size(rib_right,2),1:size(rib_right,3))=rib_right;

%put the start point in the center

[row,col,slice]=ind2sub(size(rib_right),find(rib_right==2,1));
startpt_right=[col,row,slice];
trans_vec=center-startpt_right;
rib_right=imtranslate(temp,trans_vec);


temp=zeros(2*a,2*a,2*a);                
temp(1:size(rib_left,1),1:size(rib_left,2),1:size(rib_left,3))=rib_left;

%put the start point in the center
[row,col,slice]=ind2sub(size(rib_left),find(rib_left==2,1));
startpt_left=[col,row,slice];
trans_vec=center-startpt_left;
rib_left=imtranslate(temp,trans_vec);

rib_left_line=volume2line(rib_left);
rib_right_line=volume2line(rib_right);
test2=curve_length(rib_left_line);



%%make the beginnings pointing in the same direction

%%difference in direction

right_dir=follow_rib(rib_right,len)-center;

%%rotate right, that it points in z direction
z=[0 0 1];
normal=cross(right_dir,z);

angle=get_angle(right_dir,z);
rib_right=imdilate(rib_right,ones(5,5,5));
rib_right_moved=myImrotate(rib_right,-angle,normal);

%%rotate left, that it points in z direction

left_dir=follow_rib(rib_left,len)-center;

normal=cross(left_dir,z);

angle=get_angle(left_dir,z);
rib_left=imdilate(rib_left,ones(5,5,5));
rib_left_moved=myImrotate(rib_left,-angle,normal);

rib_left_moved=int16(bwskel(imbinarize(rib_left_moved)));
rib_right_moved=int16(bwskel(imbinarize(rib_right_moved)));

%%put back the two at the beginning of the rib
%%find an endpoint that is close to the center
nhood=10;

endpts_left_moved=bwmorph3(rib_left_moved,"endpoints");
[row,col,slice]=ind2sub(size(endpts_left_moved),find(endpts_left_moved==1));
startpts_left_moved=[row,col,slice];
%%check the distance from the center point to both endpoints

if sqrt(sum((startpts_left_moved(1,:) - center) .^ 2))<nhood
    startpt_left_moved=startpts_left_moved(1,:);
elseif sqrt(sum((startpts_left_moved(2,:) - center) .^ 2))<nhood
    startpt_left_moved=startpts_left_moved(2,:);
else
    error('trouble finding starting point');
end

endpts_right_moved=bwmorph3(rib_right_moved,"endpoints");
[row,col,slice]=ind2sub(size(endpts_right_moved),find(endpts_right_moved==1));
startpts_right_moved=[row,col,slice];

if sqrt(sum((startpts_right_moved(1,:) - center) .^ 2))<nhood
    startpt_right_moved=startpts_right_moved(1,:);
elseif  sqrt(sum((startpts_right_moved(2,:) - center) .^ 2))<nhood
    startpt_right_moved=startpts_right_moved(2,:);
else
    error('trouble finding starting point')
end
%put 2 at the startpoint again
rib_right_moved(startpt_right_moved(1),startpt_right_moved(2),startpt_right_moved(3))=2;
rib_left_moved(startpt_left_moved(1),startpt_left_moved(2),startpt_left_moved(3))=2;  

%make a subsequent set of points to store the lines more efficient than in
%a volume
rib_right_moved_line=volume2line(rib_right_moved);
rib_left_moved_line=volume2line(rib_left_moved);


line_registered = round(rotation_registration(rib_right_moved_line,rib_left_moved_line));



%put the startpoints together again
trans=center-line_registered(1,:);
for i=1:size(rib_left_moved_line,1)
    line_registered(i,:) = line_registered(i,:)+trans;
end


%make a volume from the coordinates again
vol_registered=zeros(size(rib_left));
for i=1:size(line_registered,1)
    vol_registered(line_registered(i,1),line_registered(i,2),line_registered(i,3))=1;
end
volshow(vol_registered(1:550,1:550,1:550)+double(rib_right_moved));





