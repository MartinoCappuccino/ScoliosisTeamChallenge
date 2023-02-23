clear all;
close all;

image=niftiread("..\data\Scoliose\4preop.nii");

ribcage=uint8(get_ribcage(image, 5, 3, 1350));
% volshow(ribcage);

niftiwrite(ribcage, "..\data\Scoliose\4preopsegmentation.nii")

% [node,elem,face]=v2m(ribcage,0.5,5,100, 'cgalmesh');
% plotmesh(node, face)
% saveoff((node,3), (face,3), "4preop.off");




