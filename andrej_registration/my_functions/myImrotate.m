function [output] = myImrotate(vol,angle,normal)
output=imrotate3(permute(vol,[2,1,3]),angle,normal,"nearest",'crop');
output=permute(output,[2,1,3]);
end

