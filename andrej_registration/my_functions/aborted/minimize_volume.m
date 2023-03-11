function [outputVolume] = minimize_volume(inputVolume)

% MINIMIZE_VOLUME removes planes that are equal to 0 from a volume
% param inputVolume: rib volume
% returns the reduced volume

inputVolume(:,all(inputVolume==0, [1 3]),:) = [];
inputVolume(all(inputVolume==0, [2 3]),:,:) = [];
inputVolume(:,:,all(inputVolume==0, [1 2])) = [];

outputVolume=inputVolume;

end

