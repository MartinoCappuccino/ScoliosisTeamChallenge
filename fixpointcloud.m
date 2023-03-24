%Steps prior to this function
% left_line=processskel(niftiread('L5g.nii.gz'));
% cloud1=pointCloud(left_line)
% colored=cloudviewer(distance,corresp_pts_registered,registered)
% ptCloudOut = pcdownsample(colored,'random',0.984);
% fix=fixpointcloud(colored,ptCloudOut)
% cloud1.Color=zeros(size(cloud1.Location));
% cloud1.Color=fix.Color;
% cloud1.Color=flip(fix.Color);
function fixcloud2=fixpointcloud(cloud1,cloud2)
%     cloud1=cloud1.Location;
%     cloud2=cloud2.Location;

    %Input is a registerd colored pointcloud and its corresponding downsampled pointcloud 
    %The downsampled pointcloud has the same dimensions as the pointcloud
    %from the original rib centerline 
    
    
    fixcloud=zeros(size(cloud2.Location));
    color=zeros(size(cloud2.Location));
    for i=1:size(cloud2.Location,1)
        [~,d1,first] = intersect(cloud1.Location(i,:),cloud2.Location,'rows');
        if size(first,1)==0
            
        else
           fixcloud(i,:)=cloud2.Location(first,:);
           color(i,:)=cloud1.Color(i,:);
        end
        
    end
    fixcloud2=pointCloud(fixcloud);
    fixcloud2.Color=uint8(color);

end


