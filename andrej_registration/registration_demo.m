clear;

%%demo file to show how MyRegistration works. 

load('rib1_skel_end2.mat')
load('rib2_skel_end2.mat')

%putting ribs from volumes into lines
line_moving=volume2line(rib_right);
line_fixed=volume2line(rib_left);

%registration
line_registered = round(MyRegistration(line_fixed,line_moving));

%put lines back into volume for visualization NOTE: IF THE COORDINATES OF
%THE REGISTERED RIB ARE OUTSIDE OF THE VOLUME OF THE FIXED RIB THIS DOES
%NOT WORK 
vol_registered=zeros(size(rib_left));
for i=1:size(line_registered,1)
    vol_registered(line_registered(i,1),line_registered(i,2),line_registered(i,3))=1;
end

volshow(vol_registered+double(rib_left))