clear all
close all
%%this code shows the functionality of the get_ribcage function, currently
%%that funciton is a basic function to segment the ribs with the spine

image=niftiread(".\Scoliose\1preop.nii");


%volumeViewer(image)        %shows the original image 

ribcage=get_ribcage(image);
%shows the ribcage
volshow(ribcage)

mirrorcage=flip(ribcage,1);

funimage=ribcage+mirrorcage;

%volshow(funimage);        %shows the ribcage and its mirrored image in one image




