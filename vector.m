function [distance] = vector(Shoulder1, Wrist1, Shoulder2, Wrist2, Shoulder3, Wrist3)
%Vector
%Take in shoulder position and the wrist position using x,y,z and calculate
%the distance between the should and the wrist

distance = sqrt((Shoulder1-Wrist1^2) + (Shoulder2-Wrist2^2) + (Shoulder3-Wrist3^2));

end