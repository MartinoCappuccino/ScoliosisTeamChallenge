clear all
close all

%load ribs
load('rib1.mat');
load('rib2.mat');

rib_left=int16(rib_left);
rib_right=int16(rib_right(1:256,:,:));

%plot ribs supperpose
volshow(rib_left+rib_right)

%Registration for the ribs
fixed = rib_left;
moving = rib_right;

[geomtform,movingRegisteredVoxels] = imregmoment(moving,fixed);

volshow(movingRegisteredVoxels+fixed);

%Registration for one rib and a straight line
%create a straight line
plane=int16(ones(size(moving)));
plane(2:end,:,:)=0;
plane(:,2:end,:)=0;

volshow(plane+rib_left);

[geomtform,movingRegisteredVoxels] = imregmoment(plane,fixed);

volshow(movingRegisteredVoxels+fixed);
