function [output] = myImrotate(rib_volume,angle,vector)
% MYIMROTATE rotates a rib (in a volume) around a vector with a certain angle
% param rib_volume: 3D volume of a rib
% param angle: angle between rib volume and vector
% param: vector around which rib is rotated
% returns the rib volume rotated

output=imrotate3(permute(rib_volume,[2,1,3]),angle,vector,"nearest",'crop');
% change x, y coordinates since imrotate3 changes its positions 
output=permute(output,[2,1,3]);

end

