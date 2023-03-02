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
nhood=5;

endpts_left_moved=bwmorph3(rib_left_moved,"endpoints");
[row,col,slice]=ind2sub(size(endpts_left_moved),find(endpts_left_moved==1));
startpts_left_moved=[row,col,slice];
%%check the distance from the center point to both endpoints

if sqrt(sum((startpts_left_moved(1,:) - center) .^ 2))<nhood
    startpt_left_moved=startpts_left_moved(1,:);
else
    startpt_left_moved=startpts_left_moved(2,:);
end

endpts_right_moved=bwmorph3(rib_right_moved,"endpoints");
[row,col,slice]=ind2sub(size(endpts_right_moved),find(endpts_right_moved==1));
startpts_right_moved=[row,col,slice];

if sqrt(sum((startpts_right_moved(1,:) - center) .^ 2))<nhood
    startpt_right_moved=startpts_right_moved(1,:);
else
    startpt_right_moved=startpts_right_moved(2,:);
end

rib_right_moved(startpt_right_moved(1),startpt_right_moved(2),startpt_right_moved(3))=2;
rib_left_moved(startpt_left_moved(1),startpt_left_moved(2),startpt_left_moved(3))=2;  

rib_right_moved_line=volume2line(rib_right_moved);
rib_left_moved_line=volume2line(rib_left_moved);

test=curve_length(rib_left_moved_line);




%%reduce the z direction of the volumes for faster work

height=size(minimize_volume(rib_left_moved+rib_right_moved),3);


%rotation of one rib around z for closer starting point
endpt_right=follow_rib(rib_right_moved);
endpt_left=follow_rib(rib_left_moved);

endpt_right_dir=center-endpt_right;
endpt_left_dir=center-endpt_left;

angle=get_angle([endpt_left_dir(1),endpt_left_dir(2),0],[endpt_right_dir(1),endpt_right_dir(2),0]);
%rib_right_moved=imdilate(rib_right_moved,ones(3,3,3));

rib_right_moved=myImrotate(rib_right_moved,-angle,z);

%skeletonize rib again and find the endpoint again


volshow(rib_left_moved+rib_right_moved);
% 
% imregmoment
% imregister
% imregcorr


