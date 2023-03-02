function [length] = curve_length(input_line)
%calculates the curve lenth of a line 
steps=size(input_line,1);

length=0;
for i=2:steps
    eucledian_dist=sqrt(sum((input_line(i,:)-input_line(i-1,:)) .^ 2));
    length=length+eucledian_dist;
end



end

