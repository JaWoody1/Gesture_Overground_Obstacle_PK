function [result] = xyz_position_array(x,y,z)
%insert xyz into a single array
    result = [];
    result(:,1) = x;
    result(:,2) = y;
    result(:,3) = z;
end