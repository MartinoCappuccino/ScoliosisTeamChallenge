function ribs=get_ribcage(input_volume)
threshold = 1350;
s_closing=5;            %size of structuring element for closing operation
s_opening=3;            %size of structuring element for opening operation

%needed data operation
input_volume=squeeze(input_volume);
%thresholing whole image
thresholded=input_volume>threshold;

%close big holes
thresholded=imclose(thresholded,ones(s_closing,s_closing,s_closing));

%remove small structures
thresholded=imopen(thresholded,ones(s_opening,s_opening,s_opening));

%%get the biggest component should be ribs with spine
CC=bwconncomp(thresholded);

ribs=zeros(size(thresholded));

numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
ribs(CC.PixelIdxList{idx}) = 1;

end