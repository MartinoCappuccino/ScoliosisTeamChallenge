function [outputVolume] = minimize_volume(inputVolume)

%%removes planes that are equal to 0 from a volume and gives the reduced
%%volume back
inputVolume(:,all(inputVolume==0, [1 3]),:) = [];
inputVolume(all(inputVolume==0, [2 3]),:,:) = [];
inputVolume(:,:,all(inputVolume==0, [1 2])) = [];

outputVolume=inputVolume;

end

