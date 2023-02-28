function endpt = follow_rib(rib_line,N_steps)
%takes a volume with a line  and the number of steps to travel
%the starting point of the line has to have value 2 all other points have to have value 1 
%returns the point reached after the travel



%check if traveling through the whole rib is required or only until a point
 if ~exist("N_steps")
     % define N_steps as something that will never be reached
      N_steps = -1;
 end

 %zero padding to avoid index position errors (in case a point is at the last index of the volume)
padding=zeros(size(rib_line,1)+2,size(rib_line,2)+2,size(rib_line,3)+2);
padding(2:end-1,2:end-1,2:end-1)=rib_line;
rib_line=padding;


%get one endpoint
%endpt_mat=bwmorph3(rib_line,"endpoints");

%store the position of the endpoint
[row,col,slice]=ind2sub(size(rib_line),find(rib_line==2,1));

%%find next element

endOfRib=false;

current=[row,col,slice];
%previous=current;

test=zeros(size(rib_line));

step=0;
%%checking which of the neighborhood voxels is 1
while endOfRib==false
    test(current(1),current(2),current(3))=1;%test(current(1),current(2),current(3))+1;

    for x=-1:1
        for y=-1:1
            for z=-1:1
                if rib_line(current(1)+x,current(2)+y,current(3)+z)==1
                    %%avoiding to get the previous and the current position
                    if test(current(1)+x,current(2)+y,current(3)+z)==1
                        %do nothing
                    else
                        next=[current(1)+x,current(2)+y,current(3)+z];
                    end
                end
            end
        end

    end
    %if nothing was changed end of rib is reached
    if next==current
        endOfRib=true;
    end

    step =step+1;
    %if number of steps is rached also end the algorithm
    if step==N_steps
        endOfRib=true;
    end
    
    %previous=current;
    current=next;
    

end
endpt=[current(1)-1,current(2)-1,current(3)-1];    %%to compensate for padding the index has to be reduced by one
end

